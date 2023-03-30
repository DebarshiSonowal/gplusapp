import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';

import '../Components/alert.dart';
import '../Model/notification_received.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'DataProvider.dart';

class NotificationHelper {
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_notification');
  static const DarwinInitializationSettings initializationSettingsIos =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  static const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIos,
  );
  static final notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      NotificationHelper.channel.id,
      NotificationHelper.channel.name,
      channelDescription: NotificationHelper.channel.description,
      icon: "@drawable/ic_notification",
      // other properties...
    ),
    iOS: DarwinNotificationDetails(
      // badgeNumber: int.parse(channel.id),
      subtitle: NotificationHelper.channel.name,
    ),
  );

  static Future<void> onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    var details = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();
    debugPrint(
        "onDidReceiveNotificationResponse ${details?.notificationResponse?.payload} ${details?.notificationResponse?.input}");
    if (details?.didNotificationLaunchApp ?? false) {
      if (details?.notificationResponse?.payload != 'downloading') {
        OpenFile.open(details?.notificationResponse?.payload);
      }
    }
    debugPrint("Notification Payload ${notificationResponse.payload} ${notificationResponse.input}");
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

  static void setRead(String? id, seoName, categoryName, type, postId, vendorId,
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

  static void fetchNotification() async {
    final response = await ApiProvider.instance.getNotifications();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setNotificationInDevice(response.notification);
      // fetchReportMsg();
    } else {
      // fetchReportMsg();
    }
  }

  static void sendToDestination(
      seoName, categoryName, type, id, vendorId, categoryId) async {
    switch (type) {
      case "news":
        debugPrint("News clicked ${categoryName},${seoName} ");
        // Navigation.instance.navigate("/main");
        Navigation.instance
            .navigate('/story', args: '${categoryName},${seoName},home_page');
        break;
      case "opinion":
        // Navigation.instance.navigate("/main");
        Navigation.instance.navigate('/opinionPage');
        Navigation.instance
            .navigate('/opinionDetails', args: '${seoName},${categoryId}');
        break;
      case "ghy_connect":
        // Navigation.instance.navigate("/main");
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .setCurrent(2);
        Navigation.instance.navigate('/guwahatiConnects');
        Navigation.instance
            .navigate('/allImagesPage', args: int.parse(id.toString()));
        break;
      case "ghy_connect_status":
        // Navigation.instance.navigate("/main");
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .setCurrent(2);
        Navigation.instance.navigate('/guwahatiConnects');
        Navigation.instance
            .navigate('/allImagesPage', args: int.parse(id.toString()));
        break;
      case "citizen_journalist":
        // Navigation.instance.navigate("/main");
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .setCurrent(3);
        Navigation.instance.navigate('/citizenJournalist');
        break;
      case "ctz_journalist_status":
        // Navigation.instance.navigate("/main");
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
        // Navigation.instance.navigate("/main");
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .setCurrent(1);
        Navigation.instance.navigate('/bigdealpage');
        Navigation.instance
            .navigate('/categorySelect', args: int.parse(vendorId));
        break;
      case "classified":
        // Navigation.instance.navigate("/main");
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .setCurrent(4);
        Navigation.instance.navigate('/classified');
        Navigation.instance.navigate('/classifiedDetails', args: int.parse(id));
        break;
      case "locality":
        // Navigation.instance.navigate("/main");
        Navigation.instance
            .navigate('/story', args: '${categoryName},${seoName},home_page');
        break;

      default:
        break;
    }
  }

  static void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }
}
