import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/DataProvider.dart';
import '../../Networking/api_provider.dart';
import '../Menu/berger_menu_member_page.dart';

class BigDealPage extends StatefulWidget {
  const BigDealPage({Key? key}) : super(key: key);

  @override
  State<BigDealPage> createState() => _BigDealPageState();
}

class _BigDealPageState extends State<BigDealPage> {
  String _value = 'Time';
  bool expandCateg = false;
  var current = 1;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
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
        _refreshController.refreshCompleted();
      } else {
        _refreshController.refreshFailed();
      }
    } else {
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
      fetchDeals();
    });

    fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
                                        .headline3
                                        ?.copyWith(
                                            color: Storage.instance.isDarkMode
                                                ? Colors.white
                                                : Constance.primaryColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                          current.deals.isEmpty
                              ? SizedBox(
                                  height: 6.h,
                                )
                              : SizedBox(
                                  height: 2.h,
                                ),
                          current.deals.isEmpty
                              ? Container()
                              : SizedBox(
                                  height: 33.h,
                                  width: double.infinity,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: current.deals.length,
                                    itemBuilder: (cont, cout) {
                                      var data = current.deals[cout];
                                      return GestureDetector(
                                        onTap: () {
                                          if (Provider.of<DataProvider>(
                                                      Navigation
                                                              .instance
                                                              .navigatorKey
                                                              .currentContext ??
                                                          context,
                                                      listen: false)
                                                  .profile
                                                  ?.is_plan_active ??
                                              false) {
                                            Navigation.instance.navigate(
                                                '/categorySelect',
                                                args: data.vendor_id);
                                          } else {
                                            Constance.showMembershipPrompt(
                                                context, () {});
                                          }
                                        },
                                        child: Container(
                                          height: 30.h,
                                          width: 60.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Storage.instance.isDarkMode?Colors.white:Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Card(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(

                                              borderRadius:
                                                  BorderRadius.circular(5.0,),

                                            ),
                                            color: Storage.instance.isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(
                                                                5.0,
                                                            ),
                                                        bottomRight:
                                                            Radius.circular(
                                                                5.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                5.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                5.0),
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: CachedNetworkImageProvider(
                                                            data.vendor
                                                                    ?.image_file_name ??
                                                                "https://source.unsplash.com/user/c_v_r/1900x800",
                                                            maxWidth: 100),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: 1.h,
                                                // ),
                                                Expanded(
                                                    child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.w,
                                                      vertical: 1.h),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.vendor
                                                                ?.shop_name ??
                                                            "",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4
                                                            ?.copyWith(
                                                                color: Storage
                                                                        .instance
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Text(
                                                        data.vendor?.address ??
                                                            "",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            ?.copyWith(
                                                              color: Storage
                                                                      .instance
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              // fontWeight: FontWeight.bold
                                                            ),
                                                      ),
                                                      SizedBox(
                                                        height: 0.5.h,
                                                      ),
                                                      Text(
                                                        data.title ?? "",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4
                                                            ?.copyWith(
                                                                color: Constance
                                                                    .thirdColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        width: 2.h,
                                      );
                                    },
                                  ),
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
                                  .headline4
                                  ?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Constance.primaryColor,
                                      fontWeight: FontWeight.bold),
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
                                      return GestureDetector(
                                        onTap: () {
                                          // selectedCategory(e.name);
                                          Navigation.instance.navigate(
                                              '/fooddealpage',
                                              args: e.id!);
                                        },
                                        child: Container(
                                          // height: 10.h,
                                          width: 10.h,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 1.w, vertical: 0.5.w),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 8.h,
                                                height: 8.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 1.h),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Constance
                                                          .secondaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Image.network(
                                                  e.image_file_name ?? "",
                                                  // color: Constance.primaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              Text(
                                                e.name ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                  color: Storage.instance.isDarkMode
                                                      ? Colors.white
                                                      : Constance.primaryColor,
                                                      // fontSize: 1.7.h,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  : current.category
                                      .sublist(0, 8)
                                      .toList()
                                      .map((e) {
                                      return GestureDetector(
                                        onTap: () {
                                          // selectedCategory(e.name);
                                          Navigation.instance.navigate(
                                              '/fooddealpage',
                                              args: e.id!);
                                        },
                                        child: Container(
                                          // height: 10.h,
                                          width: 10.h,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 1.w, vertical: 0.5.w),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 8.h,
                                                height: 8.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 1.h),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 0.3.h,
                                                      color: Constance
                                                          .secondaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Storage.instance.isDarkMode
                                                      ? Colors.white
                                                      : Colors.transparent,
                                                ),
                                                child: Image.network(
                                                  e.image_file_name ?? "",
                                                  // color: Constance.primaryColor,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              Text(
                                                e.name ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                  color: Storage.instance.isDarkMode
                                                      ? Colors.white
                                                      : Constance.primaryColor,
                                                      // fontSize: 1.7.h,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                            ],
                                          ),
                                        ),
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Card(
                              color: Colors.white,
                              child: ExpansionTile(
                                collapsedIconColor: Colors.black,
                                iconColor: Colors.black,
                                title: Text(
                                  'History',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(Navigation.instance
                                          .navigatorKey.currentContext!)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                        color: Colors.black,
                                        // fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                children: [
                                  current.history.isEmpty
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Divider(
                                            color: Constance.secondaryColor,
                                            thickness: 0.1.h,
                                          ),
                                        ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (cont, count) {
                                      var data = current.history[count];
                                      return GestureDetector(
                                        onTap: () {
                                          redeem(data.vendor_id!, data.code);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 1.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.title ?? '25% OFF',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(Navigation
                                                            .instance
                                                            .navigatorKey
                                                            .currentContext!)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                          // fontSize: 11.sp,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  ),
                                                  Text(
                                                    data.vendor?.shop_name ??
                                                        "",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(Navigation
                                                            .instance
                                                            .navigatorKey
                                                            .currentContext!)
                                                        .textTheme
                                                        .headline4
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                          // fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  ),
                                                  Text(
                                                    data.vendor?.address ??
                                                        'RGB road, Zoo tiniali',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(Navigation
                                                            .instance
                                                            .navigatorKey
                                                            .currentContext!)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                          // fontSize: 11.sp,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${data.code ?? '8486'}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(Navigation
                                                            .instance
                                                            .navigatorKey
                                                            .currentContext!)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                          color: Colors
                                                              .grey.shade800,
                                                          // fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  ),
                                                  Text(
                                                    'From: ${Jiffy(data.valid_from.toString().split('T')[0] ?? "", "yyyy-MM-dd").format("dd/MM/yyyy")}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(Navigation
                                                            .instance
                                                            .navigatorKey
                                                            .currentContext!)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                          // fontSize: 11.sp,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    height: 0.5.h,
                                                  ),
                                                  Text(
                                                    'To: ${Jiffy(data.valid_to.toString().split('T')[0] ?? "", "yyyy-MM-dd").format("dd/MM/yyyy")}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(Navigation
                                                            .instance
                                                            .navigatorKey
                                                            .currentContext!)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                          // fontSize: 11.sp,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (cont, count) {
                                      return SizedBox(
                                        height: 1.h,
                                      );
                                    },
                                    itemCount: current.history.length,
                                  ),
                                  current.history.isEmpty
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Divider(
                                            color: Constance.secondaryColor,
                                            thickness: 0.1.h,
                                          ),
                                        ),
                                  current.history.isEmpty
                                      ? Container()
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 1.h),
                                          child: Row(
                                            children: [
                                              Text(
                                                'See More',
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: Theme.of(Navigation
                                                        .instance
                                                        .navigatorKey
                                                        .currentContext!)
                                                    .textTheme
                                                    .headline4
                                                    ?.copyWith(
                                                      color: Constance
                                                          .secondaryColor,
                                                      // fontSize: 11.sp,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: SizedBox(
                          height: 2.h,
                          width: 2.h,
                          child: const CircularProgressIndicator()),
                    );
            }),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
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

  void showSortByOption() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0)),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: 3.h, right: 10.w, left: 10.w, bottom: 3.h),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: const Radius.circular(15.0))),
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
                Icon(
                  Icons.local_offer,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Welcome\nto Big Deal!',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Constance.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                  ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                  ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                  ' remaining essentially unchanged',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry',
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
                )
              ],
            ),
          ),
          actions: [
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
}
