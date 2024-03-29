import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class GuwahatiConnectPage extends StatefulWidget {
  const GuwahatiConnectPage({Key? key}) : super(key: key);

  @override
  State<GuwahatiConnectPage> createState() => _GuwahatiConnectPageState();
}

class _GuwahatiConnectPageState extends State<GuwahatiConnectPage>
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

  bool isEmpty = false, has_permission = false, is_enabled = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    Future.delayed(Duration.zero, () {
      if (!Storage.instance.isGuwahatiConnect) {
        // getText();
        showDialogBox();
      }
      // getText();
      // showDialogBox();
    });
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
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
        has_permission = (response.has_permission ?? false);
        is_enabled = true;
      });
      _refreshController.refreshCompleted();
    } else {
      // Navigation.instance.goBack();
      setState(() {
        isEmpty = true;
        is_enabled = true;
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
      floatingActionButton: !showing
          ? Builder(builder: (context) {
              return FloatingActionBubble(
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
                      if (is_enabled) {
                        logTheAskAQuestionClick(Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile!);
                        _animationController?.reverse();
                        if (has_permission ?? false) {
                          Navigation.instance.navigate('/askAQuestion');
                        } else {
                          // Constance.showMembershipPrompt(context, () {});
                          // Navigation.instance.goBack();
                          setState(() {
                            showing = true;
                          });
                          Constance.showMembershipPrompt(context, () {
                            setState(() {
                              showing = false;
                            });
                          });
                        }
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
              );
            })
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
        header: const WaterDropHeader(),
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
                  return
                      // current.guwahatiConnect.isEmpty
                      //   ? Center(
                      //       child: (isEmpty
                      //           ? Image.asset(
                      //               "assets/images/no_data.png",
                      //               scale: 4,
                      //             )
                      //           : Lottie.asset(
                      //               Constance.searchingIcon,
                      //             )),
                      //     )
                      //   :
                      Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: current.guwahatiConnect.isNotEmpty
                        ? ListView.separated(
                            padding: EdgeInsets.only(bottom: 5.h),
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
                                  if (has_permission ?? false) {
                                    // Navigation.instance.navigate('/exclusivePage');
                                    postLike(id, val, () {
                                      like = !like;
                                    });
                                  } else {
                                    setState(() {
                                      showing = true;
                                    });
                                    Constance.showMembershipPrompt(context, () {
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
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            width: double.infinity,
                            height: 80.h,
                            child: const GuwahatiConnectShimmerCard(),
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
                  'Hello ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.name?.capitalize()}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                      .connect,
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
      setState(() {
        has_permission = (response.has_permission ?? false);
      });
      debugPrint("PERM STAT ${response.has_permission}");
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

class GuwahatiConnectShimmerCard extends StatelessWidget {
  const GuwahatiConnectShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      height: 40.w,
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey.shade300,
        enabled: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40.w,
                  height: 3.h,
                  color: Colors.grey.shade100,
                ),
                Icon(Icons.menu_sharp,color: Colors.grey.shade100,),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            Container(
              width: 70.w,
              height: 2.h,
              color: Colors.grey.shade100,
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              width: 60.w,
              height: 2.h,
              color: Colors.grey.shade100,
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              width: 50.w,
              height: 2.h,
              color: Colors.grey.shade100,
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              width: 30.w,
              height: 2.h,
              color: Colors.grey.shade100,
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 20.w,
                  height: 2.h,
                  color: Colors.grey.shade100,
                ),
                Container(
                  width: 20.w,
                  height: 2.h,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Icon(Icons.thumb_up,color: Colors.grey.shade100,),
                SizedBox(
                  width: 4.w,
                ),
                Icon(Icons.thumb_down,color: Colors.grey.shade100,),
                const Spacer(),
                Icon(Icons.comment,color: Colors.grey.shade100,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
