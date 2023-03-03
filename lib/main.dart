import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:package_info_plus/package_info_plus.dart';

// import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

// import 'package:uni_links/uni_links.dart';
// import 'dart:io';
import 'Components/alert.dart';
import 'Helper/AppTheme.dart';
import 'Helper/Constance.dart';
import 'Helper/DataProvider.dart';
import 'Helper/method_mine.dart';
import 'Helper/store_config.dart';
import 'Model/notification_received.dart';
import 'Navigation/Navigate.dart';
import 'Navigation/routes.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Networking/api_provider.dart';
import 'UI/main/home_screen_page.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_notification');
  const DarwinInitializationSettings initializationSettingsIos =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIos,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) =>
            onDidReceiveNotificationResponse(notificationResponse),
    // onDidReceiveBackgroundNotificationResponse: (notificationResponse) =>
    //     notificationTapBackground,
  );
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  debugPrint("test background message is coming ${message.data}");
  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // icon: android.smallIcon,
          icon: "@mipmap/ic_notification",
          // other properties...
        ),
        iOS: DarwinNotificationDetails(
          // badgeNumber: int.parse(channel.id),
          subtitle: channel.name,
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
      payload: '${message.data}',
    );
  }
}

Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  var details =
      await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  debugPrint(
      "onDidReceiveNotificationResponse ${details?.notificationResponse?.payload}");
  if (details?.didNotificationLaunchApp ?? false) {
    if (details?.notificationResponse?.payload != 'downloading') {
      OpenFile.open(details?.notificationResponse?.payload);
    }
  }
  debugPrint(notificationResponse.payload);
  var jsData = notificationResponse.payload ?? "";
  jsData = jsData.replaceAll('{', '{"');
  jsData = jsData.replaceAll(': ', '": "');
  jsData = jsData.replaceAll(', ', '", "');
  jsData = jsData.replaceAll('}', '"}');
  debugPrint(jsData);
  NotificationReceived notification =
      NotificationReceived.fromJson(jsonDecode(jsData));
  // Navigation.instance.navigate('');

  setRead(
      notification.notification_id,
      notification.seo_name,
      notification.seo_name_category,
      notification.type,
      notification.post_id,
      notification.vendor_id,
      notification.category_id);
}

@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  var details =
      await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  debugPrint(
      "notification response 2 ${details?.notificationResponse?.payload}");
  if (details?.didNotificationLaunchApp ?? false) {
    if (details?.notificationResponse?.payload != 'downloading') {
      OpenFile.open(details?.notificationResponse?.payload);
    }
  }
  try {
    debugPrint(
        "notification response1 ${notificationResponse.payload} ${notificationResponse.id} ${notificationResponse.input}");
  } catch (e) {
    debugPrint(e.toString());
  }
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  debugPrint(notificationResponse.payload);
  var jsData = notificationResponse.payload ?? "";
  jsData = jsData.replaceAll('{', '{"');
  jsData = jsData.replaceAll(': ', '": "');
  jsData = jsData.replaceAll(', ', '", "');
  jsData = jsData.replaceAll('}', '"}');
  debugPrint(jsData);
  NotificationReceived notification =
      NotificationReceived.fromJson(jsonDecode(jsData));
  switch (notification.type) {
    case "news":
      Navigation.instance.navigate('/story',
          args: '${notification.seo_name_category},${notification.seo_name}');
      break;
    case "opinion":
      Navigation.instance.navigate('/opinionPage');
      Navigation.instance.navigate('/opinionDetails',
          args: '${notification.seo_name},${notification.category_id}');
      break;
    case "ghy_connect":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(2);
      Navigation.instance.navigate('/guwahatiConnects');
      Navigation.instance.navigate('/allImagesPage',
          args: int.parse(notification.post_id.toString()));
      break;
    case "ghy_connect_status":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(2);
      Navigation.instance.navigate('/guwahatiConnects');
      Navigation.instance.navigate('/allImagesPage',
          args: int.parse(notification.post_id.toString()));
      break;
    case "citizen_journalist":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(3);
      Navigation.instance.navigate('/citizenJournalist');
      break;
    case "ctz_journalist_status":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(3);
      Navigation.instance.navigate('/citizenJournalist');
      Navigation.instance.navigate('/submitedStory');
      Navigation.instance.navigate('/viewStoryPage',
          args: int.parse(notification.post_id.toString()));
      break;
    case "deals":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(1);
      Navigation.instance.navigate('/bigdealpage');
      Navigation.instance.navigate('/categorySelect',
          args: int.parse(notification.vendor_id.toString()));
      break;
    case "classified":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(4);
      Navigation.instance.navigate('/classified');
      Navigation.instance.navigate('/classifiedDetails',
          args: int.parse(notification.post_id.toString()));
      break;
    case "locality":
      Navigation.instance.navigate('/story',
          args: '${notification.seo_name_category},${notification.seo_name}');
      break;

    default:
      break;
  }
}

void main() async {
  // final FirebaseMessaging _firebaseMessaging;
  //Initializations
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: "GPlusNewApp",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterConfig.loadEnvVariables();
  setUpFirebase();
  Storage.instance.initializeStorage();
  StoreConfig(
    store: Store.appleStore,
    apiKey: FlutterConfig.get('revenueCatIOSKey') ?? "",
  );
  // final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  runApp(const MyApp());
}

void checkVersion(String version, String buildNumber) async {
  if (Platform.isIOS) {
    Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .setHide(true);
  }
}

void NotificationHandler(message) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  RemoteNotification? notification = message?.notification;
  AndroidNotification? android = message?.notification?.android;
  // debugPrint("test message is coming ${message?.data} ${android?.imageUrl??"!"} ${android!.smallIcon}");
  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: "@mipmap/ic_notification",
          // other properties...
        ),
        iOS: DarwinNotificationDetails(
          // badgeNumber: int.parse(channel.id),
          subtitle: channel.name,
        ),
      ),
      payload: '${message?.data}',
    );
  }
}

void setUpFirebase() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_notification');
  const DarwinInitializationSettings initializationSettingsIos =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIos,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) =>
            onDidReceiveNotificationResponse(notificationResponse),
    // onDidReceiveBackgroundNotificationResponse: (notificationResponse) =>
    //     notificationTapBackground,
  );
  await FirebaseMessaging.instance.getToken();
  // print("test message is coming firebase set up}");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('notification on front');

    NotificationHandler(message);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    print('killed notification');
    NotificationHandler(message);
  }); //
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    // initUniLinks();
    initValues();
    initDeepLink();
  }

  void initValues() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    debugPrint(
        "version:${packageInfo.version} buildNumber:${packageInfo.buildNumber}");
    //notification
    checkVersion(packageInfo.version, packageInfo.buildNumber);
  }

  void initDeepLink() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      debugPrint("URL link ${dynamicLinkData.link.path.split("/")}");
      sendToRoute(
        dynamicLinkData.link.path.split("/")[2].trim(),
        dynamicLinkData.link.path.split("/")[3].trim(),
        (dynamicLinkData.link.path.split("/").length <= 4
            ? ""
            : dynamicLinkData.link.path.split("/")[4].trim()),
      );
    }).onError((error) {
      // Handle errors
      debugPrint("URL link ${error}");
    });
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink == null) {
    } else {
      final Uri deepLink = initialLink.link;
      debugPrint("URL link2 ${deepLink}");
      Future.delayed(Duration(seconds: 5), () {
        sendToRoute(
          deepLink.path.split("/")[2].trim(),
          deepLink.path.split("/")[3].trim(),
          (deepLink.path.split("/").length <= 4
              ? ""
              : deepLink.path.split("/")[4].trim()),
        );
      });
      // Example of using the dynamic link to push the user to a different screen
    }
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => DataProvider(),
//       child: Sizer(builder: (context, orientation, deviceType) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'GPLUS',
//           theme: AppTheme.getTheme(),
//           navigatorKey: Navigation.instance.navigatorKey,
//           onGenerateRoute: generateRoute,
//         );
//       }),
//     );
//   }
// }

void setRead(String? id, seoName, categoryName, type, postId, vendorId,
    categoryId) async {
  final response = await ApiProvider.instance.notificationRead(id);
  if (response.success ?? false) {
    fetchNotification();
    sendToDestination(
        seoName, categoryName, type, postId, vendorId, categoryId);
  } else {
    showError(response.message ?? "Something went wrong");
  }
}

void fetchNotification() async {
  final response = await ApiProvider.instance.getNotifications();
  if (response.success ?? false) {
    Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .setNotificationInDevice(response.notification);
    // fetchReportMsg();
  } else {
    // fetchReportMsg();
  }
}

void sendToDestination(
    seoName, categoryName, type, id, vendorId, categoryId) async {
  switch (type) {
    case "news":
      debugPrint("News clicked ${categoryName},${seoName} ");
      Navigation.instance
          .navigate('/story', args: '${categoryName},${seoName}');
      break;
    case "opinion":
      Navigation.instance.navigate('/opinionPage');
      Navigation.instance
          .navigate('/opinionDetails', args: '${seoName},${categoryId}');
      break;
    case "ghy_connect":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(2);
      Navigation.instance.navigate('/guwahatiConnects');
      Navigation.instance
          .navigate('/allImagesPage', args: int.parse(id.toString()));
      break;
    case "ghy_connect_status":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(2);
      Navigation.instance.navigate('/guwahatiConnects');
      Navigation.instance
          .navigate('/allImagesPage', args: int.parse(id.toString()));
      break;
    case "citizen_journalist":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(3);
      Navigation.instance.navigate('/citizenJournalist');
      break;
    case "ctz_journalist_status":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(3);
      Navigation.instance.navigate('/citizenJournalist');
      Navigation.instance.navigate('/submitedStory');
      Navigation.instance
          .navigate('/viewStoryPage', args: int.parse(id.toString()));
      break;
    case "deals":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(1);
      Navigation.instance.navigate('/bigdealpage');
      Navigation.instance
          .navigate('/categorySelect', args: int.parse(vendorId));
      break;
    case "classified":
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setCurrent(4);
      Navigation.instance.navigate('/classified');
      Navigation.instance.navigate('/classifiedDetails', args: int.parse(id));
      break;
    case "locality":
      Navigation.instance
          .navigate('/story', args: '${categoryName},${seoName}');
      break;

    default:
      break;
  }
}



void sendToRoute(String route, data, String? category) async {
  print("link 1 our route ${route}");
  switch (route) {
    case "story":
      // Navigation.instance.navigate('/main');
      print("this route1");
      Navigation.instance.navigate('/story', args: '${category},${data}');
      break;
    case "opinion":
      // Navigation.instance.navigate('/main');
      print("this route2 ${category},${data}");
      Navigation.instance
          .navigate('/opinionDetails', args: '${data},${category}');
      break;
    default:
      debugPrint("deeplink failed 1 ${route}");
      Navigation.instance.navigate('/main', args: "");
      break;
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
