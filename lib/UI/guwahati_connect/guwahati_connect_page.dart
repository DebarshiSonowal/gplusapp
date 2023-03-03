import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
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

class GuwahatiConnectPage extends StatefulWidget {
  const GuwahatiConnectPage({Key? key}) : super(key: key);

  @override
  State<GuwahatiConnectPage> createState() => _GuwahatiConnectPageState();
}

class _GuwahatiConnectPageState extends State<GuwahatiConnectPage>
    with SingleTickerProviderStateMixin {
  int current = 2;
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

  bool isEmpty = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    Future.delayed(Duration.zero, () {
      if (!Storage.instance.isGuwahatiConnect) {
        showDialogBox();
      }
    });
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    getText();
    controller.addListener(() {
      logTheScrollClick(
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile!,
        "${(controller.position.pixels / controller.position.maxScrollExtent) * 100.toInt()}%",
      );
    });
    // secureScreen();
    // Future.delayed(Duration.zero, () {
    //   fetchGuwahatiConnect();
    // });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _searchQueryController.dispose();
  // }

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance.getGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      // Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
      setState(() {
        isEmpty = (response.posts.isEmpty ?? false) ? true : false;
      });
      _refreshController.refreshCompleted();
    } else {
      // Navigation.instance.goBack();
      setState(() {
        isEmpty = true;
      });
      // Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext ?? context,
      //         listen: false)
      //     .setGuwahatiConnect(response.posts);
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar("guwahati", true, scaffoldKey),
      key: scaffoldKey,
      drawer: const BergerMenuMemPage(screen: "guwahati"),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     checkIt();
      //     // showDialogBox();
      //   },
      //   icon: Icon(Icons.add),
      //   label: Text(
      //     "Ask a question",
      //     style: Theme.of(context).textTheme.headline5?.copyWith(
      //           color: Colors.black,
      //           // fontWeight: FontWeight.bold,
      //         ),
      //   ),
      // ),
      floatingActionButton: !showing
          ? FloatingActionBubble(
              // Menu items
              items: <Bubble>[
                // Floating action menu item
                Bubble(
                  title: "Ask a question",
                  iconColor: Colors.white,
                  bubbleColor: Constance.primaryColor,
                  icon: Icons.question_answer,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  onPress: () {
                    logTheAskAQuestionClick(Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            listen: false)
                        .profile!);
                    _animationController?.reverse();
                    if (Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile
                            ?.is_plan_active ??
                        false) {
                      Navigation.instance.navigate('/askAQuestion');
                    } else {
                      Constance.showMembershipPrompt(context, () {});
                    }
                  },
                ),
                Bubble(
                  title: "My List",
                  iconColor: Colors.white,
                  bubbleColor: Constance.primaryColor,
                  icon: Icons.list,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  onPress: () {
                    logTheMyListClick(Provider.of<DataProvider>(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            listen: false)
                        .profile!);
                    _animationController?.reverse();
                    Navigation.instance.navigate('/guwahatiConnectsMy');
                  },
                ),
                // Floating action menu item
              ],

              // animation controller
              animation: _animation!,

              // On pressed change animation state
              onPress: () => _animationController?.isCompleted ?? false
                  ? _animationController?.reverse()
                  : _animationController?.forward(),

              // Floating Action button Icon color
              iconColor: Colors.white,

              // Flaoting Action button Icon
              iconData: Icons.add,
              backGroundColor: Constance.primaryColor,
            )
          : FloatingActionButton(
              onPressed: () {},
              backgroundColor: Constance.primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
      floatingActionButtonLocation: showing
          ? FloatingActionButtonLocation.miniStartFloat
          : FloatingActionButtonLocation.miniEndFloat,
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
                            Image.asset(
                              Constance.connectIcon,
                              height: 6.h,
                              width: 14.w,
                              fit: BoxFit.fill,
                              color: Constance.secondaryColor,
                              // size: 6.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
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
                  return current.guwahatiConnect.isEmpty
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
                            itemCount: current.guwahatiConnect.length,
                            itemBuilder: (context, count) {
                              var data = current.guwahatiConnect[count];
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
                                    if (Provider.of<DataProvider>(
                                                Navigation.instance.navigatorKey
                                                        .currentContext ??
                                                    context,
                                                listen: false)
                                            .profile
                                            ?.is_plan_active ??
                                        false) {
                                      // Navigation.instance.navigate('/exclusivePage');
                                      postLike(id, val, () {
                                        like = !like;
                                      });
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
                                  (id) {
                                    if (id == 0) {
                                    } else {
                                      // setState(() {
                                      //   showing = true;
                                      // });
                                    }
                                  },
                                  0,
                                  false,
                                  () {
                                    setState(() {
                                      showing = true;
                                    });
                                    Constance.showMembershipPrompt(context, () {
                                      setState(() {
                                        showing = false;
                                      });
                                    });
                                  });
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
                  height: 17.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logTheAskAQuestionClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "ask_a_question_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "post": post,
        // "cta_click": cta_click,
        "screen_name": "guwahati",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void logTheMyListClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "my_list_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "post": post,
        // "cta_click": cta_click,
        "screen_name": "guwahati",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
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
                Image.asset(
                  Constance.connectIcon,
                  color: Constance.secondaryColor,
                  height: 6.h,
                  width: 14.w,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 1.h),
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
    final response = await ApiProvider.instance.getGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
    } else {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
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

  void checkIt() async {
    if (Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.is_plan_active ??
        false) {
      Navigation.instance.navigate('/askAQuestion');
    } else {
      setState(() {
        showing = true;
      });
      scaffoldKey.currentState
          ?.showBottomSheet(
            enableDrag: true,
            (context) {
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
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          Constance.about,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'Do you want to be a member?',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
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
            },
            // context: context,
            backgroundColor: Colors.grey.shade100,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
            ),
          )
          .closed
          .then((value) {
            setState(() {
              showing = false;
            });
          });
    }
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

  void getText() async {
    final response = await ApiProvider.instance.getGuwahatiConnectText();
    if (response.success ?? false) {
      setState(() {
        txt = response.desc ?? "";
      });
    } else {}
  }
}
