import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'Helper/AppTheme.dart';
import 'Helper/Constance.dart';
import 'Helper/DataProvider.dart';
import 'Navigation/Navigate.dart';
import 'Navigation/routes.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: "GPlusNewApp",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Storage.instance.initializeStorage();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
          if(payload != 'downloading'){
            OpenFile.open(payload);
          }
        }
      });

  runApp(const MyApp());
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
