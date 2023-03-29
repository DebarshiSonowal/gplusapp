import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Components/guwhati_connect_post_card.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class GuwahatiConnectMylistPage extends StatefulWidget {
  const GuwahatiConnectMylistPage({Key? key}) : super(key: key);

  @override
  State<GuwahatiConnectMylistPage> createState() =>
      _GuwahatiConnectMylistPageState();
}

class _GuwahatiConnectMylistPageState extends State<GuwahatiConnectMylistPage>
    with SingleTickerProviderStateMixin {
  int current = 2, currentScrollPercent = 0;
  bool showing = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final ScrollController controller = ScrollController();
  Animation<double>? _animation;
  AnimationController? _animationController;
  String txt = '''If you have a huge friends’ list, 
                  you know a lot of people and you think you have 
                  resources to help someone out, this is where your 
                  inputs are required. G Plus Connect is here to bridge 
                  the gap between you and the things you are looking for.
                   Imagine all of Guwahati on one single group; people from
                    different backgrounds with different interests who stay
                     in different circles. We aim to link all of Guwahati 
                     together, so all you need to do is ask. Post your questions
                     , queries about accommodations, eateries, hospitals, places 
                     to visit etc. and someone will definitely help you out.''';

  bool isEmpty = false,has_permission=false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    getText();
    // secureScreen();
    Future.delayed(Duration.zero, () {
      // fetchGuwahatiConnect();
      if (!Storage.instance.isGuwahatiConnect) {
        showDialogBox();
      }
    });
    controller.addListener(() {
      var currentScroll =
          ((controller.position.pixels / controller.position.maxScrollExtent) *
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

  // @override
  // void dispose() {
  //   super.dispose();
  //   _searchQueryController.dispose();
  // }

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance.getMyGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      // Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGuwahatiConnect(response.posts);
      setState(() {
        isEmpty = (response.posts.isEmpty ?? false) ? true : false;
        has_permission = (response.has_permission??false);
      });
      _refreshController.refreshCompleted();
    } else {
      setState(() {
        isEmpty = true;
      });
      // Navigation.instance.goBack();
      // Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext ?? context,
      //         listen: false)
      //     .setMyGuwahatiConnect(response.posts);
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: Constance.buildAppBar("guwahati", true, scaffoldKey),
      appBar: Constance.buildAppBar2("guwahati"),
      // drawer: const BergerMenuMemPage(screen: "guwahati"),
      key: scaffoldKey,
      // drawer: BergerMenuMemPage(),

      bottomNavigationBar: CustomNavigationBar(current, "guwahati"),
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              FontAwesomeIcons.radio,
                              color: Constance.secondaryColor,
                              size: 6.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Guwahati Connect',
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Constance.primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Divider(
                    thickness: 0.075.h,
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Consumer<DataProvider>(builder: (context, current, _) {
                  return current.myGuwahatiConnect.isEmpty
                      ? Center(
                          child: Lottie.asset(
                            isEmpty
                                ? Constance.noDataLoader
                                : Constance.searchingIcon,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: current.myGuwahatiConnect.length,
                            itemBuilder: (context, count) {
                              var data = current.myGuwahatiConnect[count];
                              bool like = data.is_liked ?? false,
                                  dislike = false;
                              return GuwahatiConnectPostCard(
                                data,
                                count,
                                like,
                                dislike,
                                scaffoldKey,
                                () {
                                  fetchGuwahatiConnect();
                                },
                                (id, val) {
                                  postLike(id, val, () {
                                    like = !like;
                                  });
                                },
                                (id) {
                                  if (id == 0) {
                                    setState(() {
                                      showing = true;
                                    });
                                  } else {
                                    setState(() {
                                      showing = false;
                                    });
                                  }
                                },
                                1,
                                true,
                                () {
                                  setState(() {
                                    showing = true;
                                  });
                                  Constance.showMembershipPrompt(context, () {
                                    setState(() {
                                      showing = false;
                                    });
                                  });
                                },
                                has_permission,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                child: Divider(
                                  thickness: 0.04.h,
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              );
                            },
                          ),
                        );
                }),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDialogBox() {
    Storage.instance.setGuwahatiConnect();
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
            'Guwahati Connect',
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
                Icon(
                  FontAwesomeIcons.radio,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Hello ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.name}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  txt,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'If you help someone out, remember you’re going to get back the favour! So, start posting!',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchGuwahatiConnect() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getMyGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGuwahatiConnect(response.posts);
      if (!Storage.instance.isGuwahatiConnect) {
        showDialogBox();
      }
      setState(() {
        has_permission = (response.has_permission??false);
      });
    } else {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGuwahatiConnect(response.posts);
    }
  }

  void postLike(id, is_like, like_changed) async {
    final response =
        await ApiProvider.instance.postLike(id, is_like, 'guwahati-connect');
    if (response.success ?? false) {
      // Fluttertoast.showToast(msg: response.message ?? "Post Liked");
      // fetchGuwahatiConnect();
      like_changed();
    } else {
      showError("Something went wrong");
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

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void getText() async {
    final response = await ApiProvider.instance.getGuwahatiConnectText();
    if (response.success ?? false) {
      setState(() {
        txt = response.desc ?? "";
      });
    } else {}
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
        "screen_name": "guwahati",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
