// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_config/flutter_config.dart';
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:gplusapp/Helper/Storage.dart';
// import 'package:intl/intl.dart';
// import 'package:open_file_safe/open_file_safe.dart';
// import 'package:package_info_plus/package_info_plus.dart';
//
// // import 'package:open_file/open_file.dart';
// import 'package:provider/provider.dart';
//
// // import 'package:uni_links/uni_links.dart';
// // import 'dart:io';
// import 'Components/alert.dart';
// import 'Helper/AppTheme.dart';
// import 'Helper/Constance.dart';
// import 'Helper/DataProvider.dart';
// import 'Helper/FirebaseHelper.dart';
// import 'Helper/method_mine.dart';
// import 'Helper/store_config.dart';
// import 'Model/notification_received.dart';
// import 'Navigation/Navigate.dart';
// import 'Navigation/routes.dart';
// import 'package:sizer/sizer.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'Networking/api_provider.dart';
// import 'UI/main/home_screen_page.dart';
// import 'firebase_options.dart';
//
// final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp().then((value) async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(NotificationHelper.channel);
//
//     await flutterLocalNotificationsPlugin.initialize(
//       NotificationHelper.initializationSettings,
//
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) =>
//           NotificationHelper.onDidReceiveNotificationResponse(
//               notificationResponse),
//
//     );
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     debugPrint("test background message is coming ${message.data}");
//     debugPrint(
//         "1st case ${notification?.title ?? " 1 "} ${notification?.body ?? " 2 "} ${message.category ?? " 3 "} ${message.data ?? " 4 "}");
//
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       // notification.title,
//       message.data['title'],
//       // "G Plus",
//       // notification.body,
//       message.data['body'],
//       NotificationHelper.notificationDetails,
//       payload: '${message.data}',
//     );
//   });
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     // name: "GPlusNewApp",
//     options: DefaultFirebaseOptions.currentPlatform,
//   ).then((value) {
//     setUpFirebase();
//   });
//
//   Storage.instance.initializeStorage();
//   await FlutterConfig.loadEnvVariables();
//   StoreConfig(
//     store: Store.appleStore,
//     apiKey: FlutterConfig.get('revenueCatIOSKey') ?? "",
//   );
//
//   runApp(const MyApp());
// }
//
// void checkVersion(String version, String buildNumber) async {
//   if (Platform.isIOS) {
//     final response =
//     await ApiProvider.instance.versionCheck(version, buildNumber);
//     if (response.success ?? false) {
//       Provider.of<DataProvider>(
//           Navigation.instance.navigatorKey.currentContext!,
//           listen: false)
//           .setHide(true);
//     } else {
//       Provider.of<DataProvider>(
//           Navigation.instance.navigatorKey.currentContext!,
//           listen: false)
//           .setHide(false);
//     }
//   }
// }
//
// void notificationHandler(RemoteMessage? message, String msg) async {
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(NotificationHelper.channel);
//   RemoteNotification? notification = message?.notification;
//   // AndroidNotification? android = message?.notification?.android;
//   if (message?.data != null) {
//     debugPrint(
//         "2nd case ${msg} ${notification?.title ?? " 1 "} ${notification?.body ?? " 2 "} ${message?.category ?? " 3 "} ${message?.data ?? " 4 "}");
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       // notification.title,
//       message?.data['title'],
//       // "G Plus",
//       // notification.body,
//       message?.data['body'],
//       NotificationHelper.notificationDetails,
//       payload: '${message?.data}',
//     );
//   }
// }
//
// void setUpFirebase() async {
//   NotificationSettings settings =
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//   debugPrint('${settings.authorizationStatus}');
//
//   await flutterLocalNotificationsPlugin.initialize(
//     NotificationHelper.initializationSettings,
//     onDidReceiveNotificationResponse:
//         (NotificationResponse notificationResponse) =>
//         NotificationHelper.onDidReceiveNotificationResponse(
//             notificationResponse),
//   );
//   await FirebaseMessaging.instance.getToken().then((value) {
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
//       debugPrint(
//         'new notification ${message?.data ?? " "} ${message?.category} ${message?.from}',
//       );
//       notificationHandler(message, "Opened Firebase Notification");
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('notification on front');
//       notificationHandler(message, "Opened Visitors Front");
//     });
//
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       debugPrint(
//           'killed notification ${message?.data ?? " "} ${message?.category} ${message?.from}');
//       if (message != null) {
//         notificationHandler(message, "From Killed App");
//       }
//     },onError: (error){
//       debugPrint(" killed error ${error}");
//     });
//   });
//   //
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => DataProvider(),
//       child: Sizer(builder: (context, orientation, deviceType) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Guwahati Plus',
//           theme: AppTheme.getTheme(),
//           navigatorKey: Navigation.instance.navigatorKey,
//           onGenerateRoute: generateRoute,
//           navigatorObservers: [
//             FirebaseAnalyticsObserver(analytics: analytics), // <-- here
//           ],
//         );
//       }),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initUniLinks();
//     initValues();
//     initDeepLink();
//   }
//
//   void initValues() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     debugPrint(
//         "version:${packageInfo.version} buildNumber:${packageInfo.buildNumber}");
//     //notification
//     checkVersion(packageInfo.version, packageInfo.buildNumber);
//   }
//
//   void initDeepLink() async {
//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       debugPrint("URL link ${dynamicLinkData.link.path.split("/")}");
//       if (Storage.instance.isLoggedIn) {
//         bool isOpinion = dynamicLinkData.link.path.split("/").length == 4;
//         sendToRoute(
//           dynamicLinkData.link.path.split("/")[1].trim(),
//           isOpinion
//               ? dynamicLinkData.link.path.split("/")[3].trim()
//               : dynamicLinkData.link.path.split("/")[2].trim(),
//           (isOpinion
//               ? dynamicLinkData.link.path.split("/")[2].trim()
//               : dynamicLinkData.link.path.split("/")[1].trim()),
//         );
//       }
//     }).onError((error) {
//       // Handle errors
//       debugPrint("URL link ${error}");
//     });
//   }
// }
//
// void showError(String msg) {
//   AlertX.instance.showAlert(
//       title: "Error",
//       msg: msg,
//       positiveButtonText: "Done",
//       positiveButtonPressed: () {
//         Navigation.instance.goBack();
//       });
// }
//
// void sendToRoute(String route, data, String? category) async {
//   debugPrint("link 1 our route ${route} ${category} ${data}");
//   switch (route) {
//     case "opinion":
//     // Navigation.instance.navigate('/main');
//     //   debugPrint("this route2 ${category},${data}");
//       Navigation.instance
//           .navigate('/opinionDetails', args: '${data},${category}');
//       break;
//     default:
//     // Navigation.instance.navigate('/main');
//       Navigation.instance
//           .navigate('/story', args: '${category},${data},home_page');
//       break;
//   }
// }
