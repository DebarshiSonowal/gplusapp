import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/video_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/Storage.dart';
import '../../../Model/profile.dart';
import '../../../Navigation/Navigate.dart';

class VideoReportSection extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember;

  const VideoReportSection(
      {super.key, required this.data, required this.showNotaMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 26.h,
      // height: 35.h,
      width: double.infinity,
      // color: Constance.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.home_weekly.isNotEmpty?Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'Videos Of The Week',
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
          data.home_weekly.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(left: 4.w),
                  width: 95.w,
                  height: 21.h,
                  // height: 21.h,
                  // width: double.infinity,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (cont, count) {
                      var item = data.home_weekly[count];
                      if ((data.home_weekly.length > 4
                              ? 3
                              : data.home_weekly.length - 1) ==
                          count) {
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              if (item.has_permission ?? false) {
                                logTheReadMoreClick(data.profile!);
                                Navigation.instance
                                    .navigate('/videoReport', args: 'news');
                              } else {
                                showNotaMember();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'Watch More',
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
                              if (data.profile?.is_plan_active ?? false) {
                                logTheVideoReportClick(
                                  data.profile!,
                                  item.title!,
                                  item.id!,
                                  DateFormat("dd MMM,yyyy").format(
                                      DateTime.parse(item.publish_date!)),
                                );
                                Navigation.instance.navigate('/videoPlayer',
                                    args: '${item.youtube_id},${1}');
                              } else {
                                showNotaMember();
                              }
                            },
                            child: VideoCard(item: item));
                      }
                    },
                    separatorBuilder: (cont, inde) {
                      return SizedBox(
                        width: 1.w,
                      );
                    },
                    itemCount: data.home_weekly.length > 4
                        ? 4
                        : data.home_weekly.length + 1,
                  ),
                )
              : Container(),

          // SizedBox(
          //   height: 1.h,
          // ),
        ],
      ),
    );
  }

  void logTheReadMoreClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "watch_more_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "screen_name": "home",
        "title": "videos_of_the_week",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void logTheVideoReportClick(
    Profile profile,
    String heading,
    int thisId,
    String published_date,
    // String author_name
  ) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "video_of_the_week_article_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "heading_name": heading,
        "article_id": thisId,
        "screen_name": "home",
        "title": "videos_of_the_week",
        // "author_name": author_name,
        "published_date": published_date,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
