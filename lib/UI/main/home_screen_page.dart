import 'dart:async';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:gplusapp/UI/main/sections/home_screen_body.dart';
import 'package:gplusapp/UI/main/sections/internet_issue_screen.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

// import 'package:uni_links/uni_links.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/NavigationBar.dart';
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

  StreamSubscription? _sub;

  void sendToRoute(String route, data, String? category) async {
    print("our route ${route}");
    switch (route) {
      case "story":
        // Navigation.instance.navigate('/main');
        print("this route");
        Navigation.instance.navigate('/story', args: '${category},${data}');
        break;
      case "opinion":
        Navigation.instance
            .navigate('/opinionDetails', args: '${data},${category}');
        break;
      default:
        debugPrint("deeplink failed 1 ${route}");
        // Navigation.instance.navigate(
        //     '/link_failed',args: ""
        // );
        break;
    }
  }

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
    fetchNotification();
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
        appBar: Constance.buildAppBar("home",true),
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
        drawer: const BergerMenuMemPage(),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return connected
                ? HomeScreenBody(
                    refreshController: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    showExitDialog: showExitDialog,
                    controller: controller,
                    random: random,
                    fetchPoll: fetchPoll,
                    poll: _poll,
                    getSpace: getSpace,
                  )
                : const InternetIssueScreen();
          },
          child: Container(),
        ),
        bottomNavigationBar: CustomNavigationBar(current),
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
    } else {
      // fetchGPlusExcl();
    }
  }

  void fetchToppicks() async {
    final response = await ApiProvider.instance.getTopPicks(1);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeTopPicks(response.toppicks ?? []);
      fetchAds();
    } else {
      fetchAds();
    }
  }

  void fetchGPlusExcl() async {
    final response = await ApiProvider.instance.getArticle('exclusive-news');
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeExecl(response.articles ?? []);
    } else {
      // fetchPoll();
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
        if (mounted) {
          setState(() {
            _poll = response.pollOfTheWeek?.is_polled ?? "";
          });
        }
      }
      fetchToppicks();
    } else {
      fetchToppicks();
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
      // fetchAds();
      askPermissions();
      fetchNotification();
    } else {
      askPermissions();
      fetchNotification();
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
      // fetchOpinion();
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
      // initUniLinks();
      // initUniLinksResume();
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
                    Constance.about,
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
    } else {}
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
      fetchRedeemMsg();
    } else {
      fetchRedeemMsg();
    }
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

  void fetchNotification() async {
    final response = await ApiProvider.instance.getNotifications();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setNotificationInDevice(response.notification);
      fetchReportMsg();
    } else {
      fetchReportMsg();
    }
  }
}
