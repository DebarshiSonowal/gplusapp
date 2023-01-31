import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Model/notification_in_device.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import '../main.dart';

class NotificationPageItem extends StatelessWidget {
  const NotificationPageItem({Key? key, required this.current})
      : super(key: key);
  final NotificationInDevice current;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(current.id!),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setRead(current.id);
        Provider.of<DataProvider>(context, listen: false)
            .removeNotificationInDevice(current);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black26,
            ),
            borderRadius: BorderRadius.circular(
                5) // use instead of BorderRadius.all(Radius.circular(20))
            ),
        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 1.h),
        width: double.infinity,
        height: 12.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              current.title ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(Navigation.instance.navigatorKey.currentContext!)
                  .textTheme
                  .headline4
                  ?.copyWith(
                    color: Constance.primaryColor,
                    // fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Icon(current.icon,color: Constance.primaryColor,),
                Container(
                  // height: 9.h,
                  // width: 9.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constance.primaryColor,
                  ),
                  padding: EdgeInsets.all(0.5.h),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(1.3.h), // Image radius
                      child: Image.asset(
                        getIcon(current.type ?? "news"),
                        fit: BoxFit.cover,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  getName(current.type ?? "news"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style:
                      Theme.of(Navigation.instance.navigatorKey.currentContext!)
                          .textTheme
                          .headline6
                          ?.copyWith(
                            color: Constance.primaryColor,
                            // fontSize: 11.sp,
                            // fontWeight: FontWeight.bold,
                          ),
                ),
                Spacer(),
                Text(
                  Jiffy("${current.created_at?.split("T")[0]} ${current.created_at?.split("T")[1].split(".")[0]}",
                              "yyyy-MM-dd hh:mm:ss")
                          .fromNow() ??
                      '${current.created_at}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style:
                      Theme.of(Navigation.instance.navigatorKey.currentContext!)
                          .textTheme
                          .headline6
                          ?.copyWith(
                            color: Constance.primaryColor,
                            // fontSize: 11.sp,
                            // fontWeight: FontWeight.bold,
                          ),
                ),
              ],
            ),
          ],
        ),
        // color: Colors.red,
      ),
    );
  }

  String getIcon(type) {
    switch (type) {
      case "news":
        return Constance.newsIcon;
      case "notification_news":
        return Constance.newsIcon;
      case "ghy_connect":
        return Constance.connectIcon;
      case "deals":
        return Constance.bigDealIcon;
      case "classified":
        return Constance.classifiedIcon;
      case "alert":
        return Constance.warningIcon;
      default:
        return Constance.logoIcon;
    }
  }

  String getName(type) {
    switch (type) {
      case "news":
        return "News";
      case "notification_news":
        return "News Notification";
      case "ghy_connect":
        return "Guwahati Connect";
      case "deals":
        return "Big Deals";
      case "classified":
        return "Classified";
      case "alert":
        return "Alert";
      default:
        return "";
    }
  }

  void setRead(String? id) async {
    final response = await ApiProvider.instance.notificationRead(id);
    if (response.success ?? false) {
      fetchNotification();
    } else {
      showError(response.message ?? "Something went wrong");
    }
  }

  void fetchNotification() async {
    final response = await ApiProvider.instance.getNotifications();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setNotificationInDevice(response.notification);
      // setState(() {
      //   isEmpty = response.notification.isEmpty ? true : false;
      // });
    } else {
      // setState(() {
      //   isEmpty = true;
      // });
    }
  }
}
