import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/membership.dart';
import '../Model/profile.dart';
import '../Navigation/Navigate.dart';
import 'custom_button.dart';

class BeMemberCard extends StatelessWidget {
  const BeMemberCard({
    super.key,
    required this.current,
    required this.count,
  });

  final Membership current;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constance.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Get the ${current.name}',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Row(
              children: [
                Text(
                  'Rs ${current.base_price}/',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  current.duration?.split(" ")[1] ?? "",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Text(
              'You save Rs ${current.discount}',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Text(
              'Subscription is for one time purchase only.\nWe do not renew you subscription automatically.',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: Colors.white, fontStyle: FontStyle.italic
                      // fontWeight: FontWeight.bold,
                      ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                txt: 'Get it',
                onTap: () {

                  if (current.id == 1) {
                    logTheOneMonthSubscriptionClick(Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            listen: false)
                        .profile!);
                  } else {
                    logTheOneYearSubscriptionClick(Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            listen: false)
                        .profile!);
                  }
                  // initiateOrder(current.id, 0);
                  Navigation.instance.navigate('/paymentProcessing',
                      args: '${current.id},0,${current.inapp_identifier}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logTheOneMonthSubscriptionClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "one_month_subscription_intiation",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "screen_name": "subscription",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void logTheOneYearSubscriptionClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "one_year_subscription_intiation",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "screen_name": "subscription",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
