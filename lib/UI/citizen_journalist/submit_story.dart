import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class SubmitStoryPage extends StatefulWidget {
  const SubmitStoryPage({super.key});

  @override
  State<SubmitStoryPage> createState() => _SubmitStoryPageState();
}

class _SubmitStoryPageState extends State<SubmitStoryPage>
    with WidgetsBindingObserver {
  var title = TextEditingController();
  var desc = TextEditingController();
  AndroidDeviceInfo? androidInfo;
  var current = 3;
  List<File> attachements = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // getIsNotAndroid13() ? getLostData() : () {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("citizen_journalist"),
      // drawer: BergerMenuMemPage(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  'Submit A Story',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      fontWeight: FontWeight.bold),
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
                controller: title,
                // maxLines: 2,
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
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
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
                        ? Colors.white
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
                            debugPrint("Image added successfully pre 2");
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
                                child: const Icon(
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
                height: 5.h,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 5.h,
                      width: 40.w,
                      child: CustomButton(
                        onTap: () {
                          // showDialogBox();
                          if (title.text.isNotEmpty && desc.text.isNotEmpty) {
                            logTheCjSubmitClick(Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .profile!);
                            postStory(1);
                          } else {
                            showError(
                                "Title and Description is mandatory to post");
                          }
                        },
                        txt: 'Submit',
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                      width: 40.w,
                      child: CustomButton(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fcolor: Storage.instance.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        onTap: () {
                          // showDialogBox();
                          if (title.text.isNotEmpty && desc.text.isNotEmpty) {
                            logTheCjDraftSubmitClick(
                              Provider.of<DataProvider>(
                                      Navigation.instance.navigatorKey
                                              .currentContext ??
                                          context,
                                      listen: false)
                                  .profile!,
                              title.text,
                              desc.text,
                            );
                            postStory(0);
                          } else {
                            showError(
                                "Title and Description is mandatory to post");
                          }
                        },
                        txt: 'Save as draft',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current, "citizen_journalist"),
    );
  }

  void request() async {
    Map<Permission, PermissionStatus> statuses = await [
      getIsNotAndroid13() ? Permission.storage : Permission.photos,
      Permission.camera,
    ].request();
    statuses.forEach((permission, status) {
      debugPrint("Image added successfully pre 1");
      if (status.isGranted) {
        // Permission granted
        debugPrint('${permission.toString()} granted.');
      } else if (status.isDenied) {
        // Permission denied
        // showErrorStorage('${permission.toString()} denied.');
        debugPrint('${permission.toString()} denied.');
        // showErrorStorage('${permission.toString()} denied.');
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied
        showErrorStorage('${permission.toString()} denied.');
        // debugPrint('${permission.toString()} permanently denied.');
      }
      setState(() {
        showPhotoBottomSheet(getProfileImage);
      });
    });
  }

  getIsNotAndroid13() {
    if (Platform.isAndroid) {
      return ((androidInfo?.version.sdkInt ?? 0) < 32);
    } else {
      return true;
    }
  }

  void logTheCjSubmitClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "cj_submit_a_story_final",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "post": post,
        // "cta_click": cta_click,
        "screen_name": "citizen_journalist",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
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

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
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
              ),
            ),
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
                                      borderRadius: BorderRadius.circular(30),
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
                Platform.isAndroid
                    ? Container(
                        margin: EdgeInsets.only(top: 1.5.h),
                        width: 50.w,
                        child: Constance.androidWarning,
                      )
                    : Container(),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> getProfileImage(int index) async {
    debugPrint("Image added pre ");
    if (index == 0) {
      if (await Permission.camera.request().isGranted) {
        // List<Media>? res = await ImagesPicker.openCamera(
        //   pickType: PickType.image,
        // );
        // if (res != null) {
        //   setState(() {
        //     attachements.add(
        //       File(res[0].path),
        //     );
        //   });
        //   // }
        // }
        final pickedFile = await _picker
            .pickImage(
          source: ImageSource.camera,
          imageQuality: 70,
        ).catchError((er) {
          debugPrint("error $er}");
        });
        if (pickedFile != null) {
          setState(() {
            attachements.add(
              File(pickedFile.path),
            );
          });
        } else {
          showErrorStorage('Permission Denied');
        }
      }
    } else {
      debugPrint("Image added successfully pre ");
      if (!getIsNotAndroid13()
          ? (await Permission.storage.request().isGranted)
          : (await Permission.photos.request().isGranted)) {
        if (!getIsNotAndroid13()) {
          debugPrint("Image added successfully1 pre ");
          List<Media>? res = await ImagesPicker.pick(
            count: 3,
            pickType: PickType.image,
          );
          if (res != null) {
            debugPrint("Image added successfully1 ");
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
          debugPrint("Image added successfully2 pre ");
          final pickedFile = await _picker.pickMultiImage(
            imageQuality: 70,
          );
          if (pickedFile != null) {
            debugPrint("Image added successfully2");
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    title.dispose();
    desc.dispose();
    super.dispose();
    // title.dispose();
  }

  void logTheCjDraftSubmitClick(
      Profile profile, String title, String field_entered) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "save_as_draft_final",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "post": post,
        "title": title.length > 100 ? title.substring(0, 100) : title,
        "field_entered": field_entered.length > 100
            ? field_entered.substring(0, 100)
            : field_entered,
        "cta_click": "save_as_draft",
        "screen_name": "citizen_journalist",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void postStory(is_story_submit) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.postCitizenJournalist(
        title.text, desc.text, attachements, is_story_submit);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Posted successfully");
      Navigation.instance.goBack();
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }
}
