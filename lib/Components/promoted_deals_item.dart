import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Components/promoted_deal_cupon.dart';
import 'package:gplusapp/Components/promoted_deal_item_data.dart';
import 'package:gplusapp/Components/promoted_deal_item_image.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/profile.dart';
import '../Model/promoted_deal.dart';
import '../Navigation/Navigate.dart';

class PromotedDealsItem extends StatelessWidget {
  const PromotedDealsItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final PromotedDeal data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile
                ?.is_plan_active ??
            false) {
          logTheBigDealCategoryClick(
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile!,
            data.vendor?.shop_name ?? "",
            data.vendor?.address ?? "",
            data.id!,
            data.title ?? "",
            "promoted_deal",
          );
          Navigation.instance.navigate('/categorySelect', args: data.vendor_id);
        } else {
          Constance.showMembershipPrompt(context, () {});
        }
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            color: Storage.instance.isDarkMode
                ? Constance.secondaryColor
                : Constance.forthColor,
            child: Container(
              width: 83.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PromotedDealItemImage(data: data),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  PromotedDealItemData(data: data),
                ],
              ),
            ),
          ),
          PromotedDealItemCupon(data: data),
        ],
      ),
    );
  }

  void logTheBigDealCategoryClick(
      Profile profile,
      String heading_name,
      String banner_category,
      int article_id,
      String offer_name,
      String title) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "big_deal_banner_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "banner_position": "top",
        "heading_name": heading_name,
        "screen_name": "subscription",
        "banner_category": banner_category,
        "article_id": article_id,
        "offer_name": offer_name,
        "title": title,
        // "big_deal_category": big_deal_category,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
