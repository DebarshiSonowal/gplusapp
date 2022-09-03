// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
// final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// String selectedNotificationPayload;
//
// class ReceivedNotification {
//   ReceivedNotification({
//     @required this.id,
//     @required this.title,
//     @required this.body,
//     @required this.payload,
//   });
//
//   final int id;
//   final String title;
//   final String body;
//   final String payload;
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: (String? payload) async {
//         if (payload != null) {
//           debugPrint('notification payload: $payload');
//         }
//       });
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Text(
//           'Download Progress Notification',
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await _showProgressNotification();
//         },
//         tooltip: 'Download Notification',
//         child: Icon(Icons.download_sharp),
//       ),
//     );
//   }
//
//   Future<void> _showProgressNotification() async {
//     const int maxProgress = 5;
//     for (int i = 0; i <= maxProgress; i++) {
//       await Future<void>.delayed(const Duration(seconds: 1), () async {
//         final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('progress channel', 'progress channel',
//             'progress channel description',
//             channelShowBadge: false,
//             importance: Importance.max,
//             priority: Priority.high,
//             onlyAlertOnce: true,
//             showProgress: true,
//             maxProgress: maxProgress,
//             progress: i);
//         final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//         await flutterLocalNotificationsPlugin.show(
//             0,
//             'progress notification title',
//             'progress notification body',
//             platformChannelSpecifics,
//             payload: 'item x');
//       });
//     }
//   }
// }