import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../Components/NavigationBar.dart';
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
    fetchDeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
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
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Consumer<DataProvider>(builder: (context, current, _) {
            return current.deals.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(
                            'Promoted Deals',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                    color: Constance.primaryColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        SizedBox(
                          height: 33.h,
                          width: double.infinity,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: current.deals.length,
                            itemBuilder: (cont, cout) {
                              var data = current.deals[cout];
                              return GestureDetector(
                                onTap: () {
                                  Navigation.instance.navigate(
                                      '/categorySelect',
                                      args: data.id);
                                },
                                child: SizedBox(
                                  height: 30.h,
                                  width: 60.w,
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(5.0),
                                                bottomRight:
                                                    Radius.circular(5.0),
                                                topLeft: Radius.circular(5.0),
                                                bottomLeft:
                                                    Radius.circular(5.0),
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.contain,
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
                                              horizontal: 4.w, vertical: 1.h),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.vendor?.shop_name ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    ?.copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 0.5.h,
                                              ),
                                              Text(
                                                data.vendor?.address ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                      color: Colors.black,
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
                                                            FontWeight.bold),
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
                                    color: Constance.primaryColor,
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
                            children: current.category.map((e) {
                              return GestureDetector(
                                onTap: () {
                                  selectedCategory(e.name);
                                },
                                child: Container(
                                  // height: 10.h,
                                  width: 10.h,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 0.5.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 8.h,
                                        height: 8.h,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 1.h),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Constance.secondaryColor),
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
                                              color: Constance.primaryColor,
                                              // fontSize: 1.7.h,
                                              fontWeight: FontWeight.bold,
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
                        SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: CustomButton(
                                txt: 'View More ',
                                onTap: () {
                                  showDialogBox();
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
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Divider(
                                    color: Constance.secondaryColor,
                                    thickness: 0.1.h,
                                  ),
                                ),
                                Padding(
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
                                            '25% OFF',
                                            overflow: TextOverflow.ellipsis,
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
                                          Text(
                                            'Subway',
                                            overflow: TextOverflow.ellipsis,
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            'RGB road, Zoo tiniali',
                                            overflow: TextOverflow.ellipsis,
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
                                        children: [
                                          Text(
                                            '8486',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(Navigation.instance
                                                .navigatorKey.currentContext!)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                              color: Colors.grey.shade800,
                                              // fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '26-12-2022',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(Navigation.instance
                                                    .navigatorKey.currentContext!)
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
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
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
                                            '25% OFF',
                                            overflow: TextOverflow.ellipsis,
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
                                          Text(
                                            'Subway',
                                            overflow: TextOverflow.ellipsis,
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'RGB road, Zoo tiniali',
                                            overflow: TextOverflow.ellipsis,
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
                                        children: [
                                          Text(
                                            '8486',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(Navigation.instance
                                                .navigatorKey.currentContext!)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                              color: Colors.grey.shade800,
                                              // fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '26-12-2022',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(Navigation.instance
                                                .navigatorKey.currentContext!)
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
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
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
                                            '25% OFF',
                                            overflow: TextOverflow.ellipsis,
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
                                          Text(
                                            'Subway',
                                            overflow: TextOverflow.ellipsis,
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'RGB road, Zoo tiniali',
                                            overflow: TextOverflow.ellipsis,
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
                                        children: [
                                          Text(
                                            '8486',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(Navigation.instance
                                                .navigatorKey.currentContext!)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                              color: Colors.grey.shade800,
                                              // fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '26-12-2022',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(Navigation.instance
                                                .navigatorKey.currentContext!)
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
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
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
                                            '25% OFF',
                                            overflow: TextOverflow.ellipsis,
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
                                          Text(
                                            'Subway',
                                            overflow: TextOverflow.ellipsis,
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
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'RGB road, Zoo tiniali',
                                            overflow: TextOverflow.ellipsis,
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
                                        children: [
                                          Text(
                                            '8486',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(Navigation.instance
                                                .navigatorKey.currentContext!)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                              color: Colors.grey.shade800,
                                              // fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '26-12-2022',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(Navigation.instance
                                                .navigatorKey.currentContext!)
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
                                SizedBox(
                                  height: 1.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Divider(
                                    color: Constance.secondaryColor,
                                    thickness: 0.1.h,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  child: Row(
                                    children: [
                                      Text(
                                        'See More',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: Theme.of(Navigation.instance
                                                .navigatorKey.currentContext!)
                                            .textTheme
                                            .headline4
                                            ?.copyWith(
                                              color: Constance.secondaryColor,
                                              // fontSize: 11.sp,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                              ],
                            ),
                          ),
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
      bottomNavigationBar: CustomNavigationBar(current),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
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
            'Hello Jonathan!',
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
      case 'Parlour':
        Navigation.instance.navigate('/categorySelect');
        break;
      case 'Food':
        Navigation.instance.navigate('/fooddealpage');
        break;
      default:
        break;
    }
  }

  void fetchDeals() async {
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
      } else {
        // _refreshController.refreshFailed();
      }
    } else {
      // _refreshController.refreshFailed();
    }
  }
}
