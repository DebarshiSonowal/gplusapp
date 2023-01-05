import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHelper {
  static late FirebaseApp _firebaseApp;
  static late FirebaseMessaging _firebaseMessaging;

  static final FirebaseHelper _singleton = FirebaseHelper._internal();
  static late Timer _timer;

  factory FirebaseHelper() {
    return _singleton;
  }

  FirebaseHelper._internal();

  // To Initialize Firebase
  static Future<void> init() async {
    _firebaseApp = await Firebase.initializeApp();
    await _initCloudMessaging();
  }

  static FirebaseApp getFireBaseApp() {
    return _firebaseApp;
  }

  // To Initialize Firebase FCM
  static Future<void> _initCloudMessaging() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.setForegroundNotificationPresentationOptions(sound: true, badge: true);
    await requestNotificationPermissions();
    _setUpNotificationListener();
  }

  static Future<NotificationSettings> getNotificationSettings() async {
    return await FirebaseMessaging.instance.getNotificationSettings();
  }

  // To Request Notification Permissions (For IOS)
  static Future<NotificationSettings> requestNotificationPermissions() async {
// for permission
    return await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
  }

  // To Set On Notification Listener
  static void _setUpNotificationListener() {
    //This method will call when the app is in kill state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        //Handle push notification redirection here
      }
    });

    //This method will call when the app is in foreground state
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message != null && message.data.isNotEmpty) {
        //Handle push notification redirection here
      }
    });

    //This method will call when the app is in background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        //Handle push notification redirection here
      }
    });
  }

  // To Get Device Token
  static Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

}