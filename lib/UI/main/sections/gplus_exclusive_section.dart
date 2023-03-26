import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/gplus_execl_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/DataProvider.dart';
import '../../../Helper/Storage.dart';
import '../../../Model/profile.dart';
import '../../../Navigation/Navigate.dart';

class GPlusExclusiveSection extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember;

  const GPlusExclusiveSection(
      {super.key, required this.data, required this.showNotaMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26.h,
      width: double.infinity,
      // color: Constance.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.home_exclusive.isNotEmpty? Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'G Plus Exclusive',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 16.sp,
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Constance.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ):Container(),
          SizedBox(
            height: 0.3.h,
          ),
          data.home_exclusive.isNotEmpty
              ? Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 4.w),
                    width: 95.w,
                    height: 20.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (cont, count) {
                        var item = data.home_exclusive[count];
                        if ((data.home_exclusive.length > 4
                                ? 3
                                : data.home_exclusive.length - 1) ==
                            count) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                if (item.has_permission ?? false) {
                                  logTheReadMoreClick(data.profile!);
                                  Navigation.instance
                                      .navigate('/exclusivePage');
                                } else {
                                  showNotaMember();
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  'Read More',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                        color: Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Constance.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              if (item.has_permission ?? false) {
                                logTheExclusiveClick(
                                    data.profile!,
                                    item.title!,
                                    "g_plus_exclusive",
                                    item.id!,
                                    DateFormat("dd MMM,yyyy").format(
                                        DateTime.parse(item.publish_date!)),
                                    item.author_name!);
                                Navigation.instance.navigate('/story',
                                    args:
                                        '${'exclusive-news'},${item.seo_name},g_plus_exclusive');
                              } else {
                                showNotaMember();
                              }
                            },
                            child: GPlusExecCard(item: item),
                          );
                        }
                      },
                      separatorBuilder: (cont, inde) {
                        return SizedBox(
                          width: 1.w,
                        );
                      },
                      itemCount: data.home_exclusive.length > 4
                          ? 4
                          : data.home_exclusive.length + 1,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void logTheReadMoreClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "read_more_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "screen_name": "home",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void logTheExclusiveClick(Profile profile, String heading, String title,
      int thisId, String published_date, String author_name) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "g_plus_exclusive_article_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "heading_name": heading,
        "article_id": thisId,
        "screen_name": "home",
        "title": title,
        "author_name": author_name,
        "published_date": published_date,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
