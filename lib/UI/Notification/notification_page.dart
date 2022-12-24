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
                        setRead(current.id, current.seo_name,
                            current.seo_name_category);
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
                              '${current.title}',
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
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  current.author_name ?? "G Plus",
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
                  isEmpty?Constance.noDataLoader:Constance.searchingIcon,
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
            Navigation.instance.navigate('/search');
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void setRead(String? id, seo_name, category_name) async {
    final response = await ApiProvider.instance.notificationRead(id);
    if (response.success ?? false) {
      fetchNotification();
      Navigation.instance
          .navigate('/story', args: '${seo_name},${category_name}');
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
