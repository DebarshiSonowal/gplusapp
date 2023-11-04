import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

// import 'package:new_version/new_version.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:package_info_plus/package_info_plus.dart';

// import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// import 'package:uni_links/uni_links.dart';
// import 'dart:io';
import 'Components/alert.dart';
import 'Helper/AppTheme.dart';
import 'Helper/DataProvider.dart';
import 'Helper/FirebaseHelper.dart';
import 'Helper/store_config.dart';
import 'Model/notification_received.dart';
import 'Navigation/Navigate.dart';
import 'Navigation/routes.dart';
import 'Networking/api_provider.dart';
import 'Networking/connection_checker.dart';
import 'firebase_options.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isFlutterLocalNotificationsInitialized = false;
final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  // showFlutterNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Storage.instance.initializeStorage();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // initDeepLink();
  // _networkConnectivity.initialise();
  // _networkConnectivity.myStream.listen((event) {
  //   debugPrint("Connect ${event} ${event['status']}");
  //   if (event['status'].toString() == "false") {
  //     debugPrint("MIN");
  //     Future.delayed(const Duration(seconds: 3), () {
  //       Navigation.instance.navigate("/no_internet");
  //     });
  //   }
  // });

  await setupFlutterNotifications();


  StoreConfig(
    store: Store.appleStore,
    apiKey: FlutterConfig.get('revenueCatIOSKey') ?? "",
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {

    runApp(const MyApp());
  });
}

void initDeepLink() async {
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
    debugPrint("URL link ${dynamicLinkData.link.path.split("/")}");
    if (Storage.instance.isLoggedIn) {
      bool isOpinion = dynamicLinkData.link.path.split("/").length == 4;
      sendToRoute(
        dynamicLinkData.link.path.split("/")[1].trim(),
        isOpinion
            ? dynamicLinkData.link.path.split("/")[3].trim()
            : dynamicLinkData.link.path.split("/")[2].trim(),
        (isOpinion
            ? dynamicLinkData.link.path.split("/")[2].trim()
            : dynamicLinkData.link.path.split("/")[1].trim()),
        Navigation.instance.navigatorKey.currentContext!,
      );
    }
  }).onError((error) {
    debugPrint("URL link $error");
  });
}

void sendToRoute(String route, data, String? category,BuildContext context) async {
  switch (route) {
    case "opinion":
      // Navigation.instance.navigate('/main');
      //   debugPrint("this route2 ${category},${data}");
      if ((Provider.of<DataProvider>(context, listen: false)
              .profile
              ?.is_plan_active ??
          false)) {
        Navigation.instance
            .navigate('/opinionDetails', args: '$data,$category');
      }
      break;
    default:
      // Navigation.instance.navigate('/main');
      if ((Provider.of<DataProvider>(context, listen: false)
              .profile
              ?.is_plan_active ??
          false)) {
        Navigation.instance
            .navigate('/story', args: '$category,$data,home_page');
      }
      break;
  }
}

void checkVersion(String version, String buildNumber) async {
  if (Platform.isIOS) {
    final response =
        await ApiProvider.instance.versionCheck(version, buildNumber);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setHide(true);
    } else {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setHide(false);
    }
  }
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(
    NotificationHelper.initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) =>
            NotificationHelper.onDidReceiveNotificationResponse(
                notificationResponse),
  );

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void notificationHandler(RemoteMessage? message, String msg) async {
  var details =
      await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  debugPrint(
      "onDidReceiveNotificationResponse ${details?.notificationResponse?.payload}");
  if (details?.didNotificationLaunchApp ?? false) {
    if (details?.notificationResponse?.payload != 'downloading') {
      OpenFile.open(details?.notificationResponse?.payload);
    }
  }
  debugPrint("Notification Payload ${message?.data}");
  // var jsData = message?.data.toString() ?? "";
  // jsData = jsData.replaceAll('{', '{"');
  // jsData = jsData.replaceAll(': ', '": "');
  // jsData = jsData.replaceAll(', ', '", "');
  // jsData = jsData.replaceAll('}', '"}');
  // debugPrint(jsData);
  // NotificationReceived notification =
  //     NotificationReceived.fromJson(jsonDecode(jsData));
  var propertyPattern = RegExp(r'(\w+): ([^,]+)');

  var json = <String, String?>{};

  propertyPattern
      .allMatches("${details?.notificationResponse?.payload}")
      .forEach((match) {
    var propertyName = match.group(1);
    var propertyValue = match.group(2);

    json[propertyName!] = propertyValue!.trim();
  });
  NotificationReceived notification =
      // NotificationReceived.fromJson(jsonDecode(jsData1));
      NotificationReceived.fromJson(json);
  // Navigation.instance.navigate('');

  NotificationHelper.setRead(
      notification.notification_id,
      notification.seo_name,
      notification.seo_name_category,
      notification.type,
      notification.post_id,
      notification.vendor_id,
      notification.category_id);
}

void showFlutterNotification(RemoteMessage message) {
  debugPrint(
      "Showing notification ${message.data} ${message.notification?.title} ${message.notification?.body}");
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      // notification.title,
      message.data['title'],
      // notification.body,
      message.data['body'],
      NotificationHelper.notificationDetails,
      payload: "${message.data}");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  String? initialMessage;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Guwahati Plus',
          theme: AppTheme.getTheme(),
          navigatorKey: Navigation.instance.navigatorKey,
          onGenerateRoute: generateRoute,
          navigatorObservers: [
            NavigationHistoryObserver(),
            FirebaseAnalyticsObserver(analytics: analytics), // <-- here
          ],
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    initValues();
    // initDeepLink();
    // checkForUpdate();

    try {
      FirebaseMessaging.onMessage.listen(showFlutterNotification);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) =>
              notificationHandler(message, "Opened Firebase Notification"));
    } catch (e) {
      print(e);
    }
  }

  void initValues() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    debugPrint(
        "version:${packageInfo.version} buildNumber:${packageInfo.buildNumber}");
    //notification
    checkVersion(packageInfo.version, packageInfo.buildNumber);
  }

//   void checkForUpdate() async {
//     final newVersion = NewVersion(
//         // iOSId: 'com.google.Vespa',
//         // androidId: 'com.appbazooka.gplus',
//         );
//     final status = await newVersion.getVersionStatus();
//     if (status != null) {
//       debugPrint(status.releaseNotes);
//       debugPrint(status.appStoreLink);
//       debugPrint(status.localVersion);
//       debugPrint(status.storeVersion);
//       debugPrint(status.canUpdate.toString());
//       newVersion.showUpdateDialog(
//         context: context,
//         versionStatus: status,
//         dialogTitle: 'Custom Title',
//         dialogText: 'Custom Text',
//       );
//     }
//   }
// }

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }
}
