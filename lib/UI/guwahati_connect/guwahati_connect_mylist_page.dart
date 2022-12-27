import 'dart:ui';

import 'package:badges/badges.dart';
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
import '../../Navigation/Navigate.dart';

class GuwahatiConnectMylistPage extends StatefulWidget {
  const GuwahatiConnectMylistPage({Key? key}) : super(key: key);

  @override
  State<GuwahatiConnectMylistPage> createState() =>
      _GuwahatiConnectMylistPageState();
}

class _GuwahatiConnectMylistPageState extends State<GuwahatiConnectMylistPage>
    with SingleTickerProviderStateMixin {
  int current = 2;
  bool showing = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
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
      appBar: buildAppBar(),
      key: scaffoldKey,
      // drawer: BergerMenuMemPage(),

      bottomNavigationBar: CustomNavigationBar(current),
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
                                  data, count, like, dislike, scaffoldKey, () {
                                fetchGuwahatiConnect();
                              }, (id, val) {
                                postLike(id, val, () {
                                  like = !like;
                                });
                              }, (id) {
                                if (id == 0) {
                                  setState(() {
                                    showing = true;
                                  });
                                } else {
                                  setState(() {
                                    showing = false;
                                  });
                                }
                              }, 1, true);
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
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return Badge(
              badgeColor: Constance.secondaryColor,
              badgeContent: Text(
                '${data.notifications.length}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Constance.thirdColor,
                    ),
              ),
              child: const Icon(Icons.notifications),
            );
          }),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search',args: "");
          },
          icon: Icon(Icons.search),
        ),
      ],
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
                          '''Projected to be a smart city by 2025, Guwahati is a
major port on the banks of Brahmaputra, the capital
of Assam and the urban hub of the North East. This
metropolitan city is growing leaps and bounds, and
for its unparalleled pace of growth, comes the need
for an unparalleled publication, that people call their''',
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
}
