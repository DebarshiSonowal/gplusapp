import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:gplusapp/UI/main/home_screen_page.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
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
      appBar: buildAppBar(),
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
                            current.type);
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.5.w, vertical: 1.4.h),
                        width: double.infinity,
                        height: 14.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              current.title ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Constance.primaryColor,
                                    // fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Row(
                              children: [
                                // Icon(current.icon,color: Constance.primaryColor,),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Constance.primaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 0.9.w,vertical: 0.9.h),
                                  child: Image.asset(
                                    getIcon(current.type ?? "news"),
                                    height: 2.5.h,
                                    width: 6.w,
                                    fit: BoxFit.fill,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  getName(current.type ?? "news"),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(Navigation.instance
                                          .navigatorKey.currentContext!)
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
                                  Jiffy("${current.created_at?.split("T")[0]} ${current.created_at?.split("T")[1]}",
                                              "yyyy-MM-dd hh:mm:ss")
                                          .fromNow() ??
                                      '${current.created_at}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(Navigation.instance
                                          .navigatorKey.currentContext!)
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

  AppBar buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .setCurrent(0);
          Navigation.instance.navigate('/main');
        },
        child: Image.asset(
          Constance.logoIcon,
          fit: BoxFit.fill,
          scale: 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return Badge(
              badgeColor: Constance.secondaryColor,
              badgeContent: Text(
                '${data.notifications.length}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Constance.thirdColor,
                    ),
              ),
              child: const Icon(Icons.notifications),
            );
          }),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search', args: "");
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void setRead(String? id, seo_name, category_name, vendor_id, type) async {
    final response = await ApiProvider.instance.notificationRead(id);
    if (response.success ?? false) {
      fetchNotification();
      sendToDestination(seo_name, category_name, type, id, vendor_id);
      // Navigation.instance
      //     .navigate('/story', args: '${category_name},${seo_name}');
    } else {
      showError(response.message ?? "Something went wrong");
    }
  }

  void sendToDestination(seo_name, category_name, type, id, vendor_id) async {
    //News Notifications ( On all and selected News)
    //
    // Any Notifications to be sent from dashboard:- ( Example Earthquake)
    //
    // Ghy connect :- Status of Post Notifications and Comments Notification
    //
    // Citizen Journalist ( Post Status Notification)
    //
    // Big Deal offers Notifications- Based on locality / Locations on that area automatically
    // Or Any Notification of any vendor which can be send from backend  dashboard to promote their business and offers)
    //
    // Classifieds Ads:- Post accept Reject Status
    //
    // Also Locality Notifications
    switch (type) {
      case "news":
        Navigation.instance
            .navigate('/story', args: '${category_name},${seo_name}');
        break;
      case "ghy_connect":
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .setCurrent(2);
        Navigation.instance.navigate('/guwahatiConnects');

        break;
      case "citizen_journalist":
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .setCurrent(3);
        Navigation.instance.navigate('/citizenJournalist');
        break;
      case "deals":
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .setCurrent(1);
        Navigation.instance.navigate('/bigdealpage');
        Navigation.instance
            .navigate('/categorySelect', args: int.parse(vendor_id));
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
            .navigate('/story', args: '${category_name},${seo_name}');
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
}
