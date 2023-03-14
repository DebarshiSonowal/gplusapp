import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/main.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/profile.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';

class HistorySection extends StatelessWidget {
  final DataProvider current;

  const HistorySection({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        color: Constance.secondaryColor,
        child: ExpansionTile(
          onExpansionChanged: (val) {
            logTheHistoryClick(Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile!);
          },
          collapsedIconColor: Colors.black,
          iconColor: Colors.black,
          title: Text(
            'History',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(Navigation.instance.navigatorKey.currentContext!)
                .textTheme
                .headline3
                ?.copyWith(
                  color: Colors.black,
                  // fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
          children: [
            current.history.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      color: Constance.secondaryColor,
                      thickness: 0.1.h,
                    ),
                  ),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (cont, count) {
                var data = current.history.reversed.toList()[count];
                return GestureDetector(
                  onTap: () {
                    redeem(data.vendor_id!, data.code);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 44.w,
                              child: Text(
                                data.title ?? '25% OFF',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontSize: 11.sp,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            SizedBox(
                              width: 44.w,
                              child: Text(
                                data.vendor?.shop_name ?? "",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            SizedBox(
                              width: 40.w,
                              child: Text(
                                data.vendor?.address ?? 'RGB road, Zoo tiniali',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontSize: 11.sp,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 30.w,
                              child: Text(
                                data.code ?? '8486',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.grey.shade800,
                                      // fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              'From: ${Jiffy(data.valid_from.toString().split('T')[0] ?? "", "yyyy-MM-dd").format("dd/MM/yyyy")}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.black,
                                    // fontSize: 11.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              'To: ${Jiffy(data.valid_to.toString().split('T')[0] ?? "", "yyyy-MM-dd").format("dd/MM/yyyy")}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.black,
                                    // fontSize: 11.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (cont, count) {
                return SizedBox(
                  height: 1.h,
                );
              },
              itemCount: current.history.length,
            ),
            current.history.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      color: Constance.secondaryColor,
                      thickness: 0.1.h,
                    ),
                  ),
            current.history.isEmpty
                ? Container()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      children: [
                        Text(
                          'See More',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: Theme.of(Navigation
                                  .instance.navigatorKey.currentContext!)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                color: Constance.secondaryColor,
                                // fontSize: 11.sp,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void logTheHistoryClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "history_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "big_deal_category": big_deal_category,
        "screen_name": "bigdeal",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void redeem(int id, String? code) async {
    final response = await ApiProvider.instance.redeemCupon(id, code);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setRedeemDetails(response.details!);
      fetchHistory();
      // Navigation.instance.navigate('/redeemOfferPage');
      fetchDetails(id);
    } else {
      // Navigation.instance.navigate('/redeemOfferPage');
      showError(response.message??"Something went wrong");
    }
  }

  void fetchDetails(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getDealDetails(id);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
          Navigation.instance.navigatorKey.currentContext!,
          listen: false)
          .setDealDetails(response.details!);
      Navigation.instance.navigateAndReplace('/redeemOfferPage');
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
      Navigation.instance.goBack();
    }
  }
  void fetchHistory() async {
    final response = await ApiProvider.instance.getRedeemHistory();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setRedeemHistory(response.data ?? []);
    } else {
      // _refreshController.refreshFailed();
    }
  }
}
