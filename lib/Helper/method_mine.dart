import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file_safe/open_file_safe.dart';

import '../Model/notification_received.dart';
import '../main.dart';

class MethodMine{
  // static Future<void> onDidReceiveBackgroundNotificationResponse(
  //     NotificationResponse notificationResponse) async {
  //   var details =
  //   await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  //   print("notification response ${details?.notificationResponse?.payload}");
  //   if (details?.didNotificationLaunchApp ?? false) {
  //     if (details?.notificationResponse?.payload != 'downloading') {
  //       OpenFile.open(details?.notificationResponse?.payload);
  //     }
  //   }
  //   try {
  //     print(
  //         "notification response1 ${notificationResponse.payload} ${notificationResponse.id} ${notificationResponse.input}");
  //   } catch (e) {
  //     print(e);
  //   }
  //   const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  //   // var jsData = jsonDecode(
  //   //     '{ "category_name": "Entertainment", "seo_name": "7-things-you-can-do-this-weekend-in-guwahati-4", "seo_name_category": "entertainment", "notification_id": "0f226151-e51c-4a75-abe8-bf5652cff30e", "type": "news", "title": "7 Things You Ca"  }' ??
  //   //         "");
  //   // var jsData = encoder.convert(notificationResponse.payload!);
  //   print(notificationResponse.payload);
  //   var jsData = notificationResponse.payload ?? "";
  //   jsData = jsData.replaceAll('{', '{"');
  //   jsData = jsData.replaceAll(': ', '": "');
  //   jsData = jsData.replaceAll(', ', '", "');
  //   jsData = jsData.replaceAll('}', '"}');
  //   print(jsData);
  //   NotificationReceived notification =
  //   NotificationReceived.fromJson(jsonDecode(jsData));
  //   // Navigation.instance.navigate('');
  //   setRead(
  //       notification.notification_id,
  //       notification.seo_name,
  //       notification.seo_name_category,
  //       notification.type,
  //       notification.post_id,
  //       notification.vendor_id,notification.category_id);
  // }
}