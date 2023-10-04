import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/opinion_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/Storage.dart';
import '../../../Model/profile.dart';
import '../../../Navigation/Navigate.dart';

class OpinionSection extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember;

  const OpinionSection(
      {super.key, required this.data, required this.showNotaMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // color: Constance.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'Opinion',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 16.sp,
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Constance.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          data.latestOpinions.isNotEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (cont, count) {
                      var item = data.latestOpinions[count];
                      return GestureDetector(
                          onTap: () {
                            if (item.has_permission ?? false) {
                              logTheOpinionArticleClick(
                                data.profile!,
                                item.title!,
                                "opinion",
                                item.id!,
                                DateFormat("dd MMM, yyyy")
                                    .format(DateTime.parse(item.publish_date!)),
                                item.user!.name!,
                              );
                              Navigation.instance.navigate('/opinionDetails',
                                  args:
                                      '${item.seo_name?.trim()},${item.category_gallery?.id}');
                            } else {
                              showNotaMember();
                            }
                          },
                          child: OpinionCard(item: item));
                    },
                    separatorBuilder: (cont, inde) {
                      return SizedBox(
                        width: 10.w,
                        height: 1.h,
                      );
                    },
                    itemCount: (data.latestOpinions.length > 3
                            ? data.latestOpinions.length / 3.toInt()
                            : data.latestOpinions.length)
                        .toInt(),
                  ),
                )
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(
                          width: 0.5,
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Storage.instance.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      ),
                      height: 13.h,
                      width: MediaQuery.of(context).size.width - 7.w,
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.shade300,
                        enabled: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w,),
                              child: Container(
                                color: Colors.grey.shade200,
                                height: 1.5.h,
                                width: 80.w,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w,),
                              child: Container(
                                color: Colors.grey.shade200,
                                height: 1.5.h,
                                width: 80.w,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Divider(
                              color: Colors.grey.shade200,
                              thickness: 0.2.h,
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w,),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.grey.shade200,
                                    height: 1.5.h,
                                    width: 30.w,
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    height: 1.5.h,
                                    width: 30.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (data.latestOpinions[0].has_permission ?? false) {
                    logTheReadMoreClick(data.profile!);
                    Navigation.instance.navigate('/opinionPage');
                  } else {
                    showNotaMember();
                  }

                  // Navigation.instance
                  //     .navigate('/authorPage', args: 1);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'Read More',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void logTheOpinionArticleClick(Profile profile, String heading, String title,
      int thisId, String published_date, String author_name) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "opinion_article_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "heading_name": heading,
        "article_id": thisId,
        "screen_name": "home",
        "title": "opinion",
        "author_name": author_name,
        "published_date": published_date,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
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
}
