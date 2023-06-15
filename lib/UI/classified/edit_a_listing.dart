import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import '../../Model/attach_file.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class EditAListingPost extends StatefulWidget {
  final int id;

  //
  const EditAListingPost(this.id);

  @override
  State<EditAListingPost> createState() => _EditAListingPostState();
}

class _EditAListingPostState extends State<EditAListingPost> {
  final title = TextEditingController();

  final desc = TextEditingController();

  final price = TextEditingController();

  var current = 3;

  var category = [
    'Vehicles',
    'House',
  ];
  var selectedCategory = '';
  var selectedLocality = '';
  var locality = ['Rukminigaon', 'Khanapara', 'Beltola', ''];
  final localityEditor = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<AttachFile> images = [];
  List<File> attachements = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchDetails();
      fetchClassified();
    });
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    desc.dispose();
    price.dispose();
    localityEditor.dispose();
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 0.3.h,
              ),
              Consumer<DataProvider>(builder: (context, data, _) {
                return DropdownButton(
                  dropdownColor:
                      Storage.instance.isDarkMode ? Colors.black : Colors.white,
                  // Initial Value
                  value: selectedCategory,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: data.classified_category
                      .map((e) => DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(
                              e.title ?? "",
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
                          ))
                      .toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                );
              }),
              Text(
                'Add your locality',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Constance.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 0.3.h,
              ),
              // Consumer<DataProvider>(builder: (context, data, _) {
              //   return DropdownButton(
              //     dropdownColor:
              //         Storage.instance.isDarkMode ? Colors.black : Colors.white,
              //     // Initial Value
              //     value: selectedLocality,
              //
              //     // Down Arrow Icon
              //     icon: const Icon(Icons.keyboard_arrow_down),
              //
              //     // Array list of items
              //     items: data.locality
              //         .map((e) => DropdownMenuItem(
              //               value: e.id.toString(),
              //               child: Text(
              //                 e.name ?? "",
              //                 style: Theme.of(context)
              //                     .textTheme
              //                     .headline4
              //                     ?.copyWith(
              //                       color: Storage.instance.isDarkMode
              //                           ? Colors.white70
              //                           : Constance.primaryColor,
              //                       // fontWeight: FontWeight.bold,
              //                     ),
              //               ),
              //             ))
              //         .toList(),
              //     // After selecting the desired option,it will
              //     // change button value to selected value
              //     onChanged: (String? newValue) {
              //       setState(() {
              //         selectedLocality = newValue!;
              //       });
              //     },
              //   );
              // }),
              TextFormField(
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: localityEditor,
                maxLines: 1,
                keyboardType: TextInputType.name,
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
                height: 2.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: title,
                maxLines: 1,
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
                  (images.length ?? 0),
                  (pos) => (pos == images.length)
                      ? GestureDetector(
                          onTap: () {},
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
                                child: Image.network(
                                  images[pos].file_name ?? "",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  print(images.removeAt(pos));
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
                height: 1.h,
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
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onTap: () {
                    // showDialogBox();
                    if (title.text.isNotEmpty &&
                        desc.text.isNotEmpty &&
                        price.text.isNotEmpty &&
                        localityEditor.text.isNotEmpty) {
                      updateClassified(
                          selectedCategory,
                          localityEditor.text,
                          title.text,
                          desc.text,
                          price.text,
                          attachements,
                          Provider.of<DataProvider>(
                                  Navigation.instance.navigatorKey
                                          .currentContext ??
                                      context,
                                  listen: false)
                              .selectedClassified
                              ?.id);
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
      bottomNavigationBar: CustomNavigationBar(current,"classified"),
    );
  }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     // leading: IconButton(
  //     //   onPressed: () {
  //     //     Navigation.instance.navigate('/bergerMenuMem');
  //     //   },
  //     //   icon: Icon(Icons.menu),
  //     // ),
  //     title: GestureDetector(
  //       onTap: () {
  //         Provider.of<DataProvider>(
  //                 Navigation.instance.navigatorKey.currentContext ?? context,
  //                 listen: false)
  //             .setCurrent(0);
  //         Navigation.instance.navigate('/main');
  //       },
  //       child: Image.asset(
  //         Constance.logoIcon,
  //         fit: BoxFit.fill,
  //         scale: 2,
  //       ),
  //     ),
  //     centerTitle: true,
  //     backgroundColor: Constance.primaryColor,
  //     actions: [
  //       IconButton(
  //         onPressed: () {
  //           Navigation.instance.navigate('/notification');
  //         },
  //         icon: Consumer<DataProvider>(builder: (context, data, _) {
  //           return Badge(
  //             badgeColor: Constance.secondaryColor,
  //             badgeContent: Text(
  //               '${data.notifications.length}',
  //               style: Theme.of(context).textTheme.headline5?.copyWith(
  //                 color: Constance.thirdColor,
  //               ),
  //             ),
  //             child: const Icon(Icons.notifications),
  //           );
  //         }),
  //       ),
  //       IconButton(
  //         onPressed: () {},
  //         icon: Icon(Icons.search),
  //       ),
  //     ],
  //   );
  // }

  void showPhotoBottomSheet(Function(int) getImage) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
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
                        InkWell(
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
                            )),
                        const SizedBox(
                          width: 42,
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
                  ],
                ));
          });
    }
  }

  Future<void> getProfileImage(int index) async {
    if (index == 0) {
      // final pickedFile = await _picker.pickImage(
      //   source: ImageSource.camera,
      //   imageQuality: 70,
      // );
      // if (pickedFile != null) {
      //   setState(() {
      //     var profileImage = File(pickedFile.path);
      //     attachements.add(profileImage);
      //   });
      // }
      final pickedFile = await ImagesPicker.openCamera(
        pickType: PickType.image,
        quality: 0.7,
      );

      if (pickedFile != null) {
        for (var i in pickedFile) {
          setState(() {
            attachements.add(
              File(i.path),
            );
          });
        }
      }
    } else {
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

  void setClassified() async {
    setState(() {
      title.text = Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .selectedClassified
              ?.title ??
          "";
      desc.text = Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .selectedClassified
              ?.description ??
          "";
      price.text = (Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .selectedClassified
                  ?.price ??
              0)
          .toString();
      images.addAll(Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .selectedClassified
              ?.attach_files ??
          []);
    });
  }

  void fetchClassified() async {
    // showLoaderDialog(context);
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getClassifiedCategory();
    if (response.success ?? false) {
      Navigation.instance.goBack();
      print(response.categories);
      setState(() {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setClassifiedCategory(response.categories ?? []);
        selectedCategory = (Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .selectedClassified
                    ?.categoryName
                    ?.id ??
                0)
            .toString();
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setLocality(response.localities ?? []);
        selectedLocality = (Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .selectedClassified
                    ?.locality
                    ?.id ??
                0)
            .toString();
      });

      setClassified();
    } else {
      Navigation.instance.goBack();
      showError("Something went wrong");
      // setClassified();
    }
  }

  fetchDetails() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getClassifiedDetails(widget.id);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassifiedDetails(response.classifieds!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
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

  void updateClassified(classified_category_id, locality_id, title, description,
      price, List<File> files, id) async {
    Navigation.instance.navigate('/loadingDialog');
    final reponse = await ApiProvider.instance.updateClassified(
        classified_category_id,
        locality_id,
        title,
        description,
        price,
        files,
        getComaSeparated(images),
        id);
    if (reponse.success ?? false) {
      fetchDetails();
      Fluttertoast.showToast(msg: "Posted successfully");
      Navigation.instance.goBack();
      fetchClassified();

      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError("Something went wrong");
    }
  }

  String getComaSeparated(List<dynamic> list) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (i == 0) {
        temp = '${list[i].id.toString()},';
      } else {
        temp += '${list[i].id.toString()},';
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
  }
  void request() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.photos,
    ].request();
    statuses.forEach((permission, status) {
      if (status.isGranted) {
        // Permission granted
        setState(() {
          showPhotoBottomSheet(getProfileImage);
        });
        debugPrint('${permission.toString()} granted.');
      } else if (status.isDenied) {
        // Permission denied
        showErrorStorage('${permission.toString()} denied.');
        debugPrint('${permission.toString()} denied.');
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied
        showErrorStorage('${permission.toString()} permanently denied.');
        debugPrint('${permission.toString()} permanently denied.');
      }
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
