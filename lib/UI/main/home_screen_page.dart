import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/opinion.dart';
import 'package:gplusapp/Model/top_picks.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/gplus_execl_card.dart';
import '../../Components/opinion_card.dart';
import '../../Components/toppicks_card.dart';
import '../../Components/video_card.dart';
import '../../Components/slider_home.dart';
import '../../Helper/Constance.dart';
import '../../Model/listing.dart';
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
  String _poll = Constance.pollWeek[0];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool showing = false;

  final _listController = PageController(keepPage: true, viewportFraction: 0.8);

  @override
  void dispose() {
    super.dispose();
    _listController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // secureScreen();
    Future.delayed(Duration.zero, () => fetchProfile());

    fetchHome();
    fetchOpinion();
    fetchGPlusExcl();
    fetchPoll();
    fetchToppicks();
    fetchAds();
    askPermissions();
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
    return Scaffold(
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.grey.shade100,
      appBar: buildAppBar(),
      floatingActionButtonLocation: showing
          ? FloatingActionButtonLocation.miniStartFloat
          : FloatingActionButtonLocation.miniEndFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _launchUrl(
              Uri.parse('whatsapp://send?phone=919365974702&text=Hi+G+Plus!'));
        },
        child: Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 22.sp,
        ),
      ),
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
    );
  }

  Padding HomeScreenBody() {
    return Padding(
      padding: EdgeInsets.only(top: 0.1.h),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
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
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Padding(
          padding: EdgeInsets.only(top: 0.3.h),
          child: Consumer<DataProvider>(builder: (context, data, _) {
            return data.ads.isEmpty
                ? Container()
                : WillPopScope(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            HomeBannerPage(),
                            data.profile?.is_plan_active ?? false
                                ? Container()
                                : Container(
                                    width: double.infinity,
                                    height: 20.h,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.h, horizontal: 8.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigation.instance
                                            .navigate('/bigdealpage');
                                        Provider.of<DataProvider>(
                                                Navigation.instance.navigatorKey
                                                        .currentContext ??
                                                    context,
                                                listen: false)
                                            .setCurrent(1);
                                      },
                                      child: Card(
                                        color: Constance.thirdColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 0.5.h),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    'Big Deals\nand Offers',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3
                                                        ?.copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        Constance.kfc_offer,
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
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              height: 25.h,
                              width: double.infinity,
                              color: Constance.secondaryColor,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Text(
                                      'Suggested for you',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: data.home_toppicks.length > 4
                                            ? 4
                                            : data.home_toppicks.length + 1,
                                        itemBuilder: (cont, count) {
                                          var item = data.home_toppicks[count];
                                          if ((data.home_toppicks.length > 4
                                                  ? 3
                                                  : data.home_toppicks.length -
                                                      1) ==
                                              count) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1.w,
                                                  vertical: 1.5.h),
                                              // height: 5.h,
                                              // width: 20.w,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigation.instance
                                                      .navigate('/toppicks');
                                                },
                                                child: Text(
                                                  'View All',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3
                                                      ?.copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10.sp,
                                                      ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return GestureDetector(
                                              onTap: () {
                                                if (data.profile
                                                        ?.is_plan_active ??
                                                    false) {
                                                  Navigation.instance.navigate(
                                                      '/story',
                                                      args:
                                                          '${item.categories?.first.seo_name},${item.seo_name}');
                                                } else {
                                                  setState(() {
                                                    showing = true;
                                                  });
                                                  Constance
                                                      .showMembershipPrompt(
                                                          context, () {
                                                    setState(() {
                                                      showing = false;
                                                    });
                                                  });
                                                }
                                              },
                                              child: ToppicksCard(item: item),
                                            );
                                          }
                                        },
                                        separatorBuilder: (cont, inde) {
                                          return SizedBox(
                                            width: 10.w,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        color: Constance.secondaryColor,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.2.h, horizontal: 1.w),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: Text(
                                          'Ad',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              ?.copyWith(
                                                fontSize: 12.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
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
                                        _launchUrl(Uri.parse(
                                            data.ads[random].link.toString()));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.w,
                                            right: 5.w,
                                            bottom: 0.5.h),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fitWidth,
                                          imageUrl: data.ads[random]
                                                  .image_file_name ??
                                              '',
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
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Divider(
                                color: Colors.grey.shade800,
                                thickness: 0.1.h,
                              ),
                            ),
                            // SizedBox(
                            //   height: 1.h,
                            // ),
                            Container(
                              height: 30.h,
                              width: double.infinity,
                              // color: Constance.secondaryColor,
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Text(
                                      'G Plus Exclusive',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            fontSize: 16.sp,
                                            color: Storage.instance.isDarkMode
                                                ? Colors.white
                                                : Constance.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (cont, count) {
                                            var item =
                                                data.home_exclusive[count];
                                            return GestureDetector(
                                              onTap: () {
                                                if (data.profile
                                                        ?.is_plan_active ??
                                                    false) {
                                                  Navigation.instance.navigate(
                                                      '/story',
                                                      args:
                                                          '${'exclusive-news'},${item.seo_name}');
                                                } else {
                                                  setState(() {
                                                    showing = true;
                                                  });
                                                  Constance
                                                      .showMembershipPrompt(
                                                          context, () {
                                                    setState(() {
                                                      showing = false;
                                                    });
                                                  });
                                                }
                                              },
                                              child: GPlusExecCard(item: item),
                                            );
                                          },
                                          separatorBuilder: (cont, inde) {
                                            return SizedBox(
                                              width: 10.w,
                                            );
                                          },
                                          itemCount:
                                              (data.home_exclusive.length > 3
                                                  ? 3
                                                  : data
                                                      .home_exclusive.length)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (data.profile?.is_plan_active ??
                                          false) {
                                        Navigation.instance
                                            .navigate('/exclusivePage');
                                      } else {
                                        setState(() {
                                          showing = true;
                                        });
                                        Constance.showMembershipPrompt(context,
                                            () {
                                          setState(() {
                                            showing = false;
                                          });
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Text(
                                        'Read More',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Storage.instance.isDarkMode
                                                  ? Colors.white
                                                  : Constance.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                            // SizedBox(
                            //   height: 0.5.h,
                            // ),
                            Container(
                              // height: 35.h,
                              width: double.infinity,
                              // color: Constance.secondaryColor,
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Text(
                                      'Video reports',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            fontSize: 16.sp,
                                            color: Storage.instance.isDarkMode
                                                ? Colors.white
                                                : Constance.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                    width: double.infinity,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (cont, count) {
                                          var item = data.home_weekly[count];
                                          return GestureDetector(
                                              onTap: () {
                                                if (data.profile
                                                        ?.is_plan_active ??
                                                    false) {
                                                  Navigation.instance.navigate(
                                                      '/videoPlayer',
                                                      args: item.youtube_id);
                                                } else {
                                                  setState(() {
                                                    showing = true;
                                                  });
                                                  Constance
                                                      .showMembershipPrompt(
                                                          context, () {
                                                    setState(() {
                                                      showing = false;
                                                    });
                                                  });
                                                }
                                              },
                                              child: VideoCard(item: item));
                                        },
                                        separatorBuilder: (cont, inde) {
                                          return SizedBox(
                                            width: 10.w,
                                          );
                                        },
                                        itemCount: data.home_weekly.length > 3
                                            ? 3
                                            : data.home_weekly.length),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (data.profile?.is_plan_active ??
                                          false) {
                                        Navigation.instance
                                            .navigate('/videoReport');
                                      } else {
                                        setState(() {
                                          showing = true;
                                        });
                                        Constance.showMembershipPrompt(context,
                                            () {
                                          setState(() {
                                            showing = false;
                                          });
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Text(
                                        'View All',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Storage.instance.isDarkMode
                                                  ? Colors.white
                                                  : Constance.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 1.h,
                                  // ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Divider(
                                color: Colors.grey.shade800,
                                thickness: 0.1.h,
                              ),
                            ),
                            Container(
                              // height: 35.h,
                              width: double.infinity,
                              // color: Constance.secondaryColor,
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Poll of the week',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              ?.copyWith(
                                                fontSize: 16.sp,
                                                color: Storage
                                                        .instance.isDarkMode
                                                    ? Colors.white
                                                    : Constance.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.share,
                                            color: Storage.instance.isDarkMode
                                                ? Colors.white
                                                : Constance.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Text(
                                      data.pollOfTheWeek?.title ??
                                          'Poll of the week',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            fontSize: 13.sp,
                                            color: Storage.instance.isDarkMode
                                                ? Colors.white
                                                : Constance.primaryColor,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (cont, count) {
                                          var item = data.pollOfTheWeek;
                                          // var value =
                                          //     Constance.pollValue[count];
                                          return Stack(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 1.h),
                                                child: LinearPercentIndicator(
                                                  barRadius:
                                                      const Radius.circular(5),
                                                  width: 80.w,
                                                  lineHeight: 5.h,
                                                  percent: data.pollOfTheWeek
                                                              ?.is_polled ==
                                                          'false'
                                                      ? 0
                                                      : (getOption(
                                                              count, data) /
                                                          100),
                                                  center: const Text(
                                                    "",
                                                    style: TextStyle(
                                                        fontSize: 12.0),
                                                  ),
                                                  // trailing: Icon(Icons.mood),
                                                  linearStrokeCap:
                                                      LinearStrokeCap.roundAll,
                                                  backgroundColor: Colors.white,
                                                  progressColor:
                                                      Constance.secondaryColor,
                                                ),
                                              ),
                                              Theme(
                                                data: ThemeData(
                                                  unselectedWidgetColor:
                                                      Colors.grey.shade900,
                                                  backgroundColor:
                                                      Colors.grey.shade200,
                                                ),
                                                child: RadioListTile(
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  selected: _poll ==
                                                          getOptionName(
                                                              count, data)
                                                      ? true
                                                      : false,
                                                  tileColor:
                                                      Colors.grey.shade300,
                                                  selectedTileColor:
                                                      Colors.black,
                                                  value: getOptionName(
                                                      count, data),
                                                  activeColor: Colors.black,
                                                  groupValue: _poll,
                                                  onChanged: (val) {
                                                    if (data.profile
                                                            ?.is_plan_active ??
                                                        false) {
                                                      setState(() {
                                                        _poll = getOptionName(
                                                            count, data);
                                                      });
                                                      postPollOfTheWeek(
                                                          data.pollOfTheWeek
                                                              ?.id,
                                                          _poll);
                                                    } else {
                                                      setState(() {
                                                        showing = true;
                                                      });
                                                      Constance
                                                          .showMembershipPrompt(
                                                              context, () {
                                                        setState(() {
                                                          showing = false;
                                                        });
                                                      });
                                                    }
                                                  },
                                                  title: Text(
                                                    getOptionName(count, data),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  secondary: Text(
                                                    item?.is_polled == 'false'
                                                        ? ''
                                                        : '${getOption(count, data)}%',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                            color: Storage
                                                                    .instance
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 1.7.h
                                                            // fontWeight: FontWeight.bold,
                                                            ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (cont, inde) {
                                          return SizedBox(
                                            width: 10.w,
                                          );
                                        },
                                        itemCount: 3),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigation.instance.navigate('/pollPage');
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Text(
                                        'View All',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Storage.instance.isDarkMode
                                                  ? Colors.white
                                                  : Constance.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                ],
                              ),
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
                            SizedBox(
                              width: double.infinity,
                              height: 40.h,
                              child: PageView.builder(
                                  controller: _listController,
                                  // shrinkWrap: true,
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentPage = index;
                                    });
                                  },
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.home_albums.length,
                                  itemBuilder: (cont, index) {
                                    var current = data.home_albums[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigation.instance.navigate(
                                            '/storyviewPage',
                                            args: index);
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                        width: 70.w,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    current.image_file_name ??
                                                        "",
                                                width: double.infinity,
                                                // height:55.h,
                                                height: 40.h,
                                                fit: BoxFit.fill,
                                                // filterQuality: FilterQuality.low,
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
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black
                                                    ]),
                                              ),
                                              // color: Colors.black.withOpacity(0.5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3.h,
                                                  horizontal: 2.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    current.title ??
                                                        'Big Deals\nand Offers',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4
                                                        ?.copyWith(
                                                            color: Colors
                                                                .grey.shade200,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  ),
                                                  Text(
                                                    "${current.author_name?.trim()}, ${Jiffy(current.publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            data.home_albums.isNotEmpty
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0;
                                          i < data.home_albums.length;
                                          i++)
                                        Container(
                                          width: 2.w,
                                          height: 2.h,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: i == currentPage
                                                ? Constance.secondaryColor
                                                : Colors.grey.shade800,
                                          ),
                                        ),
                                    ],
                                  )
                                : Container(),
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
                            Container(
                              // height: 27.h,
                              width: double.infinity,
                              // color: Constance.secondaryColor,
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Text(
                                      'Opinion',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          ?.copyWith(
                                            fontSize: 16.sp,
                                            color: Storage.instance.isDarkMode
                                                ? Colors.white
                                                : Constance.fifthColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 7.w),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (cont, count) {
                                        var item = data.latestOpinions[count];
                                        return GestureDetector(
                                            onTap: () {
                                              if (data.profile
                                                      ?.is_plan_active ??
                                                  false) {
                                                Navigation.instance.navigate(
                                                    '/opinionDetails',
                                                    args:
                                                        item.seo_name?.trim());
                                              } else {
                                                setState(() {
                                                  showing = true;
                                                });
                                                Constance.showMembershipPrompt(
                                                    context, () {
                                                  setState(() {
                                                    showing = false;
                                                  });
                                                });
                                              }
                                            },
                                            child: OpinionCard(item: item));
                                      },
                                      separatorBuilder: (cont, inde) {
                                        return SizedBox(
                                          width: 10.w,
                                        );
                                      },
                                      itemCount: (data.latestOpinions.length > 3
                                              ? data.latestOpinions.length /
                                                  3.toInt()
                                              : data.latestOpinions.length)
                                          .toInt(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (data.profile?.is_plan_active ??
                                          false) {
                                        Navigation.instance
                                            .navigate('/opinionPage');
                                      } else {
                                        setState(() {
                                          showing = true;
                                        });
                                        Constance.showMembershipPrompt(context,
                                            () {
                                          setState(() {
                                            showing = false;
                                          });
                                        });
                                      }

                                      // Navigation.instance
                                      //     .navigate('/authorPage', args: 1);
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Text(
                                        'Read More',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Storage.instance.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            ),
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

  AppBar buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
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
            Navigation.instance.navigate('/notification');
          },
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search');
          },
          icon: Icon(Icons.search),
        ),
      ],
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
    final response = await ApiProvider.instance.getTopPicks();
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
      } else {
        // showError("We require storage permissions");
      }
    }
  }

  getOption(int count, data) {
    switch (count) {
      case 0:
        return data.pollOfTheWeek?.percent1;
      case 1:
        return data.pollOfTheWeek?.percent2;
      case 2:
        return data.pollOfTheWeek?.percent3;
      default:
        return data.pollOfTheWeek?.option1;
    }
  }

  String getOptionName(int count, data) {
    switch (count) {
      case 0:
        return data.pollOfTheWeek?.option1 ?? "";
      case 1:
        return data.pollOfTheWeek?.option2 ?? "";
      case 2:
        return data.pollOfTheWeek?.option3 ?? "";
      default:
        return data.pollOfTheWeek?.option1 ?? "";
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

  void postPollOfTheWeek(int? id, String poll) async {
    final response = await ApiProvider.instance.postPollOfTheWeek(id, poll);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Posted successfully");
      fetchPoll();
      setState(() {});
    } else {}
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
}
