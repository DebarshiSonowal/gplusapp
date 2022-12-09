import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'Helper/AppTheme.dart';
import 'Helper/Constance.dart';
import 'Helper/DataProvider.dart';
import 'Helper/method_mine.dart';
import 'Navigation/Navigate.dart';
import 'Navigation/routes.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  try {
    print(
        "notification response1 ${notificationResponse.payload} ${notificationResponse.id} ${notificationResponse.input}");
  } catch (e) {
    print(e);
  }

  // Or do other work.
}

void main() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: "GPlusNewApp",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUpFirebase();
  Storage.instance.initializeStorage();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIos =
      DarwinInitializationSettings();

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
    //     MethodMine.onDidReceiveBackgroundNotificationResponse(notificationResponse)

    //     onSelectNotification: (String? payload) async {
    //   if (payload != null) {
    //     debugPrint('notification payload: $payload');
    //     if (payload != 'downloading') {
    //       OpenFile.open(payload);
    //     }
    //   }
    // }
  );
  var details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  print("notification response ${details?.notificationResponse?.payload}");
  if (details?.didNotificationLaunchApp ?? false) {
    if (details?.notificationResponse?.payload != 'downloading') {
      OpenFile.open(details?.notificationResponse?.payload);
    }
  }

  runApp(const MyApp());
}

void setUpFirebase() async {
  await FirebaseMessaging.instance.getToken();
  // print("test message is coming firebase set up}");
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
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print("test message is coming ${message.data}");
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
            icon: android.smallIcon,
            // other properties...
          ),
          iOS: DarwinNotificationDetails(
            badgeNumber: int.parse(channel.id),
            subtitle: channel.name,
          ),
        ),
        payload: '${message.data}',
      );
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GPLUS',
          theme: AppTheme.getTheme(),
          navigatorKey: Navigation.instance.navigatorKey,
          onGenerateRoute: generateRoute,
        );
      }),
    );
  }
}
