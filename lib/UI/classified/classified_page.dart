import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/locality.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/classified_card.dart';
import '../../Components/classified_popup.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class ClassifiedPage extends StatefulWidget {
  const ClassifiedPage({Key? key}) : super(key: key);

  @override
  State<ClassifiedPage> createState() => _ClassifiedPageState();
}

class _ClassifiedPageState extends State<ClassifiedPage> {
  var current = 0;
  var selected = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  String result = '';
  final controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool showing = false;

  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    // secureScreen();
    Future.delayed(Duration.zero, () {
      // fetchFilters();
      fetchDealMsg();
      if (!Storage.instance.isClassified) {
        showDialogBox();
      }
      print('init');
    });
    // Future.delayed(
    //     Duration.zero,
    //         () => Provider.of<DataProvider>(
    //         Navigation.instance.navigatorKey.currentContext ?? context,
    //         listen: false)
    //         .setCurrent(4));
  }

  void _onRefresh() async {
    fetchOnlyFilters();
    // monitor network fetch
    final response = await ApiProvider.instance
        .getClassified(getCategory(selected), result, controller.text);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassified(response.classifieds ?? []);
      setState(() {
        isEmpty = (response.classifieds?.isEmpty ?? false) ? true : false;
      });
      _refreshController.refreshCompleted();
    } else {
      setState(() {
        isEmpty = true;
      });
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar("classified", true, scaffoldKey),
      key: scaffoldKey,
      drawer: const BergerMenuMemPage(
        screen: "classified",
      ),
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          logThePostAListingClick(Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .profile!);
          checkIt();
        },
        icon: const Icon(Icons.add),
        label: Text(
          "Post a listing",
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
              ),
        ),
      ),
      floatingActionButtonLocation: !showing
          ? FloatingActionButtonLocation.miniEndFloat
          : FloatingActionButtonLocation.miniStartFloat,
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
        // onLoading: _onLoading,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    // color: Constance.forthColor,
                    height: 5.h,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // showSortByOption();
                            setState(() {
                              selected = 1;
                            });
                            getFilter();
                          },
                          child: Container(
                            width: 48.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 5.w,
                            ),
                            color: selected == 1
                                ? Constance.secondaryColor
                                : Constance.forthColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.list,
                                  color: selected == 1
                                      ? Colors.black
                                      : Storage.instance.isDarkMode
                                          ? Constance.secondaryColor
                                          : Colors.white,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  'Filter by',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: selected == 1
                                            ? Colors.black
                                            : Storage.instance.isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 2.h,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                          child: Center(
                            child: Container(
                              height: double.infinity,
                              width: 0.5.w,
                              color: Storage.instance.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // setState(() {
                            //   selected = 3;
                            // });
                            // fetchClassified(result);
                            logTheMyListClick(Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .profile!);
                            var result = await Navigation.instance.navigate(
                              '/classifiedMyListDetails',
                            );
                            if (result == null) {
                              fetchClassified(result);
                            }
                          },
                          child: Container(
                            width: 48.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 5.w,
                            ),
                            color: selected == 3
                                ? Constance.secondaryColor
                                : Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Constance.forthColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.person,
                                  color: selected == 3
                                      ? Colors.black
                                      : Storage.instance.isDarkMode
                                          ? Constance.secondaryColor
                                          : Colors.white,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  'My List',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: selected == 3
                                            ? Colors.black
                                            : Storage.instance.isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 2.h,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
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
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Divider(
                      thickness: 0.07.h,
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Card(
                      color: Colors.white,
                      child: TextField(
                        controller: controller,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Search",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2.0,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              fetchClassified(result);
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          fetchClassified(result);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Divider(
                      thickness: 0.07.h,
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  data.classified.isEmpty
                      ? Center(
                          child: Lottie.asset(
                            isEmpty
                                ? Constance.noDataLoader
                                : Constance.searchingIcon,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 1.h),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.classified.length,
                            itemBuilder: (cont, count) {
                              var current = data.classified[count];
                              // bool like = (selected == 2
                              //     ? true
                              //     : (current.is_favourite ?? false)
                              //         ? true
                              //         : false);
                              return ClassifiedCard(
                                  refreshParent: () {
                                    fetchClassified("");
                                  },
                                  current: current,
                                  like: (current.is_favourite ?? false)
                                      ? true
                                      : false);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 1.h,
                              );
                            },
                          ),
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomNavigationBar(current, "classified"),
    );
  }

  void showDialogBox() {
    Storage.instance.setClassified();
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
            'Post your listing',
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
                  Constance.classifiedIcon,
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
                  Provider.of<DataProvider>(
                                  Navigation.instance.navigatorKey
                                          .currentContext ??
                                      context,
                                  listen: false)
                              .classifiedMsg ==
                          ""
                      ? 'Posting made easy! All you have to do is log in and click the “Post a Listing” button at the corner'
                      : Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .classifiedMsg,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                // SizedBox(height: 1.h),
                // Text(
                //   'is simply dummy text of the printing and typesetting industry',
                //   style: Theme.of(context).textTheme.headline5?.copyWith(
                //         color: Colors.black,
                //         // fontWeight: FontWeight.bold,
                //       ),
                // ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchClassified(result) async {
    print(result);
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance
        .getClassified(getCategory(selected), result, controller.text);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassified(response.classifieds ?? []);

      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  getCategory(int current) {
    switch (current) {
      case 3:
        return "my-list";
      case 2:
        return "favourites";
      default:
        return "list-by";
    }
  }

  void getFilter() async {
    final result = await Navigation.instance.navigate('/filterPage');
    if (result != null) {
      // logTheFilterAppliedClick(
      //     Provider.of<DataProvider>(
      //             Navigation.instance.navigatorKey.currentContext ?? context,
      //             listen: false)
      //         .profile!,
      //     result);
      fetchClassified(result);
    }
  }

  void setAsFavourite(int? id, String type) async {
    final response = await ApiProvider.instance.setAsFavourite(id, type);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "Added to favourites");
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
      final resp = await Navigation.instance.navigate('/postClassified');
      if (resp == null) {
        fetchClassified(result);
      }
    } else {
      setState(() {
        showing = true;
      });
      scaffoldKey.currentState
          ?.showBottomSheet(
            (context) {
              return const ClassifiedPopUp();
            },
            // context: context,
            backgroundColor: Colors.grey.shade100,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
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

  void fetchFilters() async {
    final Map<int, bool> _map = {};
    // await Storage.instance.filters;
    var selected = (await Storage.instance.filters).toString().split(',');
    for (var i in selected) {
      try {
        setState(() {
          Map<int, bool> data = {
            int.parse(i): true,
          };
          _map.addAll(data);
        });
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      result = getComaSeparated(
        _map.keys.toList(),
        _map.values.toList(),
      );
    });
    fetchClassified(result);
  }

  void fetchOnlyFilters() async {
    final Map<int, bool> _map = {};
    // await Storage.instance.filters;
    var selected = (await Storage.instance.filters).toString().split(',');
    for (var i in selected) {
      try {
        setState(() {
          Map<int, bool> data = {
            int.parse(i): true,
          };
          _map.addAll(data);
        });
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      result = getComaSeparated(
        _map.keys.toList(),
        _map.values.toList(),
      );
    });
    // fetchClassified(result);
  }

  String getComaSeparated(List<dynamic> list, List<dynamic> list2) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (list2[i] == true) {
        if (i == 0) {
          temp = '${list[i]},';
        } else {
          temp += '${list[i]},';
        }
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
  }

  void logThePostAListingClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "post_a_listing_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "post": post,
        // "cta_click": cta_click,
        "screen_name": "classified",
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
        "screen_name": "classified",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void logTheFilterAppliedClick(Profile profile, String filter_applied) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "filter_applied",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "filter_applied": getFilteredList(
            filter_applied.toString().split(","),
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .locality),
        // "cta_click": cta_click,
        "screen_name": "classified",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void fetchDealMsg() async {
    final response = await ApiProvider.instance.fetchMessages();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setDealText(response.deal ?? "");
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassifiedText(response.classified ?? "");
    }
  }

  getFilteredList(List<String> split, List<Locality> locality) {
    String temp = "";
    for (var i in split) {
      for (var j in locality) {
        if (i == j.id.toString()) {
          if (temp == "") {
            temp = '${j.name},';
          } else {
            temp += '${j.name},';
          }
        }
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
  }
}
