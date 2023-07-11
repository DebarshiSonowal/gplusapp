import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class PostAListing extends StatefulWidget {
  const PostAListing({Key? key}) : super(key: key);

  @override
  State<PostAListing> createState() => _PostAListingState();
}

class _PostAListingState extends State<PostAListing>
    with WidgetsBindingObserver {
  final title = TextEditingController();
  final localityEditor = TextEditingController();

  final desc = TextEditingController();

  final price = TextEditingController();
  AndroidDeviceInfo? androidInfo;

  var current = 3;

  var category = [
    'Vehicles',
    'House',
  ];
  var selectedCategory;
  var selectedLocality;
  var locality = ['Rukminigaon', 'Khanapara', 'Beltola', ''];

  ImagePicker _picker = ImagePicker();

  List<File> attachements = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchClassified();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    title.dispose();
    desc.dispose();
    price.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("didChangeAppLifecycleState $state");
    if (state == AppLifecycleState.resumed) {
      debugPrint("didChangeAppLifecycleState inside $state");
      try {
        getIsNotAndroid13() ? getLostData() : () {};
      } catch (e) {
        debugPrint("what error $e");
      }
    }
  }

  Future<void> getLostData() async {
    if (await Permission.storage.request().isGranted) {
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.isEmpty) {
        debugPrint("didChangeAppLifecycleState isEmpty");
        return;
      }
      if (response.files != null) {
        debugPrint("didChangeAppLifecycleState isNotEmpty");
        for (final XFile file in response.files!) {
          setState(() {
            attachements.add(
              File(file.path),
            );
          });
        }
      } else {
        debugPrint("${response.exception!}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: Constance.buildAppBar2("classified"),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post a story',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Consumer<DataProvider>(builder: (context, data, _) {
                  return Container(
                    constraints: const BoxConstraints(maxHeight: 100),
                    child: DropdownButtonFormField(
                      menuMaxHeight: 50.h,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      dropdownColor: Storage.instance.isDarkMode
                          ? Colors.black
                          : Colors.white,
                      // Initial Value
                      value: selectedCategory,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      items: [
                        for (var i in data.classified_category)
                          DropdownMenuItem(
                            value: i.id.toString(),
                            child: Text(
                              i.title ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white70
                                        : Constance.primaryColor,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          )
                      ],
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (newValue) {
                        print("value: $newValue");
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                    ),
                  );
                }),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'Add your locality',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 1.h,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: localityEditor,
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    labelText: 'Enter your locality',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.5.h,
                        ),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: title,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    labelText: 'Enter the title',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.5.h,
                        ),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: desc,
                  // textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    labelText: 'Enter the details',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.5.h,
                        ),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.attach_file,
                      color: Storage.instance.isDarkMode
                          ? Constance.secondaryColor
                          : Colors.black,
                    ),
                    Text(
                      'Add attachments',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            // fontSize: 1.6.h,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    (attachements.length ?? 0) + 1,
                    (pos) => (pos == attachements.length)
                        ? GestureDetector(
                            onTap: () {
                              request();
                            },
                            child: Container(
                              height: 8.h,
                              width: 20.w,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 8.h,
                                width: 20.w,
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Image.file(
                                    attachements[pos],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    attachements.removeAt(pos);
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.white,
                                  child: Icon(
                                    Icons.remove,
                                    color: Constance.thirdColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Add Price',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: price,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    labelText: 'Enter the price',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.5.h,
                        ),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By clicking "Submit" you agreed to our ',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black54,
                              // fontSize: 1.6.h,
                            ),
                      ),
                      TextSpan(
                        text: 'Terms & Conditions.',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              // fontSize: 1.6.h,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigation.instance.navigate('/termsConditions');
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onTap: () {
                      // showDialogBox();
                      if (title.text.isNotEmpty &&
                          desc.text.isNotEmpty &&
                          price.text.isNotEmpty &&
                          localityEditor.text.isNotEmpty) {
                        logTheClassifiedSubmitClick(
                          Provider.of<DataProvider>(
                                  Navigation.instance.navigatorKey
                                          .currentContext ??
                                      context,
                                  listen: false)
                              .profile!,
                          (Provider.of<DataProvider>(
                                      Navigation.instance.navigatorKey
                                              .currentContext ??
                                          context,
                                      listen: false)
                                  .classified_category
                                  .firstWhere((element) =>
                                      element.id.toString().trim() ==
                                      selectedCategory.toString().trim()))
                              .title
                              .toString()
                              .toLowerCase(),
                          localityEditor.text,
                          title.text,
                          desc.text,
                          price.text,
                        );
                        postClassified(selectedCategory, localityEditor.text,
                            title.text, desc.text, price.text, attachements);
                      } else {
                        showError(
                            "Title, Description and Price is mandatory to post");
                      }
                    },
                    txt: 'Submit',
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(current, "classified"),
      ),
    );
  }

  void showPhotoBottomSheet(Function(int) getImage) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    BuildContext? context = Navigation.instance.navigatorKey.currentContext;
    if (context != null) {
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Center(
                    child: Text(
                  "Add Photo",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                )),
                contentPadding: const EdgeInsets.only(top: 24, bottom: 30),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getIsNotAndroid13()
                            ? InkWell(
                                onTap: () {
                                  Navigation.instance.goBack();
                                  getImage(0);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.pink.shade300),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      "Camera",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: getIsNotAndroid13() ? 42 : 0,
                        ),
                        InkWell(
                            onTap: () {
                              Navigation.instance.goBack();
                              getImage(1);
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.purple.shade300),
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  "Gallery",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                    Platform.isAndroid? Container(
                      margin: EdgeInsets.only(top: 1.5.h),
                      width: 50.w,
                      child: Constance.androidWarning,
                    ):Container(),
                  ],
                ));
          });
    }
  }

  Future<void> getProfileImage(int index) async {
    if (index == 0) {
      if (await Permission.camera.request().isGranted) {
        // final pickedFile = await _picker
        //     .pickImage(
        //   source: ImageSource.camera,
        //   imageQuality: 70,
        // )
        //     .catchError((er) {
        //   debugPrint("error $er}");
        // });
        List<Media>? res = await ImagesPicker.openCamera(
          pickType: PickType.image,
        );
        if (res != null) {
          setState(() {
            attachements.add(
              File(res[0].path),
            );
          });
          // }
        }
      } else {
        showErrorStorage('Permission Denied');
      }
    } else {
      if (getIsNotAndroid13()
          ? (await Permission.storage.request().isGranted)
          : (await Permission.photos.request().isGranted)) {
        if (getIsNotAndroid13()) {
          List<Media>? res = await ImagesPicker.pick(
            count: 3,
            pickType: PickType.image,
          );
          if (res != null) {
            setState(() {
              for (var i in res) {
                attachements.add(
                  File(i.path),
                );
              }
            });
          }
        } else {
          _picker = ImagePicker();
          final pickedFile = await _picker.pickMultiImage(
            imageQuality: 70,
          );
          if (pickedFile != null) {
            setState(() {
              for (var i in pickedFile) {
                attachements.add(
                  File(i.path),
                );
              }
            });
          }
        }
      } else {
        showErrorStorage('Permission Denied');
      }
    }
  }

  getIsNotAndroid13() {
    if (Platform.isAndroid) {
      return ((androidInfo?.version.sdkInt ?? 0) < 32);
    } else {
      return true;
    }
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Be a journalist!',
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Constance.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.podcast,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Hello Jonathan!',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                  ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                  ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                  ' remaining essentially unchanged',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchClassified() async {
    if (Platform.isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
    }
    // showLoaderDialog(context);
    final response = await ApiProvider.instance.getClassifiedCategory();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      print(response.categories);
      setState(() {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setClassifiedCategory(response.categories ?? []);
        // selectedCategory = response.categories![0].id.toString();
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setLocality(response.localities ?? []);
        // selectedLocality = response.localities![0].id.toString();
      });
    } else {
      setState(() {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setClassifiedCategory(response.categories ?? []);
        // selectedCategory = response.categories![0].id.toString();
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setLocality(response.localities ?? []);
        // selectedLocality = response.localities![0].id.toString();
      });
      // Navigation.instance.goBack();
      // showError("Something went wrong");
    }
  }

  void logTheClassifiedSubmitClick(
      Profile profile,
      String story_category_selected,
      String locality,
      String title,
      String field_entered,
      String price) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "classified_submit_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "story_category_selected": story_category_selected,
        "locality": locality,
        "title": title.length > 100 ? title.substring(0, 100) : title,
        "field_entered": field_entered.length > 100
            ? field_entered.toString().substring(0, 100)
            : field_entered,
        "price": price,
        // "cta_click": cta_click,
        "screen_name": "post_a_listing",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void postClassified(classified_category_id, locality_name, title, description,
      price, List<File> files) async {
    Navigation.instance.navigate('/loadingDialog');
    final reponse = await ApiProvider.instance.postClassified(
        classified_category_id,
        locality_name,
        title,
        description,
        price,
        files);
    if (reponse.success ?? false) {
      Fluttertoast.showToast(msg: "Posted successfully");
      Navigation.instance.goBack();
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError("Something went wrong");
    }
  }

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }

  void request() async {
    Map<Permission, PermissionStatus> statuses = await [
      getIsNotAndroid13() ? Permission.storage : Permission.photos,
      Permission.camera,
    ].request();
    statuses.forEach((permission, status) {
      if (status.isGranted) {
        // Permission granted

        debugPrint('${permission.toString()} granted.');
      } else if (status.isDenied) {
        // Permission denied
        // showErrorStorage('${permission.toString()} denied.');
        debugPrint('${permission.toString()} denied.');
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied

        debugPrint('${permission.toString()} permanently denied.');
      }
    });
    setState(() {
      showPhotoBottomSheet(getProfileImage);
    });
  }

  void showErrorStorage(String msg) {
    AlertX.instance.showAlert(
      title: msg,
      msg: "Please Go To Settings and Provide the Storage Permission",
      negativeButtonText: "Close",
      negativeButtonPressed: () {
        Navigation.instance.goBack();
      },
      positiveButtonText: "Go to Settings",
      positiveButtonPressed: () async {
        Navigation.instance.goBack();
        await OpenSettings.openAppSetting();
      },
    );
  }
}
