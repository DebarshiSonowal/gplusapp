import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';

import '../Components/alert.dart';
import '../Model/notification_received.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'Constance.dart';
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
    debugPrint(
        "Notification Payload ${notificationResponse.payload} ${notificationResponse.input}");
    var jsData = notificationResponse.payload ?? "";
    var jsData1 = notificationResponse.payload ?? "";
    jsData = jsData.replaceAll('{', '{"');
    jsData = jsData.replaceAll(': ', '": "');
    jsData = jsData.replaceAll(', ', '", "');
    jsData = jsData.replaceAll('}', '"}');
    jsData = jsData.replaceAll('{', '{"');

    if (notificationResponse.payload!.contains("click_action:")) {
      testThis("${notificationResponse.payload}");
      var propertyPattern = RegExp(r'(\w+): ([^,]+)');

      var json = <String, String?>{};

      propertyPattern
          .allMatches("${notificationResponse.payload}")
          .forEach((match) {
        var propertyName = match.group(1);
        var propertyValue = match.group(2);

        json[propertyName!] = propertyValue!.trim();
      });
      NotificationReceived notification =
          // NotificationReceived.fromJson(jsonDecode(jsData1));
          NotificationReceived.fromJson(json);
      setRead(
          notification.notification_id,
          notification.seo_name,
          notification.seo_name_category,
          notification.type,
          notification.post_id,
          notification.vendor_id,
          notification.category_id,notification.seo_name_category,notification.title);
    } else {
      try {
        OpenFile.open(notificationResponse.payload!);
      } catch (e) {
        print(e);
      }
    }
    // jsData = jsData.replaceAll('category_name: ', 'category_name: "');
    // jsData = jsData.replaceAll('seo_name_category: ', 'seo_name_category: "');
    // jsData = jsData.replaceAll('notification_id: ', 'notification_id: "');
    // jsData = jsData.replaceAll('body: ', 'body: "');
    // jsData = jsData.replaceAll('type: ', 'type: "');
    // jsData = jsData.replaceAll('title: ', 'title: "');
    // jsData = jsData.replaceAll('click_action: ', 'click_action: "');
    // jsData = jsData.replaceAll(', ', '", "');
    // jsData = jsData.replaceAll('}', '"}');
    // debugPrint(jsData);

    //
    // jsData1 = jsData1.replaceAll('{', '{"');
    // jsData1 = jsData1.replaceAll(': ', '": "');
    // jsData1 = jsData1.replaceAll(', ', '", "');
    // jsData1 = jsData1.replaceAll('}', '"}');
    // jsData1 = jsData1.replaceAll('*%', ',');
    // jsData1 = jsData1.replaceAll('%*', ':');
    // debugPrint(jsData1);

    // try {
    //   NotificationReceived notification =
    //           NotificationReceived.fromJson(jsonDecode(jsData));
    //   setRead(
    //       notification.notification_id,
    //       notification.seo_name,
    //       notification.seo_name_category,
    //       notification.type,
    //       notification.post_id,
    //       notification.vendor_id,
    //       notification.category_id);
    // } catch (e) {
    //   print(e);
    //   NotificationReceived notification =
    //   NotificationReceived.fromJson(jsonDecode(jsData1));
    //   setRead(
    //       notification.notification_id,
    //       notification.seo_name,
    //       notification.seo_name_category,
    //       notification.type,
    //       notification.post_id,
    //       notification.vendor_id,
    //       notification.category_id);
    // }
    // Navigation.instance.navigate('');
  }

  static void setRead(String? id, seoName, categoryName, type, postId, vendorId,
      categoryId,seo_name_category,title) async {
    final response = await ApiProvider.instance.notificationRead(id);
    if (response.success ?? false) {
      fetchNotification();
      sendToDestination(
          seoName, categoryName, type, postId, vendorId, categoryId,seo_name_category,title);
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
      seoName, categoryName, type, id, vendorId, categoryId,seo_name_category,title) async {
    switch (type) {
      case "news":
        debugPrint("News clicked ${categoryName},${seoName} ");
        // Navigation.instance.navigate("/main");
        if ((Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext!,
                    listen: false)
                .profile
                ?.is_plan_active ??
            false)) {
          Navigation.instance
              .navigate('/story', args: '$categoryName,$seoName,home_page');
        }else{
          Navigation.instance.navigate('/beamember');
        }
        break;
      case "opinion":
        // Navigation.instance.navigate("/main");
        if ((Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext!,
            listen: false)
            .profile
            ?.is_plan_active ??
            false)) {
          Navigation.instance.navigate('/opinionPage',args: "${seo_name_category}");
          Navigation.instance
              .navigate('/opinionDetails', args: '$seoName,$categoryId');
        }else{
          Navigation.instance.navigate('/beamember');
        }
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
        Navigation.instance.navigate("/emergency",args: title);
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

  static void testThis(String s) {
    var propertyPattern = RegExp(r'(\w+): ([^,}]+)');

    var json = <String, String?>{};

    propertyPattern.allMatches(s).forEach((match) {
      var propertyName = match.group(1);
      var propertyValue = match.group(2);

      json[propertyName!] = propertyValue!.trim();
    });

    // Access the values
    String? categoryName = json['category_name'];
    String? seoName = json['seo_name'];
    String? seoNameCategory = json['seo_name_category'];
    String? notificationId = json['notification_id'];
    String? body = json['body'];
    String? type = json['type'];
    String? title = json['title'];
    String? clickAction = s.split('click_action: ')[1].split('}')[0];

    // Print the values
    print('category_name: $categoryName');
    print('seo_name: $seoName');
    print('seo_name_category: $seoNameCategory');
    print('notification_id: $notificationId');
    print('body: $body');
    print('type: $type');
    print('title: $title');
    print('click_action: $clickAction');
  }
}
