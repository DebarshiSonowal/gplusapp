import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';

class ShowMembershipPage extends StatelessWidget {
  const ShowMembershipPage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.95),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 1.h, right: 5.w, left: 5.w, bottom: 1.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 85.w,
                // height: 50.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigation.instance.goBack();
                            Navigation.instance.goBack();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Text(
                      'Oops!',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: Constance.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 34.sp,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      'Hello $name,',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      "Become a subscriber and unlock this premium article. Offering 100+ premium reads every month with GPlus App Subscription.",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Do you want to be a member?',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: CustomButton(
                            txt: 'Yes, take me there',
                            onTap: () {
                              logTheSubscriptionInitiationClick(
                                  Provider.of<DataProvider>(
                                          Navigation.instance.navigatorKey
                                                  .currentContext ??
                                              context,
                                          listen: false)
                                      .profile!);
                              Navigation.instance.navigate('/beamember');
                            },
                            size: 10.sp,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Flexible(
                          child: CustomButton(
                            txt: '''No, I don't want it''',
                            onTap: () {
                              logTheSubscriptionInitiationCancelClick(
                                  Provider.of<DataProvider>(
                                          Navigation.instance.navigatorKey
                                                  .currentContext ??
                                              context,
                                          listen: false)
                                      .profile!);
                              Navigation.instance.goBack();
                              Navigation.instance.goBack();
                            },
                            color: Colors.black,
                            size: 10.sp,
                            fcolor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logTheSubscriptionInitiationClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "subscription_intiation",
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

  void logTheSubscriptionInitiationCancelClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "subscription_declined",
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
