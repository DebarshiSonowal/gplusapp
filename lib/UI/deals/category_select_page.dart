import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Model/profile.dart';
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("bigdeal"),
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
            return SingleChildScrollView(
              child: Column(
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
                        height: 27.h,
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
                            decoration: BoxDecoration(
                              color: selected == 0
                                  ? Constance.secondaryColor
                                  : Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                              // borderRadius: BorderRadius.circular(),
                              borderRadius: const BorderRadius.only(
                                // topRight: Radius.circular(5.0),
                                // bottomRight: Radius.circular(5.0),
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0),
                              ),
                            ),
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
                            decoration: BoxDecoration(
                              color: selected == 1
                                  ? Constance.secondaryColor
                                  : Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                              // borderRadius: BorderRadius.circular(),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                // topLeft: Radius.circular(40.0),
                                // bottomLeft: Radius.circular(40.0),
                              ),
                            ),
                            height: 5.h,
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
                  SizedBox(height: 7.h,),
                ],
              ),
            );
          }),
        ),
      ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  // height: 5.h,
                  child: Text(
                    current.details?.address ??
                        'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline4?.copyWith(
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
          GestureDetector(
            onTap: () {
              _launchUrl(Uri.parse('tel:${current.details?.mobile}'));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
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
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 4.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
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
                    // Text(
                    //   openStatus(current.details!.opening_time!,
                    //       current.details!.closing_time!),
                    //   // ? "Open Now"
                    //   // : "Closed Now",
                    //   // openStatus(
                    //   //     TimeFromString(
                    //   //         current.details?.opening_time ?? "10AM"),
                    //   //     TimeFromString(
                    //   //         current.details?.closing_time ?? "11PM"),
                    //   // ),
                    //   // overflow: TextOverflow.clip,
                    //   style: Theme.of(context).textTheme.headline4?.copyWith(
                    //         color: Storage.instance.isDarkMode
                    //             ? Colors.white
                    //             : Colors.black,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    // ),
                  ],
                ),
                // SizedBox(
                //   width: 4.w,
                // ),
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
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
                child: Text(
                  current.details?.services ??
                      'Tanning Salon . Beauty Supply Shop . Hair Salon',
                  // overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
              ),
            ],
          ),
        ]);
      default:
        return Container(
          // height: 58.h,
          // height: double.infinity,
          margin: EdgeInsets.only(bottom:5.h),
          padding: EdgeInsets.only(top:1.h),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
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
                        // overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Constance.thirdColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Text(
                        data?.description ?? "",
                        maxLines: 8,
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
                      showDialogBox(data?.code, current.redeem);
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

  void showDialogBox(code, msg) {
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
                  msg ??
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
      logTheRedeemOfferClick(Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .profile!);
      Navigation.instance.navigate('/redeemOfferPage');
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }

  void logTheRedeemOfferClick(
    Profile profile,
    // String sort_applied,
  ) async {
    debugPrint("LOGGING OFFER");
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "redeem_offer",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "sort_applied": sort_applied,
        "screen_name": "redeem_offer",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
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

  String openStatus(opening, closing) {
    var open = TimeOfDay.fromDateTime(DateFormat("HH:mm a").parse(opening));
    var openTime = open.hour * 60 + open.minute;
    var close = TimeOfDay.fromDateTime(DateFormat("HH:mm a").parse(closing));
    var closeTime = close.hour * 60 + close.minute;
    var current = TimeOfDay.fromDateTime(DateTime.now());
    var currentTime = current.hour * 60 + current.minute;
    if (currentTime >= openTime && currentTime <= closeTime) {
      return "Open Now";
    }
    // debugPrint(
    //     "AP ${currentTime} ${DateFormat("HH:mm a").parse(currentTime).isAfter(DateFormat("HH:mm a").parse(opening))} ${DateFormat("HH:mm a").parse(currentTime).isBefore(DateFormat("HH:mm a").parse(closing))}");
    // if ((DateFormat("HH:mm a")
    //         .parse(currentTime)
    //         .isAfter(DateFormat("HH:mm a").parse(opening))) &&
    //     DateFormat("HH:mm a")
    //         .parse(currentTime)
    //         .isBefore(DateFormat("HH:mm a").parse(closing))) {
    //   return 'Open Now';
    // } else {
    //   return 'Closed Now';
    // }
    return 'Closed Now';
  }

  TimeFromString(String closing_time) {
    print(
        "TIme ${DateFormat.jm().format(DateFormat("HH:mm a").parse(closing_time))}");
    return DateFormat.jm().format(DateFormat("HH:mm a").parse(closing_time));
  }

  bool checkRestaurentStatus(String openTime, String closedTime) {
    //NOTE: Time should be as given format only
    //10:00PM
    //10:00AM

    // 01:60PM ->13:60
    //Hrs:Min
    //if AM then its ok but if PM then? 12+time (12+10=22)
    debugPrint(
        " check IT ${openTime} ${closedTime} ${DateFormat("HH:mm a").format(DateTime.now())} ${TimeOfDay.now()}"
        " ${TimeOfDay.fromDateTime(DateFormat("HH:mm a").parse(openTime))} $openTime");
    TimeOfDay timeNow = TimeOfDay.now();
    String openHr = openTime.substring(0, 2);
    String openMin = openTime.substring(3, 5);
    String openAmPm = openTime.substring(5);
    TimeOfDay timeOpen;
    if (openAmPm == "AM") {
      //am case
      if (openHr == "12") {
        //if 12AM then time is 00
        timeOpen = TimeOfDay(hour: 00, minute: int.parse(openMin));
      } else {
        timeOpen =
            TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
      }
    } else {
      //pm case
      if (openHr == "12") {
//if 12PM means as it is
        timeOpen =
            TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
      } else {
//add +12 to conv time to 24hr format
        timeOpen =
            TimeOfDay(hour: int.parse(openHr) + 12, minute: int.parse(openMin));
      }
    }

    String closeHr = closedTime.substring(0, 2);
    String closeMin = closedTime.substring(3, 5);
    String closeAmPm = closedTime.substring(5);

    TimeOfDay timeClose;

    if (closeAmPm == "AM") {
      //am case
      if (closeHr == "12") {
        timeClose = TimeOfDay(hour: 0, minute: int.parse(closeMin));
      } else {
        timeClose =
            TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
      }
    } else {
      //pm case
      if (closeHr == "12") {
        timeClose =
            TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
      } else {
        timeClose = TimeOfDay(
            hour: int.parse(closeHr) + 12, minute: int.parse(closeMin));
      }
    }

    int nowInMinutes = timeNow.hour * 60 + timeNow.minute;
    int openTimeInMinutes = timeOpen.hour * 60 + timeOpen.minute;
    int closeTimeInMinutes = timeClose.hour * 60 + timeClose.minute;

//handling day change ie pm to am
    if ((closeTimeInMinutes - openTimeInMinutes) < 0) {
      closeTimeInMinutes = closeTimeInMinutes + 1440;
      if (nowInMinutes >= 0 && nowInMinutes < openTimeInMinutes) {
        nowInMinutes = nowInMinutes + 1440;
      }
      if (openTimeInMinutes < nowInMinutes &&
          nowInMinutes < closeTimeInMinutes) {
        return true;
      }
    } else if (openTimeInMinutes < nowInMinutes &&
        nowInMinutes < closeTimeInMinutes) {
      return true;
    }

    return false;
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
