import 'dart:io';

import 'package:badges/badges.dart' as bd;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/bigdeal.dart';
import 'package:gplusapp/Model/category_discount.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Model/big_discount.dart';
import '../Model/category.dart';
import '../Model/connect_post.dart';
import '../Model/listing.dart';
import '../Model/notification.dart';
import '../Model/profile.dart';
import '../Navigation/Navigate.dart';

class Constance {
  static const primaryColor = Color(0xff0B4368);
  static const secondaryColor = Color(0xffFCBD14);
  static const thirdColor = Color(0xffD03830);
  static const forthColor = Color(0xff001f34);
  static const fifthColor = Color(0xff1d1d1d);
  static const logoIcon = 'assets/images/logo.png';
  static const noDataLoader = 'assets/animation/no_data.json';
  static const homeIcon = 'assets/images/home.png';
  static const newsIcon = 'assets/images/news.png';
  static const warningIcon = 'assets/images/warning.png';
  static const disclaimerIcon = 'assets/images/danger.png';
  static const connectIcon = 'assets/images/connect.png';
  static const classifiedIcon = 'assets/images/classifieds.png';
  static const entertainmentIcon = 'assets/images/entertainment.png';
  static const authorIcon = 'assets/images/author.png';
  static const exclusiveIcon = 'assets/images/exclusive.png';
  static const bigDealIcon = 'assets/images/big_deal.png';
  static const citizenIcon = 'assets/images/citizen_journalist.png';
  static const linkIcon = 'assets/images/link.png';
  static const searchingIcon = 'assets/animation/searching.json';
  static const paymentIcon = 'assets/animation/payment.json';
  static const defaultImage =
      'http://gplus.shecure.co.in/public/web/images/logo.png';

  static const defaultFullAd =
      "https://images.unsplash.com/photo-1553096442-8fe2118fb927?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80";

  static final googleApiKey = FlutterConfig.get('androidMapKey');

  // static const googleApiKey = "AIzaSyAOniov-vDxU0pIg--OvkCeEsN7iK2Eozo";
  static final googleApiKeyIos = FlutterConfig.get('iosMapKey');

  // static const googleApiKeyIos = "AIzaSyAOniov-vDxU0pIg--OvkCeEsN7iK2Eozo";

  static var geo = [
    'Guwahati',
    'Assam',
    'Northeast',
    'India',
    'International',
    'Sports'
  ];
  static var topical = [
    'Bollywood',
    'Politics',
    'Education',
    'Sports',
    'Ipsum',
    'Lorem',
  ];

  static String copyright =
      'This material may not be published, broadcast, rewritten, or redistributed, ${DateTime.now().year} © G Plus. All rights reserved. Copyright © ${DateTime.now().year} Insight Brandcom Pvt. Ltd. All rights reserved.';

  static Widget androidWarning = Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 4.w,
    ),
    child: Platform.isAndroid? const Text(
      "For users with Android 12 & above, we recommend that you upload the media from the Gallery to avoid any crashes",
      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 8),
    ):Container(),
  );

  static AppBar buildAppBar(
      String screen, bool enable, GlobalKey<ScaffoldState> key) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          // Navigation.instance.navigate('/bergerMenuMem');
          if (enable) {
            logTheTopNavigationClick(
              Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext!,
                      listen: false)
                  .profile!,
              screen,
              "hamburger_icon_click",
            );
            try {
              key.currentState!.openDrawer();
            } catch (e) {
              print(e);
            }
          }
        },
        icon: const Icon(Icons.menu),
      ),
      title: GestureDetector(
        onTap: () {
          if (enable) {
            logTheLogoClick(
                Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext!,
                        listen: false)
                    .profile!,
                screen);
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext!,
                    listen: false)
                .setCurrent(0);
            Navigation.instance.navigate('/main');
          }
        },
        child: Image.asset(
          Constance.logoIcon,
          fit: BoxFit.fill,
          scale: 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            logTheTopNavigationClick(
              Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext!,
                      listen: false)
                  .profile!,
              screen,
              "notification_icon_click",
            );
            Navigation.instance.navigate('/notification');
          },
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return data.notifications.isNotEmpty
                ? bd.Badge(
                    // badgeColor: Constance.secondaryColor,
                    badgeContent: Text(
                      '${data.notifications.length}',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white, fontSize: 8.sp),
                    ),
                    child: const Icon(Icons.notifications),
                  )
                : const Icon(Icons.notifications);
          }),
        ),
        IconButton(
          onPressed: () {
            logTheSearchInitiationClick(
              Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext!,
                      listen: false)
                  .profile!,
              screen,
            );
            Navigation.instance.navigate('/search', args: "");
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  static AppBar buildAppBar2(String screen) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          logTheLogoClick(
              Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext!,
                      listen: false)
                  .profile!,
              screen);
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: false)
              .setCurrent(0);
          Navigation.instance.navigate('/main');
        },
        child: Image.asset(
          Constance.logoIcon,
          fit: BoxFit.fill,
          scale: 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            logTheTopNavigationClick(
              Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext!,
                      listen: false)
                  .profile!,
              screen,
              "notification_icon_click",
            );
            Navigation.instance.navigate('/notification');
          },
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return bd.Badge(
              // badgeColor: Constance.secondaryColor,
              badgeContent: Text(
                '${data.notifications.length}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.white,
                      fontSize: 8.sp,
                    ),
              ),
              child: const Icon(Icons.notifications),
            );
          }),
        ),
        IconButton(
          onPressed: () {
            logTheSearchInitiationClick(
              Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext!,
                      listen: false)
                  .profile!,
              screen,
            );
            Navigation.instance.navigate('/search', args: "");
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  static void logTheLogoClick(Profile profile, String screen) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "logo_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "screen_name": screen,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  static void logTheTopNavigationClick(
    Profile profile,
    String screen_name,
    String cta_click,
  ) async {
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    await FirebaseAnalytics.instance.logEvent(
      name: "top_navigation_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "cta_click": cta_click,
        "screen_name": screen_name,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  static void logTheSearchInitiationClick(
    Profile profile,
    String screen_name,
    // String cta_click,
  ) async {
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    await FirebaseAnalytics.instance.logEvent(
      name: "search_initiation_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "cta_click": cta_click,
        "screen_name": screen_name,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  static final terms =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s'
      ' standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
      ' It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the '
      '1960s with the release of Letraset sheets containing Lorem Ipsum passages. Contrary to popular belief, Lorem Ipsum is not simply random text. It has '
      'roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia,'
      ' looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the'
      ' undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. '
      'This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.';

  static const kfc_offer =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStcrxmNo-nV0Cgn9kMmOo72XfiRxHC69EYgA&usqp=CAU';

  static final categoryList = [];
  static const salonImage =
      'https://images.pexels.com/photos/705255/pexels-photo-705255.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2';

  static final pollWeek = ['Roger Federer', 'Rafael Nadal', 'Novak Djokovic'];
  static final pollValue = [60, 25, 15];

  static List<File> attachements = [];

  static List<Listing> listings = [];

  static List<ConnectPost> connects = [];
  static var notifications = [];

  static const String about = '''
Why don't you become a subscriber?
One of the leading digital news network of Guwahati,
 G Plus is here for you. Stay on top of the current news and 
 affairs going in and around the city and get access to other exclusive 
 content by becoming a subscriber. We promise to keep you informed!.
              ''';

  final String privacy_policy = '''
 
  ''';

  static void logTheSubscriptionInitiationClick(Profile profile) async {
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

  static void logTheSubscriptionInitiationCancelClick(Profile profile) async {
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

  static showMembershipPrompt(context, function) {
    try {
      showBottomSheet<void>(
          context: context,
          backgroundColor: Colors.grey.shade100,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
          builder: (context) {
            return Consumer<DataProvider>(builder: (context, data, _) {
              return StatefulBuilder(builder: (context, _) {
                return Container(
                  padding: EdgeInsets.only(
                      top: 1.h, right: 5.w, left: 5.w, bottom: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  width: double.infinity,
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
                        'Sorry ${data.profile?.name}',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        data.paywall,
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
                              size: 12.sp,
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
                              },
                              color: Colors.black,
                              size: 12.sp,
                              fcolor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
            });
          }).closed.whenComplete(() {
        //do whatever you want after closing the bottom sheet
        function();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static showMembershipPrompt2(ScaffoldState state) {
    state.showBottomSheet(
      (context) {
        return Consumer<DataProvider>(builder: (context, data, _) {
          return StatefulBuilder(builder: (context, _) {
            return Container(
              padding:
                  EdgeInsets.only(top: 1.h, right: 5.w, left: 5.w, bottom: 1.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              width: double.infinity,
              // height: 50.h,
              child: SingleChildScrollView(
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
                      'Sorry ${data.profile?.name}',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      data.paywall,
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
                            size: 12.sp,
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
                            },
                            color: Colors.black,
                            size: 12.sp,
                            fcolor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
      },
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
    );
  }



}
