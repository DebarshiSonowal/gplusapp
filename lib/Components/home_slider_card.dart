import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';
import "../Helper/string_extension.dart";
import '../Helper/Constance.dart';
import '../Model/article.dart';
import '../Model/profile.dart';
import '../Navigation/Navigate.dart';

class HomeSliderItem extends StatelessWidget {
  const HomeSliderItem({
    Key? key,
    required this.current,
    required this.data,
    required this.showNotaMember,
  }) : super(key: key);

  final Article current;
  final DataProvider data;
  final Function showNotaMember;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.profile?.is_plan_active ?? false) {
          logTheBannerClick(data.profile!, current.title!,
              current.first_cat_name?.seo_name ?? "", current.id!);
          Navigation.instance.navigate('/story',
              args: '${current.first_cat_name?.seo_name},${current.seo_name}');
        } else {
          showNotaMember();
        }
      },
      child: Container(
        // height: 45.h,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: current.image_file_name ?? "",
              width: double.infinity,
              height: 55.h,
              fit: BoxFit.fill,
              // filterQuality: FilterQuality.low,
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
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ),
              ),
              // color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    color: Constance.primaryColor,
                    child: Text(
                      current.first_cat_name?.seo_name
                              ?.capitalize()
                              .replaceFirst("-", " ") ??
                          'Big Deals\nand Offers',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.grey.shade200,
                            // fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    current.title ?? 'Big Deals\nand Offers',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Colors.grey.shade200,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  // Text(
                  //   "${current.author_name?.trim()}, ${Jiffy(current.publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}",
                  //   style: Theme.of(context).textTheme.headline6?.copyWith(
                  //         color: Colors.white,
                  //       ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logTheBannerClick(
      Profile profile, String heading, String category, int thisId) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "home_page_banner_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "banner_position": "top",
        "heading_name": heading,
        "banner_category": category,
        "article_id": thisId,
        "screen_name": "home",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
