// import 'dart:io';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:gplusapp/Components/custom_button.dart';
// import 'package:gplusapp/Networking/api_provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:images_picker/images_picker.dart';
// import 'package:open_settings/open_settings.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../Components/NavigationBar.dart';
// import '../../Components/alert.dart';
// import '../../Helper/Constance.dart';
// import '../../Helper/DataProvider.dart';
// import '../../Helper/Storage.dart';
// import '../../Model/profile.dart';
// import '../../Navigation/Navigate.dart';
//
// class SubmitStoryPage extends StatefulWidget {
//   const SubmitStoryPage({Key? key}) : super(key: key);
//
//   @override
//   State<SubmitStoryPage> createState() => _SubmitStoryPageState();
// }
//
// class _SubmitStoryPageState extends State<SubmitStoryPage>
//     with WidgetsBindingObserver {
//   var title = TextEditingController();
//   bool _isImagePickerActive = false;
//
//   var desc = TextEditingController();
//   AndroidDeviceInfo? androidInfo;
//   var current = 3;
//   ImagePicker _picker = ImagePicker();
//   List<File> attachements = [];
//   List<XFile>? _images;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     // getIsNotAndroid13() ? getLostData() : () {};
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     title.dispose();
//     desc.dispose();
//     super.dispose();
//   }
//
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   Future<void> getLostData() async {
//     androidInfo = await DeviceInfoPlugin().androidInfo;
//     // Navigation.instance.navigate("/loadingDialog");
//     if (await Permission.storage.request().isGranted) {
//       // Navigation.instance.goBack();
//       final LostDataResponse response = await _picker.retrieveLostData();
//       if (response.isEmpty) {
//         debugPrint("didChangeAppLifecycleState isEmpty");
//         return;
//       }
//       if (response.files != null) {
//         debugPrint("didChangeAppLifecycleState isNotEmpty");
//         for (final XFile file in response.files!) {
//           setState(() {
//             attachements.add(
//               File(file.path),
//             );
//           });
//         }
//       } else {
//         debugPrint("${response.exception!}");
//       }
//     } else {
//       // Navigation.instance.goBack();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: Constance.buildAppBar2("citizen_journalist"),
//       // drawer: BergerMenuMemPage(),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
//         padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 5.w),
//                 child: Text(
//                   'Submit A Story',
//                   style: Theme.of(context).textTheme.headline2?.copyWith(
//                       color: Storage.instance.isDarkMode
//                           ? Colors.white
//                           : Constance.primaryColor,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),
//               TextFormField(
//                 style: Theme.of(context).textTheme.headline5?.copyWith(
//                   color: Colors.black,
//                   // fontSize: 1.6.h,
//                 ),
//                 controller: title,
//                 // maxLines: 2,
//                 keyboardType: TextInputType.name,
//                 decoration: InputDecoration(
//                   filled: true,
//                   floatingLabelBehavior: FloatingLabelBehavior.never,
//                   fillColor: Colors.white,
//                   labelText: 'Enter the title',
//                   labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
//                     color: Colors.black,
//                     // fontSize: 1.5.h,
//                   ),
//                   border: const OutlineInputBorder(),
//                   enabledBorder: const OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),
//               TextFormField(
//                 style: Theme.of(context).textTheme.headline5?.copyWith(
//                   color: Colors.black,
//                   // fontSize: 1.6.h,
//                 ),
//                 controller: desc,
//                 keyboardType: TextInputType.multiline,
//                 maxLines: null,
//                 minLines: 10,
//                 decoration: InputDecoration(
//                   filled: true,
//                   floatingLabelBehavior: FloatingLabelBehavior.never,
//                   fillColor: Colors.white,
//                   labelText: 'Enter the details',
//                   labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
//                     color: Colors.black,
//                     // fontSize: 1.5.h,
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Storage.instance.isDarkMode
//                             ? Colors.white
//                             : Colors.black),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Storage.instance.isDarkMode
//                             ? Colors.white
//                             : Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.attach_file,
//                     color: Storage.instance.isDarkMode
//                         ? Colors.white
//                         : Colors.black,
//                   ),
//                   Text(
//                     'Add attachments',
//                     style: Theme.of(context).textTheme.headline5?.copyWith(
//                       color: Storage.instance.isDarkMode
//                           ? Colors.white
//                           : Colors.black,
//                       // fontSize: 1.6.h,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),
//               FutureBuilder(
//                   future: getLostData(),
//                   builder:
//                       (BuildContext context, AsyncSnapshot<void> snapshot) {
//                     return Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: List.generate(
//                         (attachements.length ?? 0) + 1,
//                             (pos) => (pos == attachements.length)
//                             ? GestureDetector(
//                           onTap: () {
//                             // setState(() {
//                             //   showPhotoBottomSheet(getProfileImage);
//                             // });
//                             // request(getProfileImage);
//                             _checkPermissionAndPickImage();
//                           },
//                           child: Container(
//                             height: 8.h,
//                             width: 20.w,
//                             color: Colors.grey.shade200,
//                             child: const Center(
//                               child: Icon(
//                                 Icons.add,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         )
//                             : Stack(
//                           alignment: Alignment.topRight,
//                           children: [
//                             Container(
//                               height: 8.h,
//                               width: 20.w,
//                               color: Colors.grey.shade200,
//                               child: Center(
//                                 child: Image.file(
//                                   attachements[pos],
//                                   fit: BoxFit.fill,
//                                   errorBuilder: (err, cont, st) {
//                                     return Image.asset(
//                                         Constance.logoIcon);
//                                   },
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   attachements.removeAt(pos);
//                                 });
//                               },
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(10.0),
//                                 ),
//                                 color: Colors.white,
//                                 child: const Icon(
//                                   Icons.remove,
//                                   color: Constance.thirdColor,
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//               SizedBox(
//                 height: 2.h,
//               ),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'By clicking "Submit" you agreed to our ',
//                       style: Theme.of(context).textTheme.headline6?.copyWith(
//                         color: Storage.instance.isDarkMode
//                             ? Colors.white
//                             : Colors.black54,
//                         // fontSize: 1.6.h,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Terms & Conditions.',
//                       style: Theme.of(context).textTheme.headline6?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Storage.instance.isDarkMode
//                             ? Colors.white
//                             : Colors.black,
//                         // fontSize: 1.6.h,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           Navigation.instance.navigate('/termsConditions');
//                         },
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),
//               SizedBox(
//                 height: 5.h,
//                 width: double.infinity,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       height: 5.h,
//                       width: 40.w,
//                       child: CustomButton(
//                         onTap: () {
//                           // showDialogBox();
//                           if (title.text.isNotEmpty && desc.text.isNotEmpty) {
//                             logTheCjSubmitClick(Provider.of<DataProvider>(
//                                 Navigation.instance.navigatorKey
//                                     .currentContext ??
//                                     context,
//                                 listen: false)
//                                 .profile!);
//                             postStory(1);
//                           } else {
//                             showError(
//                                 "Title and Description is mandatory to post");
//                           }
//                         },
//                         txt: 'Submit',
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5.h,
//                       width: 40.w,
//                       child: CustomButton(
//                         color: Storage.instance.isDarkMode
//                             ? Colors.white
//                             : Colors.black,
//                         fcolor: Storage.instance.isDarkMode
//                             ? Colors.black
//                             : Colors.white,
//                         onTap: () {
//                           // showDialogBox();
//                           if (title.text.isNotEmpty && desc.text.isNotEmpty) {
//                             logTheCjDraftSubmitClick(
//                               Provider.of<DataProvider>(
//                                   Navigation.instance.navigatorKey
//                                       .currentContext ??
//                                       context,
//                                   listen: false)
//                                   .profile!,
//                               title.text,
//                               desc.text,
//                             );
//                             postStory(0);
//                           } else {
//                             showError(
//                                 "Title and Description is mandatory to post");
//                           }
//                         },
//                         txt: 'Save as draft',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: CustomNavigationBar(current, "citizen_journalist"),
//     );
//   }
//
//   // void showPhotoBottomSheet(Function(int) getImage) {
//   //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//   //     statusBarColor: Colors.transparent,
//   //   ));
//   //   BuildContext? context = Navigation.instance.navigatorKey.currentContext;
//   //   if (context != null) {
//   //     showDialog(
//   //         barrierDismissible: true,
//   //         context: context,
//   //         builder: (BuildContext context) {
//   //           return AlertDialog(
//   //               title: const Center(
//   //                   child: Text(
//   //                 "Add Photo",
//   //                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//   //               )),
//   //               contentPadding: const EdgeInsets.only(top: 24, bottom: 30),
//   //               content: Column(
//   //                 mainAxisSize: MainAxisSize.min,
//   //                 children: [
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: [
//   //                       getIsNotAndroid13()
//   //                           ? InkWell(
//   //                               onTap: () {
//   //                                 Navigation.instance.goBack();
//   //                                 getImage(0);
//   //                               },
//   //                               child: Column(
//   //                                 children: [
//   //                                   Container(
//   //                                     padding: const EdgeInsets.all(12),
//   //                                     margin: const EdgeInsets.only(bottom: 4),
//   //                                     decoration: BoxDecoration(
//   //                                         borderRadius:
//   //                                             BorderRadius.circular(30),
//   //                                         color: Colors.pink.shade300),
//   //                                     child: const Icon(
//   //                                       Icons.camera_alt_rounded,
//   //                                       color: Colors.white,
//   //                                     ),
//   //                                   ),
//   //                                   const Text(
//   //                                     "Camera",
//   //                                     style: TextStyle(
//   //                                       fontSize: 14,
//   //                                     ),
//   //                                   ),
//   //                                 ],
//   //                               ),
//   //                             )
//   //                           : Container(),
//   //                       SizedBox(
//   //                         width: getIsNotAndroid13() ? 42 : 0,
//   //                       ),
//   //                       InkWell(
//   //                           onTap: () {
//   //                             Navigation.instance.goBack();
//   //                             getImage(1);
//   //                           },
//   //                           child: Column(
//   //                             children: [
//   //                               Container(
//   //                                 padding: EdgeInsets.all(12),
//   //                                 margin: EdgeInsets.only(bottom: 4),
//   //                                 decoration: BoxDecoration(
//   //                                     borderRadius: BorderRadius.circular(30),
//   //                                     color: Colors.purple.shade300),
//   //                                 child: const Icon(
//   //                                   Icons.image,
//   //                                   color: Colors.white,
//   //                                 ),
//   //                               ),
//   //                               const Text(
//   //                                 "Gallery",
//   //                                 style: TextStyle(
//   //                                   fontSize: 14,
//   //                                 ),
//   //                               ),
//   //                             ],
//   //                           )),
//   //                     ],
//   //                   ),
//   //                   Platform.isAndroid
//   //                       ? Container(
//   //                           margin: EdgeInsets.only(top: 1.5.h),
//   //                           width: 50.w,
//   //                           child: Constance.androidWarning,
//   //                         )
//   //                       : Container(),
//   //                 ],
//   //               ));
//   //         });
//   //   }
//   // }
//
//   void showPhotoBottomSheet(Function(int) getImage) {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//     ));
//     BuildContext? context = Navigation.instance.navigatorKey.currentContext;
//     if (context != null) {
//       showDialog(
//           barrierDismissible: true,
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//                 title: const Center(
//                     child: Text(
//                       "Add Photo",
//                       style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//                     )),
//                 contentPadding: const EdgeInsets.only(top: 24, bottom: 30),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         getIsNotAndroid13()
//                             ? InkWell(
//                           onTap: () {
//                             Navigation.instance.goBack();
//                             getImage(0);
//                           },
//                           child: Column(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(12),
//                                 margin: const EdgeInsets.only(bottom: 4),
//                                 decoration: BoxDecoration(
//                                     borderRadius:
//                                     BorderRadius.circular(30),
//                                     color: Colors.pink.shade300),
//                                 child: const Icon(
//                                   Icons.camera_alt_rounded,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const Text(
//                                 "Camera",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                             : Container(),
//                         SizedBox(
//                           width: getIsNotAndroid13() ? 42 : 0,
//                         ),
//                         InkWell(
//                             onTap: () {
//                               Navigation.instance.goBack();
//                               getImage(1);
//                             },
//                             child: Column(
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(12),
//                                   margin: EdgeInsets.only(bottom: 4),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30),
//                                       color: Colors.purple.shade300),
//                                   child: const Icon(
//                                     Icons.image,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const Text(
//                                   "Gallery",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             )),
//                       ],
//                     ),
//                     Platform.isAndroid? Container(
//                       margin: EdgeInsets.only(top: 1.5.h),
//                       width: 50.w,
//                       child: Constance.androidWarning,
//                     ):Container(),
//                   ],
//                 ));
//           });
//     }
//   }
//
//
//
//   // Future<void> getProfileImage(int index) async {
//   //   if (index == 0) {
//   //     if (await Permission.camera.request().isGranted) {
//   //       if (getIsNotAndroid13()) {
//   //         _picker = ImagePicker();
//   //         final pickedFile = await _picker
//   //             .pickImage(
//   //           source: ImageSource.camera,
//   //           imageQuality: 70,
//   //         )
//   //             .catchError((er) {
//   //           debugPrint("error $er}");
//   //         });
//   //         setState(() {
//   //           attachements.add(
//   //             File(pickedFile!.path),
//   //           );
//   //         });
//   //       } else {
//   //         List<Media>? res = await ImagesPicker.openCamera(
//   //           pickType: PickType.image,
//   //         );
//   //         if (res != null) {
//   //           setState(() {
//   //             attachements.add(
//   //               File(res[0].path),
//   //             );
//   //           });
//   //         }
//   //       }
//   //     } else {
//   //       showErrorStorage('Permission Denied1');
//   //     }
//   //   } else {
//   //     debugPrint(
//   //         "${getIsNotAndroid13()}\nStorage ${await Permission.storage.request().isGranted}\n photos ${await Permission.photos.request().isGranted}");
//   //     if (!getIsNotAndroid13()
//   //         ? (await Permission.storage.request().isGranted)
//   //         : (await Permission.photos.request().isGranted)) {
//   //       if (!getIsNotAndroid13()) {
//   //         List<Media>? res = await ImagesPicker.pick(
//   //           count: 3,
//   //           pickType: PickType.image,
//   //         );
//   //         if (res != null) {
//   //           setState(() {
//   //             for (var i in res) {
//   //               attachements.add(
//   //                 File(i.path),
//   //               );
//   //             }
//   //           });
//   //         }
//   //       } else {
//   //         _picker = ImagePicker();
//   //         final pickedFile = await _picker.pickMultiImage(
//   //           imageQuality: 70,
//   //         );
//   //         if (pickedFile != null) {
//   //           setState(() {
//   //             for (var i in pickedFile) {
//   //               attachements.add(
//   //                 File(i.path),
//   //               );
//   //             }
//   //           });
//   //         }
//   //       }
//   //     } else {
//   //       showErrorStorage('Permission Denied');
//   //     }
//   //   }
//   // }
//   Future<void> getProfileImage(int index) async {
//     if (index == 0) {
//       if (await Permission.camera.request().isGranted) {
//         // final pickedFile = await _picker
//         //     .pickImage(
//         //   source: ImageSource.camera,
//         //   imageQuality: 70,
//         // )
//         //     .catchError((er) {
//         //   debugPrint("error $er}");
//         // });
//         List<Media>? res = await ImagesPicker.openCamera(
//           pickType: PickType.image,
//         );
//         if (res != null) {
//           setState(() {
//             attachements.add(
//               File(res[0].path),
//             );
//           });
//           // }
//         }
//       } else {
//         showErrorStorage('Permission Denied');
//       }
//     } else {
//       if (getIsNotAndroid13()
//           ? (await Permission.storage.request().isGranted)
//           : (await Permission.photos.request().isGranted)) {
//         if (getIsNotAndroid13()) {
//           List<Media>? res = await ImagesPicker.pick(
//             count: 3,
//             pickType: PickType.image,
//           );
//           if (res != null) {
//             setState(() {
//               for (var i in res) {
//                 attachements.add(
//                   File(i.path),
//                 );
//               }
//             });
//           }
//         } else {
//           _picker = ImagePicker();
//           final pickedFile = await _picker.pickMultiImage(
//             imageQuality: 70,
//           );
//           if (pickedFile != null) {
//             setState(() {
//               for (var i in pickedFile) {
//                 attachements.add(
//                   File(i.path),
//                 );
//               }
//             });
//           }
//         }
//       } else {
//         showErrorStorage('Permission Denied');
//       }
//     }
//   }
//
//   getIsNotAndroid13() {
//     if (Platform.isAndroid) {
//       return ((androidInfo?.version.sdkInt ?? 0) < 32);
//     } else {
//       return true;
//     }
//   }
//
//   void logTheCjSubmitClick(Profile profile) async {
//     // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//     String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
//     // String id = await FirebaseInstallations.instance.getId();
//     await FirebaseAnalytics.instance.logEvent(
//       name: "cj_submit_a_story_final",
//       parameters: {
//         "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
//         "client_id_event": id,
//         "user_id_event": profile.id,
//         // "post": post,
//         // "cta_click": cta_click,
//         "screen_name": "citizen_journalist",
//         "user_login_status":
//         Storage.instance.isLoggedIn ? "logged_in" : "guest",
//         "client_id": id,
//         "user_id_tvc": profile.id,
//       },
//     );
//   }
//
//   // void request() async {
//   //   Map<Permission, PermissionStatus> statuses = await [
//   //     Permission.storage,
//   //     Permission.camera,
//   //     Permission.photos,
//   //   ].request();
//   //   statuses.forEach((permission, status) {
//   //     if (status.isGranted) {
//   //       // Permission granted
//   //
//   //       debugPrint('${permission.toString()} granted.');
//   //     } else if (status.isDenied) {
//   //       // Permission denied
//   //       // showErrorStorage('${permission.toString()} denied.');
//   //       debugPrint('${permission.toString()} denied.');
//   //     } else if (status.isPermanentlyDenied) {
//   //       // Permission permanently denied
//   //
//   //       debugPrint('${permission.toString()} permanently denied.');
//   //     }
//   //   });
//   //   setState(() {
//   //     showPhotoBottomSheet(getProfileImage);
//   //   });
//   // }
//
//   // void request(Function(int) getImage) async {
//   //   Map<Permission, PermissionStatus> statuses = await [
//   //     Permission.storage,
//   //     Permission.camera,
//   //     Permission.photos,
//   //   ].request();
//   //
//   //   // Check if all permissions are granted
//   //   bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);
//   //
//   //   if (allPermissionsGranted) {
//   //     // All permissions are granted, proceed with showing the photo bottom sheet
//   //     setState(() {
//   //       showPhotoBottomSheet(getImage);
//   //     });
//   //   } else {
//   //     // Handle the case where not all permissions are granted
//   //     showError("Permission Denied");
//   //   }
//   // }
//
//   void request() async {
//     Map<Permission, PermissionStatus> statuses = await [
//       getIsNotAndroid13() ? Permission.storage : Permission.photos,
//       Permission.camera,
//     ].request();
//     statuses.forEach((permission, status) {
//       if (status.isGranted) {
//         // Permission granted
//
//         debugPrint('${permission.toString()} granted.');
//       } else if (status.isDenied) {
//         // Permission denied
//         // showErrorStorage('${permission.toString()} denied.');
//         debugPrint('${permission.toString()} denied.');
//       } else if (status.isPermanentlyDenied) {
//         // Permission permanently denied
//
//         debugPrint('${permission.toString()} permanently denied.');
//       }
//     });
//     setState(() {
//       showPhotoBottomSheet(getProfileImage);
//     });
//   }
//
//   void showErrorStorage(String msg) {
//     AlertX.instance.showAlert(
//       title: msg,
//       msg: "Please Go To Settings and Provide the Storage Permission",
//       negativeButtonText: "Close",
//       negativeButtonPressed: () {
//         Navigation.instance.goBack();
//       },
//       positiveButtonText: "Go to Settings",
//       positiveButtonPressed: () async {
//         Navigation.instance.goBack();
//         await OpenSettings.openAppSetting();
//       },
//     );
//   }
//
//   void showDialogBox() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           insetPadding: EdgeInsets.zero,
//           contentPadding: EdgeInsets.zero,
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(10.0),
//             ),
//           ),
//           backgroundColor: Colors.white,
//           title: Text(
//             'Be a journalist!',
//             style: Theme.of(context).textTheme.headline1?.copyWith(
//               color: Constance.secondaryColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: Container(
//             padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
//             // height: 50.h,
//             width: 80.w,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(
//                   FontAwesomeIcons.podcast,
//                   color: Constance.secondaryColor,
//                   size: 15.h,
//                 ),
//                 Text(
//                   'Hello ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.name}',
//                   style: Theme.of(context).textTheme.headline3?.copyWith(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 Text(
//                   'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
//                       ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
//                       ' It has survived not only five centuries, but also the leap into electronic typesetting,'
//                       ' remaining essentially unchanged',
//                   style: Theme.of(context).textTheme.headline5?.copyWith(
//                     color: Colors.black,
//                     // fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 Text(
//                   'is simply dummy text of the printing and typesetting industry',
//                   style: Theme.of(context).textTheme.headline5?.copyWith(
//                     color: Colors.black,
//                     // fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 SizedBox(
//                   width: double.infinity,
//                   child: CustomButton(
//                       txt: 'Go Ahead',
//                       onTap: () {
//                         Navigation.instance.goBack();
//                       }),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void postStory(is_story_submit) async {
//     Navigation.instance.navigate('/loadingDialog');
//     final response = await ApiProvider.instance.postCitizenJournalist(
//         title.text, desc.text, attachements, is_story_submit);
//     if (response.success ?? false) {
//       Fluttertoast.showToast(msg: "Posted successfully");
//       Navigation.instance.goBack();
//       Navigation.instance.goBack();
//     } else {
//       Navigation.instance.goBack();
//       showError(response.message ?? "Something went wrong");
//     }
//   }
//
//   void showError(String msg) {
//     AlertX.instance.showAlert(
//         title: "Error",
//         msg: msg,
//         positiveButtonText: "Done",
//         positiveButtonPressed: () {
//           Navigation.instance.goBack();
//         });
//   }
//
//   void logTheCjDraftSubmitClick(
//       Profile profile, String title, String field_entered) async {
//     // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//     String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
//     // String id = await FirebaseInstallations.instance.getId();
//     await FirebaseAnalytics.instance.logEvent(
//       name: "save_as_draft_final",
//       parameters: {
//         "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
//         "client_id_event": id,
//         "user_id_event": profile.id,
//         // "post": post,
//         "title": title.length > 100 ? title.substring(0, 100) : title,
//         "field_entered": field_entered.length > 100
//             ? field_entered.substring(0, 100)
//             : field_entered,
//         "cta_click": "save_as_draft",
//         "screen_name": "citizen_journalist",
//         "user_login_status":
//         Storage.instance.isLoggedIn ? "logged_in" : "guest",
//         "client_id": id,
//         "user_id_tvc": profile.id,
//       },
//     );
//   }
//
//   Future<void> _checkPermissionAndPickImage() async {
//     // Check if permission is granted
//     if (await Permission.photos.request().isGranted) {
//       // Permission is granted, proceed to pick image
//       _pickImage();
//     } else {
//       // Permission is not granted, request permission
//       var status = await Permission.photos.request();
//       if (status.isDenied) {
//         // Permission is denied, show a message or handle accordingly
//         print('Permission denied by user');
//       } else if (status.isPermanentlyDenied) {
//         // Permission is permanently denied, show a message or open app settings
//         print('Permission permanently denied by user');
//       }
//     }
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _images = [pickedFile];
//         });
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }
// }