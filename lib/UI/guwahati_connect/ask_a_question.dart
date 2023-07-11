import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Networking/api_provider.dart';
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

class AskAQuestionPage extends StatefulWidget {
  const AskAQuestionPage({Key? key}) : super(key: key);

  @override
  State<AskAQuestionPage> createState() => _AskAQuestionPageState();
}

class _AskAQuestionPageState extends State<AskAQuestionPage>
    with WidgetsBindingObserver {
  // var title = TextEditingController();

  final desc = TextEditingController();
  final title = TextEditingController();
  AndroidDeviceInfo? androidInfo;
  var current = 3;

  ImagePicker _picker = ImagePicker();
  List<File> attachements = [];

  @override
  void initState() {
    initializeAndroidInfo();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    title.dispose();
    desc.dispose();
    super.dispose();
    // title.dispose();
  }

  // @override
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("didChangeAppLifecycleState $state");
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      debugPrint("didChangeAppLifecycleState inside $state");
      try {
        // getLostData();
      } catch (e) {
        debugPrint("what error $e");
      }
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("guwahati"),
      // drawer: BergerMenuMemPage(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  'Ask A Question',
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
                keyboardType: TextInputType.text,
                maxLines: null,
                minLines: 2,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Write a topic',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black45,
                        // fontSize: 1.5.h,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: desc,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 15,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Ask a question',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black45,
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
              Builder(builder: (context) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    (attachements.length ?? 0) + 1,
                    (pos) => (pos == attachements.length)
                        ? GestureDetector(
                            onTap: () => request(),
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
                );
              }),
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
                child: CustomButton(
                  onTap: () {
                    // showDialogBox();
                    if (desc.text.isNotEmpty && title.text.isNotEmpty) {
                      logTheAskAQuestionClick(
                        Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile!,
                        desc.text,
                      );
                      postQuestion();
                    } else {}
                  },
                  txt: 'Submit',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current, "guwahati"),
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

  Future<void> getLostData() async {
    androidInfo = await DeviceInfoPlugin().androidInfo;
    // Navigation.instance.navigate("/loadingDialog");
    if (await Permission.storage.request().isGranted) {
      // Navigation.instance.goBack();
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
    } else {
      // Navigation.instance.goBack();
    }
  }

  // Future<void> getProfileImage(int index) async {
  //   if (index == 0) {
  //     if (await Permission.camera.request().isGranted) {
  //       final pickedFile = await _picker
  //           .pickImage(
  //         source: ImageSource.camera,
  //         imageQuality: 70,
  //       )
  //           .catchError((er) {
  //         debugPrint("error $er}");
  //       });
  //       if (pickedFile != null) {
  //         setState(() {
  //           attachements.add(
  //             File(pickedFile.path),
  //           );
  //         });
  //         // }
  //       }
  //     } else {
  //       showErrorStorage('Permission Denied');
  //     }
  //   } else {
  //     if ((await Permission.photos.request().isGranted)) {
  //       final pickedFile = await _picker.pickMultiImage(
  //         imageQuality: 70,
  //       );
  //       if (pickedFile != null) {
  //         setState(() {
  //           for (var i in pickedFile) {
  //             attachements.add(
  //               File(i.path),
  //             );
  //           }
  //         });
  //       }
  //     } else {
  //       showErrorStorage('Permission Denied');
  //     }
  //   }
  // }

  void postQuestion() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance
        .postGuwhahatiConnect(desc.text, attachements, title.text);
    if (response.success ?? false) {
      print("post success ${response.success} ${response.message}");
      Fluttertoast.showToast(msg: "Your post has been submitted for review");
      Navigation.instance.goBack();
      fetchGuwahatiConnect();
      Navigation.instance.goBack();
    } else {
      print("post failed ${response.success} ${response.message}");
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }

  void fetchGuwahatiConnect() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
    } else {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
    }
  }

  void logTheAskAQuestionClick(Profile profile, String field_entered) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "ask_a_question_submit",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "field_entered": field_entered.length > 100
            ? field_entered.substring(0, 100)
            : field_entered,
        // "cta_click": cta_click,
        "screen_name": "ask_a_question",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
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

  void initializeAndroidInfo() async {
    try {
      androidInfo = await DeviceInfoPlugin().androidInfo;
    } catch (e) {
      print(e);
    }
  }
}
