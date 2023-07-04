import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gplusapp/UI/main/sections/poll_of_the_week_section.dart';
import 'package:gplusapp/UI/main/sections/suggested_for_u.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/slider_home.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/DataProvider.dart';
import '../../../Helper/Storage.dart';
import '../../../Model/profile.dart';
import '../../../Navigation/Navigate.dart';
import 'StoriesSection.dart';
import 'VideoReportSection.dart';
import 'ads_section.dart';
import 'bigdeal_ad_section.dart';
import 'gplus_exclusive_section.dart';
import 'opinion_section.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody(
      {Key? key,
      required this.refreshController,
      required this.onRefresh,
      required this.onLoading,
      required this.showExitDialog,
      required this.controller,
      required this.random,
      required this.fetchPoll,
      required this.poll,
      required this.getSpace})
      : super(key: key);
  final RefreshController refreshController;
  final Function onRefresh, onLoading, showExitDialog, fetchPoll, getSpace;
  final ScrollController controller;
  final int random;
  final String poll;

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  bool showing = false;
  int currentScrollPercent = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      var currentScroll = ((widget.controller.position.pixels /
                  widget.controller.position.maxScrollExtent) *
              100)
          .toInt();
      if (currentScroll == 25 ||
          currentScroll == 50 ||
          currentScroll == 75 ||
          currentScroll == 100) {
        if (currentScrollPercent != currentScroll) {
          debugPrint("scrolling $currentScroll");
          currentScrollPercent = currentScroll;
          logTheScrollClick(
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile!,
            "$currentScroll%",
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.h),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(
          waterDropColor: Storage.instance.isDarkMode
              ? Colors.white
              : Constance.primaryColor,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator(
                color: Storage.instance.isDarkMode
                    ? Colors.white
                    : Constance.primaryColor,
              );
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = const Text("No more Data");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: widget.refreshController,
        onRefresh: () => widget.onRefresh(),
        onLoading: () => widget.onLoading(),
        child: Padding(
          padding: EdgeInsets.only(top: 0.h),
          child: Consumer<DataProvider>(builder: (context, data, _) {
            return WillPopScope(
              onWillPop: () async {
                // widget.showExitDialog();
                if (Navigator.of(context).canPop()) {
                  return true;
                } else {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                }
                return false;
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Storage.instance.isDarkMode
                    ? Colors.black
                    : Colors.grey.shade100,
                child: SingleChildScrollView(
                  controller: widget.controller,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      data.home_albums.isNotEmpty
                          ? HomeBannerPage(
                              showNotaMember: () {
                                setState(() {
                                  showing = true;
                                });
                                Constance.showMembershipPrompt(context, () {
                                  setState(() {
                                    showing = false;
                                  });
                                });
                              },
                            )
                          : Container(),
                      data.profile?.is_plan_active ?? false
                          ? Container()
                          : const BigDealsAdSection(),
                      SuggestedForYou(
                        data: data,
                        showNotaMember: () {
                          setState(() {
                            showing = true;
                          });
                          Constance.showMembershipPrompt(context, () {
                            setState(() {
                              showing = false;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      data.ads.isNotEmpty
                          ? AdsSection(data: data, random: widget.random)
                          : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          color: Colors.grey.shade800,
                          thickness: 0.1.h,
                        ),
                      ),
                      GPlusExclusiveSection(
                        data: data,
                        showNotaMember: () {
                          setState(() {
                            showing = true;
                          });
                          Constance.showMembershipPrompt(context, () {
                            setState(() {
                              showing = false;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          color: Colors.grey.shade800,
                          thickness: 0.1.h,
                        ),
                      ),
                      VideoReportSection(
                        data: data,
                        showNotaMember: () {
                          setState(() {
                            showing = true;
                          });
                          Constance.showMembershipPrompt(context, () {
                            setState(() {
                              showing = false;
                            });
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          color: Colors.grey.shade800,
                          thickness: 0.1.h,
                        ),
                      ),
                      PollOfTheWeekSection(
                        data: data,
                        showNotaMember: () {
                          setState(() {
                            showing = true;
                          });
                          Constance.showMembershipPrompt(context, () {
                            setState(() {
                              showing = false;
                            });
                          });
                        },
                        update: () {
                          setState(() {});
                          widget.fetchPoll();
                        },
                        poll: widget.poll,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          color: Colors.grey.shade800,
                          thickness: 0.1.h,
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      StoriesSection(data: data),
                      data.stories.isEmpty
                          ? Container()
                          : SizedBox(
                              height: 1.h,
                            ),
                      data.stories.isEmpty
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Divider(
                                color: Colors.grey.shade800,
                                thickness: 0.1.h,
                              ),
                            ),
                      OpinionSection(
                        data: data,
                        showNotaMember: () {
                          setState(() {
                            showing = true;
                          });
                          Constance.showMembershipPrompt(context, () {
                            setState(() {
                              showing = false;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          Constance.copyright,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    // fontSize: 16.sp,
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      widget.getSpace(),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void logTheScrollClick(
    Profile profile,
    String percentage_scroll,
  ) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "page_scroll",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "percentage_scroll": percentage_scroll,
        "screen_name": "home",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
