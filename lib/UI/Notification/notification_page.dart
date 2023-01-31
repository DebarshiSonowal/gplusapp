import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Model/notification_in_device.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:gplusapp/UI/main/home_screen_page.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Components/notification_page_item.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    fetchNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar(),
      // drawer: BergerMenuMemPage(),
      body: Consumer<DataProvider>(builder: (context, data, _) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color:
              Storage.instance.isDarkMode ? Colors.black : Colors.grey.shade200,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: data.notifications.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.notifications.length,
                  itemBuilder: (cont, count) {
                    var current = data.notifications[count];
                    return GestureDetector(
                      onTap: () {
                        setRead(
                            current.id,
                            current.seo_name,
                            current.seo_name_category,
                            current.vendor_id,
                            current.type,
                            current.notification_id);
                      },
                      child: NotificationPageItem(current: current),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 1.h,
                    );
                  },
                )
              : Lottie.asset(
                  isEmpty ? Constance.noDataLoader : Constance.searchingIcon,
                ),
        );
      }),
    );
  }

  void setRead(
      String? id, seo_name, category_name, vendor_id, type, categoryId) async {
    final response = await ApiProvider.instance.notificationRead(id);
    if (response.success ?? false) {
      fetchNotification();
      sendToDestination(
          seo_name, category_name, type, id, vendor_id, categoryId);
      // Navigation.instance
      //     .navigate('/story', args: '${category_name},${seo_name}');
    } else {
      showError(response.message ?? "Something went wrong");
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

  void fetchNotification() async {
    final response = await ApiProvider.instance.getNotifications();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setNotificationInDevice(response.notification);
      setState(() {
        isEmpty = response.notification.isEmpty ? true : false;
      });
    } else {
      setState(() {
        isEmpty = true;
      });
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
}
