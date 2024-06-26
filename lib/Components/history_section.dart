import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Components/history_item.dart';
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
import 'alert.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Card(
          color: Constance.secondaryColor,
          child: ExpansionTile(
            onExpansionChanged: (val) {
              debugPrint(data.history.length.toString());
              logTheHistoryClick(Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
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
              data.history.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(
                        color: Constance.secondaryColor,
                        thickness: 0.1.h,
                      ),
                    ),
              data.history.isEmpty
                  ? Center(
                      child: Text(
                        data.refer_history_msg,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Constance.thirdColor),
                      ),
                    )
                  : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (cont, count) {
                      var current = data.history.reversed.toList()[count];
                      return GestureDetector(
                        onTap: () {
                          if (current.has_permission ?? false) {
                            redeem(current.vendor_id!, current.code);
                          } else {
                            Constance.showMembershipPrompt(cont, () {});
                          }
                        },
                        child: HistoryItem(current:current),
                      );
                    },
                    separatorBuilder: (cont, count) {
                      return SizedBox(
                        height: 1.h,
                      );
                    },
                    itemCount: data.history.length,
                  ),
              data.history.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(
                        color: Constance.secondaryColor,
                        thickness: 0.1.h,
                      ),
                    ),
              data.history.isEmpty
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
    });
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
      showError(response.message ?? "Something went wrong");
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
      // debugPrint();
    } else {
      // _refreshController.refreshFailed();
    }
  }
}
