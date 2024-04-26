import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:open_settings/open_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:sizer/sizer.dart';

import '../../Components/about_section.dart';
import '../../Components/alert.dart';
import '../../Components/exclusive_section.dart';
import '../../Components/location_section.dart';
import '../../Components/membership_section.dart';
import '../../Components/news_from_section.dart';
import '../../Components/refer_earn_section.dart';
import '../../Components/settings_section.dart';
import '../../Components/social_media_section.dart';
import '../../Helper/Constance.dart';
import '../../Model/profile.dart';

class BergerMenuMemPage extends StatefulWidget {
  const BergerMenuMemPage({Key? key, required this.screen}) : super(key: key);
  final String screen;

  @override
  State<BergerMenuMemPage> createState() => _BergerMenuMemPageState();
}

class _BergerMenuMemPageState extends State<BergerMenuMemPage> {
  ValueNotifier<double>? valueNotifier;
  String? versionCode = "";

  @override
  void initState() {
    super.initState();
    fetchVersion();
    Future.delayed(Duration.zero, () {
      valueNotifier = ValueNotifier(double.parse((Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .profile
                  ?.completed_percent ??
              70)
          .toString()));
      debugPrint(
          "valueNotifier ${double.parse((Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.completed_percent ?? 70).toString())}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return Drawer(
        // width: double.infinity,
        backgroundColor:
            Storage.instance.isDarkMode ? Colors.black : Constance.forthColor,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 2.w, right: 2.w),
            child: ListView(
              children: [
                DrawerHeader(
                  child: SizedBox(
                    height: 12.5.h,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.profile?.f_name ?? 'Jonathan Doe',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 19.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  '+91 ${data.profile?.mobile ?? 'XXXXXXXXXX'}',
                                  style: Theme.of(Navigation.instance
                                          .navigatorKey.currentContext!)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: Colors.white,
                                        // fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(
                                  width: 1.5.w,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (checkIfProfileNeedCreation(
                                    Provider.of<DataProvider>(
                                            Navigation.instance.navigatorKey
                                                    .currentContext ??
                                                context,
                                            listen: false)
                                        .profile)) {
                                  Navigation.instance
                                      .navigate('/updateProfile');

                                } else {
                                  logTheHambergerOptionClick(
                                    Provider.of<DataProvider>(
                                        Navigation.instance.navigatorKey
                                            .currentContext ??
                                            context,
                                        listen: false)
                                        .profile!,
                                    widget.screen,
                                    "view_profile",
                                    "NA",
                                  );
                                  Navigation.instance.navigate('/editProfile');

                                }
                              },
                              child: Text(
                                'View Profile',
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Constance.secondaryColor,
                                      fontSize: 11.sp,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (checkIfProfileNeedCreation(
                                Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                        .currentContext ??
                                        context,
                                    listen: false)
                                    .profile)) {
                              Navigation.instance
                                  .navigate('/updateProfile');

                            } else {
                              logTheHambergerOptionClick(
                                Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                        .currentContext ??
                                        context,
                                    listen: false)
                                    .profile!,
                                widget.screen,
                                "view_profile",
                                "NA",
                              );
                              Navigation.instance.navigate('/editProfile');

                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 15.w,
                                height: 15.w,
                                child: valueNotifier == null
                                    ? Container()
                                    : SimpleCircularProgressBar(
                                        valueNotifier: valueNotifier,
                                        progressStrokeWidth: 1.5.w,
                                        backStrokeWidth: 1.5.w,
                                        onGetText: (double value) {
                                          return Text(
                                            '${value.toInt()}',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Constance.secondaryColor,
                                            ),
                                          );
                                        },
                                        // size: 100,
                                        progressColors: const [
                                          Constance.secondaryColor
                                        ],
                                      ),
                              ),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              valueNotifier?.value==100?Container():Text(
                                "Complete Your Profile",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 7.sp,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const Divider(
                //   color: Colors.white,
                //   thickness: 0.2,
                // ),
                LocationSection(
                  data: data,
                  onTap: () {
                    logTheHambergerOptionClick(
                      Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile!,
                      widget.screen,
                      "location",
                      "NA",
                    );
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                NewsFromSection(
                  onTap: (category, subCategory) {
                    debugPrint(
                        "Screen The ${widget.screen}, $category, $subCategory");
                    logTheHambergerOptionClick(
                      Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile!,
                      widget.screen,
                      category,
                      subCategory,
                    );
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                ExclusiveSection(
                  onTaped: (category, subCategory) {
                    debugPrint(
                        "Screen The ${widget.screen}, $category, $subCategory");
                    logTheHambergerOptionClick(
                      Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile!,
                      widget.screen,
                      category,
                      subCategory,
                    );
                  },
                  screen: widget.screen,
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: GestureDetector(
                    onTap: () {
                      // if (Provider.of<DataProvider>(
                      //             Navigation.instance.navigatorKey
                      //                     .currentContext ??
                      //                 context,
                      //             listen: false)
                      //         .profile
                      //         ?.is_plan_active ??
                      //     false) {
                      //
                      //   // showError("Oops! You are not a member yet");
                      // } else {
                      //   showError("Oops! You are not a member yet");
                      // }
                      logTheHambergerOptionClick(
                        Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile!,
                        widget.screen,
                        "bookmark",
                        "NA",
                      );
                      Navigation.instance.navigate('/bookmarks');
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.bookmark,
                          color: Constance.secondaryColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Bookmarks',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                InkWell(
                  splashColor: Constance.secondaryColor,
                  radius: 15.h,
                  onTap: () {
                    if (Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile
                            ?.is_plan_active ??
                        false) {
                      logTheHambergerOptionClick(
                        Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile!,
                        widget.screen,
                        "e-paper",
                        "NA",
                      );
                      downloadEpaper();
                      // showError("Oops! You are not a member yet");
                    } else {
                      showError("Oops! You are not a member yet");
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0.h),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.download,
                          color: Constance.secondaryColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Download E-Paper',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                MembershipSection(
                    data: data,
                    onTap: () {
                      logTheHambergerOptionClick(
                        Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile!,
                        widget.screen,
                        "membership",
                        "NA",
                      );
                    }),

                (!Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext!)
                        .hideReferEarn)
                    ? SizedBox(
                        height: 0.2.h,
                      )
                    : Container(),
                (!Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext!)
                        .hideReferEarn)
                    ? ReferAndEarnSection(
                        onTap: () {
                          logTheHambergerOptionClick(
                            Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .profile!,
                            widget.screen,
                            "refer&earn",
                            "NA",
                          );
                        },
                      )
                    : Container(),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                aboutSection(
                  onTap: (opt) {
                    logTheHambergerOptionClick(
                      Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile!,
                      widget.screen,
                      opt,
                      "NA",
                    );
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                SocialMediaSection(
                  onTap: (opt, opt2) {
                    logTheHambergerOptionClick(
                      Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile!,
                      widget.screen,
                      opt,
                      opt2,
                    );
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                SettingsSection(
                  onTap: (opt) {
                    logTheHambergerOptionClick(
                      Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile!,
                      widget.screen,
                      opt,
                      "NA",
                    );
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.2,
                ),
                SizedBox(
                  height: 4.h,
                  child: Column(
                    children: [
                      Text(
                        'Version Code: ${versionCode}',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.white,
                              // fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void logTheHambergerOptionClick(
    Profile profile,
    String screen_name,
    String hamburger_category,
    String hamburger_subcategory,
  ) async {
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    await FirebaseAnalytics.instance.logEvent(
      name: "hamburger_option_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "hamburger_category": hamburger_category,
        "hamburger_subcategory": hamburger_subcategory,
        "screen_name": screen_name,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void downloadEpaper() async {
    showLoaderDialog(context);
    final response = await ApiProvider.instance.getEpaper();
    if (response.success ?? false) {
      var status = await Permission.storage.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        debugPrint("First case");
        // try {
        //   if (await Permission.storage.request().isGranted) {
        //     debugPrint("Third case");
        //   } else {
        //     debugPrint("Fourth case ${await Permission.storage.request().isGranted}");
        //     Navigation.instance.goBack();
        //     showErrorStorage("We require storage permissions");
        //   }
        // } catch (e) {
        //   debugPrint("Fifth case");
        //   print(e);
        //   Navigation.instance.goBack();
        //   showErrorStorage("We require storage permissions");
        // }
        await ApiProvider.instance.download2(
            response.e_paper?.news_pdf ?? "", response.e_paper?.title ?? "");
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      } else {
        debugPrint("Second case");
        await ApiProvider.instance.download2(
            response.e_paper?.news_pdf ?? "", response.e_paper?.title ?? "");
      }
    } else {
      showError("Failed to download E-paper");
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        color: Colors.white,
        child: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(
                "Loading...",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Not Subscribed",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }

  void showErrorStorage(String msg) {
    AlertX.instance.showAlert(
      title: msg,
      msg: "Please Go To Settings and Provide the Storage Permission",
      negativeButtonText: "Close",
      negativeButtonPressed: () {
        Navigation.instance.goBack();
      },
      positiveButtonText: "Go to Settings",
      positiveButtonPressed: () async {
        Navigation.instance.goBack();
        await OpenSettings.openAppSetting();
      },
    );
  }

  Future<void> _launchSocialMediaAppIfInstalled({
    required String url,
  }) async {}

  void fetchVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionCode = "${packageInfo.version}";
    });
  }

  bool checkIfProfileNeedCreation(Profile? profile) {
    if (profile == null) return true;
    if (profile.f_name=="") return true;
    if (profile.l_name=="") return true;
    if (profile.email=="") return true;
    if (profile.addresses==[]) return true;
    return false;
  }
}
