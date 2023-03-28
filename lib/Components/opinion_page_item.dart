import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/opinion.dart';
import '../Model/profile.dart';
import '../Navigation/Navigate.dart';

class OpionionPageItem extends StatelessWidget {
  final DataProvider data;
  const OpionionPageItem({
    Key? key,
    required this.item, required this.data,
  }) : super(key: key);

  final Opinion item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.has_permission ?? false) {
          // Navigation.instance.navigate(
          //     '/opinionDetails',
          //     args: item.seo_name?.trim());
          logTheOpinionArticleClick(
            data.profile!,
            item.title!,
            "opinion",
            item.id!,
            DateFormat("dd MMM, yyyy").format(
                DateTime.parse(item.publish_date!)),
            item.user!.name!,
          );
          Navigation.instance.navigate('/opinionDetails',
              args: '${item.seo_name?.trim()},${item.category_gallery?.id}');
        } else {
          Constance.showMembershipPrompt(
              context, () {});
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          color: Storage.instance.isDarkMode
              ? Colors.black
              : Colors.white,
        ),
        height: 20.h,
        width:
        MediaQuery.of(context).size.width - 7.w,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    height: 17.7.h,
                    width: 45.w,
                    imageUrl:
                    item.image_file_name ?? '',
                    fit: BoxFit.fill,
                    placeholder: (cont, _) {
                      return Image.asset(
                        Constance.logoIcon,
                        // color: Colors.black,
                      );
                    },
                    errorWidget: (cont, _, e) {
                      return Image.network(
                        Constance.defaultImage,
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),

                ],
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title ?? "",
                      maxLines: 8,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight:
                          FontWeight.bold,
                          overflow: TextOverflow
                              .ellipsis,
                          color: Storage
                              .instance
                              .isDarkMode
                              ? Colors.white
                              : Constance
                              .primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 4.w,
                      // ),
                      Text(
                        Jiffy(item.publish_date?.split(" ")[0] ?? "", "yyyy-MM-dd")
                            .format("dd MMM, yyyy"),
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Row(
                    children: [
                      // Image.asset(
                      //   Constance.authorIcon,
                      //   color: Constance.secondaryColor,
                      //   // size: 8.sp,
                      //   scale: 37,
                      // ),
                      // SizedBox(
                      //   width: 1.w,
                      // ),
                      SizedBox(
                        width: 45.w,
                        child: Text(
                          item.user?.name ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black54),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
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
}