import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class CategorySelectPage extends StatefulWidget {
  final int id;

  const CategorySelectPage(this.id);

  @override
  State<CategorySelectPage> createState() => _CategorySelectPageState();
}

class _CategorySelectPageState extends State<CategorySelectPage> {
  String dropdownvalue = '10:00 am - 8:00 pm';
  int selected = 0;

  // List of items in our dropdown menu
  var items = [
    '10:00 am - 8:00 pm',
    '12:00 am - 4:00 pm',
    '9:00 am - 3:00 pm',
  ];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance.getDealDetails(widget.id);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setDealDetails(response.details!);

      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchDetails());
    // secureScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
          color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          child: Consumer<DataProvider>(builder: (context, current, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
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
                      height: 30.h,
                      width: double.infinity,
                      imageUrl: current.details?.image_file_name ??
                          Constance.salonImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  current.details?.shop_name ?? 'The Looks Salon',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = 0;
                          });
                        },
                        child: Container(
                          height: 5.h,
                          color: selected == 0
                              ? Constance.secondaryColor
                              : Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                          child: Center(
                            child: Text(
                              'Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: selected == 0
                                        ? Colors.black
                                        : Storage.instance.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = 1;
                          });
                        },
                        child: Container(
                          height: 5.h,
                          color: selected == 1
                              ? Constance.secondaryColor
                              : Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                          child: Center(
                            child: Text(
                              'Offer',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: selected == 1
                                        ? Colors.black
                                        : Storage.instance.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                getBody(current),
              ],
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

  getBody(DataProvider current) {
    switch (selected) {
      case 0:
        return Column(children: [
          SizedBox(
            height: 2.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: Storage.instance.isDarkMode
                    ? Constance.secondaryColor
                    : Colors.black,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: SizedBox(
                  height: 5.h,
                  child: Text(
                    current.details?.address ??
                        'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                    // overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.phone,
                color: Storage.instance.isDarkMode
                    ? Constance.secondaryColor
                    : Colors.black,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: Text(
                  '+91${current.details?.mobile.toString() ?? '7838372617'}',
                  // overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 4.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: Storage.instance.isDarkMode
                          ? Constance.secondaryColor
                          : Colors.black,
                    ),
                  ],
                ),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Open Now',
                      // overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${current.details?.opening_time} - ${current.details?.closing_time}' ??
                          '',
                      // overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                // SizedBox(
                //   width: 45.w,
                //   child: Center(
                //     child: DropdownButton(
                //       isExpanded: false,
                //       // Initial Value
                //       value: dropdownvalue,
                //
                //       // Down Arrow Icon
                //       icon: const Icon(Icons.keyboard_arrow_down),
                //
                //       // Array list of items
                //       items: items.map((String items) {
                //         return DropdownMenuItem(
                //           value: items,
                //           child: Text(
                //             items,
                //             style:
                //                 Theme.of(context).textTheme.headline5?.copyWith(
                //                       color: Colors.black,
                //                       // fontWeight: FontWeight.bold,
                //                     ),
                //           ),
                //         );
                //       }).toList(),
                //       // After selecting the desired option,it will
                //       // change button value to selected value
                //       onChanged: (String? newValue) {
                //         setState(() {
                //           dropdownvalue = newValue!;
                //         });
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                FontAwesomeIcons.clipboard,
                color: Storage.instance.isDarkMode
                    ? Constance.secondaryColor
                    : Colors.black,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: SizedBox(
                  height: 5.h,
                  child: Text(
                    current.details?.services ??
                        'Tanning Salon . Beauty Supply Shop . Hair Salon',
                    // overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ]);
      default:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: current.details?.coupons?.length ?? 0,
            itemBuilder: (cont, count) {
              var data = current.details?.coupons![count];
              return ListTile(
                title: SizedBox(
                  width: 45.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.title ?? "",
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Constance.thirdColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data?.description ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
                trailing: CustomButton(
                  color: (data?.is_used ?? false)
                      ? Colors.grey
                      : Constance.secondaryColor,
                  txt: (data?.is_used ?? false) ? 'Redeemed' : '   Redeem   ',
                  fcolor:
                      (data?.is_used ?? false) ? Colors.white : Colors.black,
                  onTap: () {
                    if (data?.is_used ?? false) {
                      redeem(widget.id, data?.code);
                    } else {
                      showDialogBox(data?.code);
                    }
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 2.h,
                child: Center(
                  child: Divider(
                    thickness: 0.1.h,
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
        );
    }
  }

  void showDialogBox(code) {
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
                SizedBox(height: 1.h),
                Text(
                  'Do you really want to redeem the offer?',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Constance.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 2.h),
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
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                        redeem(widget.id, code);
                      }),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Cancel',
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

  void redeem(int id, String? code) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.redeemCupon(id, code);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setRedeemDetails(response.details!);
      fetchHistory();
      final response1 = await ApiProvider.instance.getDealDetails(widget.id);
      if (response1.success ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setDealDetails(response1.details!);
        // Navigation.instance.goBack();
        // _refreshController.refreshCompleted();
      }
      Navigation.instance.navigate('/redeemOfferPage');
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
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

  void fetchDetails() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getDealDetails(widget.id);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setDealDetails(response.details!);
      Navigation.instance.goBack();
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
      Navigation.instance.goBack();
    }
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
