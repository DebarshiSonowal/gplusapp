import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
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
                    child: Column(
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
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
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
      if (status.isDenied) {
        try {
          if (await Permission.storage.request().isGranted) {
            await ApiProvider.instance.download2(
                response.e_paper?.news_pdf ?? "",
                response.e_paper?.title ?? "");
          } else {
            Navigation.instance.goBack();
            showErrorStorage("We require storage permissions",);
          }
        } catch (e) {
          print(e);
          Navigation.instance.goBack();
          showErrorStorage("We require storage permissions");
        }
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      } else {
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
}
