import 'dart:math';
import 'dart:io' show Platform;
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:gplusapp/UI/main/sections/StoriesSection.dart';
import 'package:gplusapp/UI/main/sections/VideoReportSection.dart';
import 'package:gplusapp/UI/main/sections/bigdeal_ad_section.dart';
import 'package:gplusapp/UI/main/sections/gplus_exclusive_section.dart';
import 'package:gplusapp/UI/main/sections/opinion_section.dart';
import 'package:gplusapp/UI/main/sections/poll_of_the_week_section.dart';
import 'package:gplusapp/UI/main/sections/suggested_for_u.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/slider_home.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0, currentPage = 0;
  int random = 0;
  final ScrollController controller = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool showing = false;

  // final _listController = PageController(keepPage: true, viewportFraction: 0.8);

  String _poll = Constance.pollWeek[0];

  @override
  void dispose() {
    super.dispose();
    // _listController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // secureScreen();
    Future.delayed(Duration.zero, () => fetchProfile());
    fetchStories();
    fetchHome();
    fetchOpinion();
    fetchGPlusExcl();
    fetchPoll();
    fetchToppicks();
    fetchAds();
    askPermissions();
    fetchNotification();
    fetchReportMsg();
    fetchRedeemMsg();
    // Future.delayed(
    //     const Duration(seconds: 15),
    //         () => _listController.addListener(() {
    //       setState(() {});
    //     }));
    Future.delayed(
        Duration.zero,
        () => Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setCurrent(0));
    showPopUp();
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          _refreshController.requestRefresh();
        } else {
          // print('At the bottom');
        }
      }
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    fetchPoll();
    fetchOpinion();
    fetchGPlusExcl();
    fetchToppicks();
    fetchAds();
    final result = await ApiProvider.instance.getHomeAlbum();
    if (result.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeAlbum(result.articles ?? []);

      final response = await ApiProvider.instance.getWeekly();
      if (response.success ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setVideoWeekly(response.videos ?? []);
        _refreshController.refreshCompleted();
      }
    } else {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
          dialogStyle: Platform.isAndroid
              ? UpgradeDialogStyle.material
              : UpgradeDialogStyle.cupertino),
      child: Scaffold(
        backgroundColor:
            Storage.instance.isDarkMode ? Colors.black : Colors.grey.shade100,
        appBar: Constance.buildAppBar(),
        // floatingActionButtonLocation: showing
        //     ? FloatingActionButtonLocation.miniStartFloat
        //     : FloatingActionButtonLocation.miniEndFloat,
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.green,
        //   onPressed: () {
        //     _launchUrl(
        //         Uri.parse('whatsapp://send?phone=919365974702&text=Hi+G+Plus!'));
        //   },
        //   child: Icon(
        //     FontAwesomeIcons.whatsapp,
        //     color: Colors.white,
        //     size: 22.sp,
        //   ),
        // ),
        drawer: BergerMenuMemPage(),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return connected
                ? HomeScreenBody()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'Oops! You are not connected to Internet',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                ?.copyWith(
                                    color: Constance.thirdColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
          },
          child: Container(),
        ),
        bottomNavigationBar: CustomNavigationBar(current),
      ),
    );
  }

  Padding HomeScreenBody() {
    return Padding(
      padding: EdgeInsets.only(top: 0.h),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
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
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Padding(
          padding: EdgeInsets.only(top: 0.h),
          child: Consumer<DataProvider>(builder: (context, data, _) {
            return WillPopScope(
              onWillPop: () async {
                showExitDialog();
                return false;
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Storage.instance.isDarkMode
                    ? Colors.black
                    : Colors.grey.shade100,
                child: SingleChildScrollView(
                  controller: controller,
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
                          ? AdsSection(context, data)
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
                          fetchPoll();
                        },
                        poll: _poll,
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
                          'This material may not be published, broadcast, rewritten, or redistributed, 2022 © G Plus. All rights reserved. Copyright © 2022 Insight Brandcom Pvt. Ltd. All rights reserved.',
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
                      getSpace(),
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

  Container AdsSection(BuildContext context, DataProvider data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: Constance.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 1.w),
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  'Ad',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontSize: 7.sp,
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 1.h,
          // ),
          SizedBox(
            // height: 8.5.h,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                _launchUrl(Uri.parse(data.ads[random].link.toString()));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 0.9.h),
                child: CachedNetworkImage(
                  height: 6.h,
                  fit: BoxFit.fill,
                  imageUrl: data.ads[random].image_file_name ?? '',
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchOpinion() async {
    final response = await ApiProvider.instance.getLatestOpinion();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLatestOpinions(response.opinion ?? []);
    }
  }

  void fetchToppicks() async {
    final response = await ApiProvider.instance.getTopPicks(1);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeTopPicks(response.toppicks ?? []);
    }
  }

  void fetchGPlusExcl() async {
    final response = await ApiProvider.instance.getArticle('exclusive-news');
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeExecl(response.articles ?? []);
    }
  }

  void fetchPoll() async {
    final response = await ApiProvider.instance.getPollOfTheWeek();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setPollOfTheWeek(response.pollOfTheWeek!);
      if (response.pollOfTheWeek?.is_polled != 'false') {
        setState(() {
          _poll = response.pollOfTheWeek?.is_polled ?? "";
        });
      }
    }
  }

  void fetchAds() async {
    final response = await ApiProvider.instance.getAdvertise();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAds(response.ads ?? []);
      random = Random().nextInt(response.ads?.length ?? 0);
    }
  }

  void fetchHome() async {
    final result = await ApiProvider.instance.getHomeAlbum();
    if (result.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeAlbum(result.articles ?? []);

      final response = await ApiProvider.instance.getWeekly();
      if (response.success ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setVideoWeekly(response.videos ?? []);
        // _refreshController.refreshCompleted();
      }
    } else {
      // _refreshController.refreshFailed();
    }
  }

  Future<void> _launchUrl(_url) async {
    if (await canLaunchUrl(_url)) {
      launchUrl(_url);
    } else {
      launchUrl(
        Uri.parse('https://api.whatsapp.com/send?phone=919365974702'),
      );
    }
  }

  void askPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        debugPrint("We got location permissions");
      } else {
        debugPrint("We require location permissions");
      }
    } else {
      debugPrint("We got location permissions already");
    }
  }

  void fetchProfile() async {
    print('object profile');
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getprofile();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      print('object profile');
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(response.profile!);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyTopicks(response.topicks);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGeoTopicks(response.geoTopicks);
    } else {
      // Navigation.instance.goBack();
    }
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Oops! You are not a member',
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Constance.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.name}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Flexible(
                  child: Text(
                    '''Projected to be a smart city by 2025, Guwahati is a
major port on the banks of Brahmaputra, the capital
of Assam and the urban hub of the North East. This
metropolitan city is growing leaps and bounds, and 
for its unparalleled pace of growth, comes the need
for an unparalleled publication, that people call their''',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(height: 1.h),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      txt: 'Yes, take me there',
                      onTap: () {
                        Navigation.instance.navigate('/beamember');
                      },
                      size: 12.sp,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    CustomButton(
                      txt: '''No, I don't want it''',
                      onTap: () {
                        Navigation.instance.goBack();
                      },
                      color: Colors.black,
                      size: 12.sp,
                      fcolor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPopUp() {
    double doubleInRange(Random source, num start, num end) =>
        source.nextDouble() * (end - start) + start;
    Future.delayed(
        Duration(milliseconds: doubleInRange(Random(), 10000, 20000).toInt()),
        () {
      // code will be here
      if (Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .profile
              ?.is_plan_active ??
          false) {
      } else {
        showDialogBox();
      }
    });
    // Future.delayed(Duration(seconds: 5), () => showDialogBox());
  }

  void showExitDialog() {
    Dialogs.materialDialog(
        msg: 'Are you sure ? you want to exit',
        title: "Exit",
        color: Colors.white,
        context: context,
        titleStyle: Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.black,
            ),
        msgStyle: Theme.of(context).textTheme.headline5!.copyWith(
              color: Colors.black,
            ),
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigation.instance.goBack();
            },
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            text: 'Exit',
            iconData: Icons.exit_to_app,
            color: Constance.thirdColor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void fetchStories() async {
    final response = await ApiProvider.instance.getStories();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setStories(response.stories);
    }
  }

  getSpace() {
    if (Platform.isAndroid) {
      return SizedBox(
        height: 18.5.h,
      );
    } else if (Platform.isIOS) {
      return SizedBox(
        height: 30.h,
      );
    }
  }

  void fetchReportMsg() async {
    final response = await ApiProvider.instance.getReportMsg();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setReportModel(response.reports);
    } else {}
  }

  void fetchRedeemMsg() async {
    final response = await ApiProvider.instance.getReferEarnText();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setReferEarnText(response.desc ?? "");
    } else {}
    final response1 = await ApiProvider.instance.getRedeemText();
    if (response1.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setRedeemText(response1.desc ?? "");
    } else {}
  }
}

void fetchNotification() async {
  final response = await ApiProvider.instance.getNotifications();
  if (response.success ?? false) {
    Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext!,
            listen: false)
        .setNotificationInDevice(response.notification);
  } else {}
}
