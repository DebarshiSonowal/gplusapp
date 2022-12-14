import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Components/history_section.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' show Platform;
import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/promoted_deal.dart';
import '../../Components/promoted_deals_item.dart';
import '../../Components/shop_category_item.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Networking/api_provider.dart';
import '../Menu/berger_menu_member_page.dart';

class BigDealPage extends StatefulWidget {
  const BigDealPage({Key? key}) : super(key: key);

  @override
  State<BigDealPage> createState() => _BigDealPageState();
}

class _BigDealPageState extends State<BigDealPage> {
  String _value = 'Time', deal = "";
  bool expandCateg = false;
  var current = 1;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  bool isEmpty = false;

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance.getPromotedDeals();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setPromotedDeals(response.deals ?? []);
      setState(() {
        isEmpty = (response.deals?.isEmpty ?? false) ? true : false;
      });
      final response1 = await ApiProvider.instance.getShopCategory();
      if (response1.success ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setShopCategory(response1.categories ?? []);
        setState(() {
          isEmpty = (response1.categories?.isEmpty ?? false) ? true : false;
        });
        _refreshController.refreshCompleted();
      } else {
        setState(() {
          isEmpty=true;
        });
        _refreshController.refreshFailed();
      }
    } else {
      setState(() {
        isEmpty=true;
      });
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  @override
  void initState() {
    super.initState();
    // showDialogBox();
    // secureScreen();
    Future.delayed(Duration.zero, () {
      if (!Storage.instance.isBigDeal) {
        showDialogBox();
        debugPrint("Here1");
      } else {
        debugPrint("Here");
      }
      if (Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .deal ==
          "") {
        fetchDealMsg();
      }
      // fetchDeals();
    });

    fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar(),
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      drawer: BergerMenuMemPage(),
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
        // onLoading: _onLoading,
        child: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Consumer<DataProvider>(builder: (context, current, _) {
              return current.deals.isNotEmpty || current.category.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          current.deals.isEmpty
                              ? Container()
                              : Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Text(
                                    'Promoted Deals',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        ?.copyWith(
                                          color: Storage.instance.isDarkMode
                                              ? Colors.white
                                              : Constance.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                          PromotedDeal(
                            current: current,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              'Categories',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: expandCateg
                                  ? current.category.map((e) {
                                      return ShopCategoryItem(
                                        e: e,
                                      );
                                    }).toList()
                                  : current.category
                                      .sublist(0, 8)
                                      .toList()
                                      .map((e) {
                                      return ShopCategoryItem(
                                        e: e,
                                      );
                                    }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 2.5.h,
                          ),
                          current.category.length <= 8
                              ? Container()
                              : SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: CustomButton(
                                        txt: expandCateg
                                            ? 'Show less'
                                            : 'View More',
                                        onTap: () {
                                          setState(() {
                                            expandCateg = !expandCateg;
                                          });
                                        }),
                                  ),
                                ),
                          HistorySection(
                            current: current,
                          ),
                          getSpace(),
                        ],
                      ),
                    )
                  : Lottie.asset(
                      isEmpty
                          ? Constance.noDataLoader
                          : Constance.searchingIcon,
                    );
            }),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
    );
  }

  getSpace() {
    if (Platform.isAndroid) {
      return SizedBox(
        height: 20.h,
      );
    } else if (Platform.isIOS) {
      return SizedBox(
        height: 30.h,
      );
    }
  }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     title: GestureDetector(
  //       onTap: () {
  //         Provider.of<DataProvider>(
  //                 Navigation.instance.navigatorKey.currentContext ?? context,
  //                 listen: false)
  //             .setCurrent(0);
  //         Navigation.instance.navigate('/mainWithAnimation');
  //       },
  //       child: Image.asset(
  //         Constance.logoIcon,
  //         fit: BoxFit.fill,
  //         scale: 2,
  //       ),
  //     ),
  //     centerTitle: true,
  //     backgroundColor: Constance.primaryColor,
  //     actions: [
  //       IconButton(
  //         onPressed: () {
  //           Navigation.instance.navigate('/notification');
  //         },
  //         icon: Consumer<DataProvider>(builder: (context, data, _) {
  //           return Badge(
  //             badgeColor: Constance.secondaryColor,
  //             badgeContent: Text(
  //               '${data.notifications.length}',
  //               style: Theme.of(context).textTheme.headline5?.copyWith(
  //                     color: Constance.thirdColor,
  //                   ),
  //             ),
  //             child: const Icon(Icons.notifications),
  //           );
  //         }),
  //       ),
  //       IconButton(
  //         onPressed: () {
  //           Navigation.instance.navigate('/search',args: "");
  //         },
  //         icon: Icon(Icons.search),
  //       ),
  //     ],
  //   );
  // }

  void showSortByOption() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: 3.h, right: 10.w, left: 10.w, bottom: 3.h),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                child: Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sort by',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Constance.primaryColor,
                            fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        Radio(
                          groupValue: _value,
                          value: 'Time',
                          fillColor: MaterialStateProperty.all(
                            Constance.primaryColor,
                          ),
                          onChanged: (String? value) {
                            _(() {
                              setState(() {
                                _value = value ?? "";
                              });
                            });

                            print(_value);
                          },
                          activeColor: Constance.primaryColor,
                        ),
                        Text(
                          'Time',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          focusColor: Constance.primaryColor,
                          // overlayColor: MaterialStateProperty,
                          groupValue: _value,
                          value: 'Alphabetical',
                          fillColor: MaterialStateProperty.all(
                            Constance.primaryColor,
                          ),
                          onChanged: (String? value) {
                            _(() {
                              setState(() {
                                _value = value ?? "";
                              });
                            });
                          },
                          activeColor: Constance.primaryColor,
                        ),
                        Text(
                          'Alphabetical',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void showDialogBox() {
    Storage.instance.setBigDeal();
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
            'Hello ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.name}',
            style: Theme.of(context).textTheme.headline3?.copyWith(
                  color: Colors.black,
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
                  Constance.bigDealIcon,
                  color: Constance.secondaryColor,
                  height: 6.h,
                  width: 14.w,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Welcome\nto Big Deal!',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Constance.secondaryColor,
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
                              .deal ==
                          ""
                      ? 'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                          ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                          ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                          ' remaining essentially unchanged'
                      : Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .deal,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
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
          actions: const [
            // FlatButton(
            //   textColor: Colors.black,
            //   onPressed: () {},
            //   child: Text('CANCEL'),
            // ),
            // FlatButton(
            //   textColor: Colors.black,
            //   onPressed: () {},
            //   child: Text('ACCEPT'),
            // ),
          ],
        );
      },
    );
  }

  void selectedCategory(String? title) {
    switch (title) {
      case 'Parlours':
        // Navigation.instance.navigate('/categorySelect');
        break;
      case 'Food':
        Navigation.instance.navigate('/fooddealpage');
        break;
      default:
        break;
    }
  }

  void fetchDeals() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getPromotedDeals();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setPromotedDeals(response.deals ?? []);
      final response1 = await ApiProvider.instance.getShopCategory();
      if (response1.success ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setShopCategory(response1.categories ?? []);
        // _refreshController.refreshCompleted();
        Navigation.instance.goBack();
      } else {
        Navigation.instance.goBack();
        // _refreshController.refreshFailed();
      }
    } else {
      Navigation.instance.goBack();
      // _refreshController.refreshFailed();
    }
  }

  void redeem(int id, String? code) async {
    final response = await ApiProvider.instance.redeemCupon(id, code);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setRedeemDetails(response.details!);
      fetchHistory();
      Navigation.instance.navigate('/redeemOfferPage');
    } else {
      Navigation.instance.navigate('/redeemOfferPage');
    }
  }

  void fetchHistory() async {
    final response = await ApiProvider.instance.getRedeemHistory();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setRedeemHistory(response.data ?? []);
    } else {
      // _refreshController.refreshFailed();
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

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
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
}
