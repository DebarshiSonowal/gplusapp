import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/toppicks_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/DataProvider.dart';
import '../../../Helper/Storage.dart';
import '../../../Model/profile.dart';
import '../../../Navigation/Navigate.dart';

class SuggestedForYou extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember;

  const SuggestedForYou(
      {super.key, required this.data, required this.showNotaMember});

  @override
  Widget build(BuildContext context) {
    return data.home_toppicks.isEmpty
        ? Container()
        : Container(
            height: 27.h,
            width: double.infinity,
            color: Constance.secondaryColor,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'Top Picks For You',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  margin: EdgeInsets.only(left: 4.w),
                  width: 95.w,
                  height: 20.h,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data.home_toppicks.length > 4
                        ? 4
                        : data.home_toppicks.length + 1,
                    itemBuilder: (cont, count) {
                      var item = data.home_toppicks[count];
                      if ((data.home_toppicks.length > 4
                              ? 3
                              : data.home_toppicks.length - 1) ==
                          count) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.w, vertical: 1.5.h),
                          // height: 5.h,
                          // width: 20.w,
                          child: TextButton(
                            onPressed: () {
                              logTheViewAllClick(
                                  data.profile!, "top_picks_for_you");
                              Navigation.instance.navigate('/toppicks');
                            },
                            child: Text(
                              'View All',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                  ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            if (data.profile?.is_plan_active ?? false) {
                              logTheTopPicksClick(
                                data.profile!,
                                item.title!,
                                "top_picks_for_you",
                                item.id!,
                                DateFormat("dd MMM,yyyy")
                                    .format(DateTime.parse(item.date!)),
                              );
                              Navigation.instance.navigate('/story',
                                  args:
                                      '${item.categories?.first.seo_name},${item.seo_name}');
                            } else {
                              showNotaMember();
                            }
                          },
                          child: SuggestedForYouCard(item: item),
                        );
                      }
                    },
                    separatorBuilder: (cont, inde) {
                      return SizedBox(
                        width: 1.w,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  void logTheTopPicksClick(Profile profile, String heading, String title,
      int thisId, String published_date) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "top_picks_article_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "heading_name": heading,
        "article_id": thisId,
        "screen_name": "home",
        "title": title,
        "published_date": published_date,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void logTheViewAllClick(Profile profile, String title) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "view_all_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "screen_name": "home",
        "title": title,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
