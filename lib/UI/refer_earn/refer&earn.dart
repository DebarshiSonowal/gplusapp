import 'dart:io';

import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Helper/string_extension.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentLength = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      // appBar: Constance.buildAppBar("redeem_offer", true, _scaffoldKey),
      appBar: Constance.buildAppBar2("redeem_offer"),
      // drawer: const BergerMenuMemPage(
      //   screen: "redeem_offer",
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 2.h,
          horizontal: 7.w,
        ),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return data.referEarn == null
              ? Container()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.h),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Constance.primaryColor,
                            ),
                            child: const Icon(
                              Icons.announcement,
                              color: Constance.secondaryColor,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            'Refer & Earn',
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline1
                                ?.copyWith(
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Constance.primaryColor,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        decoration: const BoxDecoration(
                          color: Color(0xff001f34),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0),
                            topLeft: Radius.circular(7.0),
                            bottomLeft: Radius.circular(7.0),
                          ),
                        ),
                        width: double.infinity,
                        height: 7.h,
                        child: Row(
                          children: [
                            Icon(
                              Icons.wallet,
                              color: Constance.secondaryColor,
                              size: 4.h,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              'Coin Balance',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 11.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              '${data.referEarn?.coin_balance ?? '100000'}',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        height: 5.h,
                        width: double.infinity,
                        child: CustomButton(
                          txt: 'Redeem Coin',
                          onTap: () {
                            Navigation.instance.navigate('/redeemPoints');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'Hi ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile!.name!.capitalize()}!\n\n${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).refer_earn}',
                        style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline5
                            ?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              // fontSize: 11.sp,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        decoration: BoxDecoration(
                          // color: Color(0xff001f34),
                          border: Border.all(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black26,
                          ),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0),
                            topLeft: Radius.circular(7.0),
                            bottomLeft: Radius.circular(7.0),
                          ),
                        ),
                        width: double.infinity,
                        height: 5.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 70.w,
                              child: Text(
                                data.referEarn!.code!,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      // fontSize: 11.sp,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                  text: data.referEarn!.code!,
                                )).then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Copied to your clipboard !'),
                                    ),
                                  );
                                });
                              },
                              child: Icon(
                                Icons.copy,
                                color: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        height: 5.h,
                        width: double.infinity,
                        child: CustomButton(
                          txt: 'Send invite',
                          onTap: () {
                            Share.share(
                                // "Hello I welcome you to G Plus. Join me and download their app using my referral code ${data.referEarn?.referral_link?.split('/')[3]}",
                                "${data.invite} \"${data.referEarn?.code}\" \n ${data.referEarn?.referral_link}");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Card(
                        color: const Color(0xff001f34),
                        child: ExpansionTile(
                          title: Text(
                            'Offer Details',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline3
                                ?.copyWith(
                                  color: Colors.white,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              child: Row(
                                children: [
                                  Text(
                                    'Redeem for subscription',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(Navigation.instance
                                            .navigatorKey.currentContext!)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                          color: Colors.white,
                                          // fontSize: 11.sp,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                color: Constance.secondaryColor,
                                thickness: 0.1.h,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 0.5.h),
                              child: Row(
                                children: [
                                  Text(
                                    '${data.referEarn?.subscriber_added_point ?? '0'} points',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(Navigation.instance
                                            .navigatorKey.currentContext!)
                                        .textTheme
                                        .headline2
                                        ?.copyWith(
                                          color: Colors.white,
                                          // fontSize: 11.sp,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              child: Row(
                                children: [
                                  Text(
                                    'added per subscriber',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(Navigation.instance
                                            .navigatorKey.currentContext!)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                          color: Colors.white,
                                          // fontSize: 11.sp,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                color: Constance.secondaryColor,
                                thickness: 0.1.h,
                              ),
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (cont, count) {
                                  var current = data.referEarn?.plans[count];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${current?.buying_points?.toInt() ?? 0} points',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(Navigation.instance
                                                  .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(
                                                color: Colors.white,
                                                // fontSize: 11.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          current?.duration ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(Navigation.instance
                                                  .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(
                                                color: Colors.white,
                                                // fontSize: 11.sp,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (cont, count) {
                                  return SizedBox(
                                    height: 2.h,
                                  );
                                },
                                itemCount: data.referEarn?.plans.length ?? 0),
                            SizedBox(
                              height: 1.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Card(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                color: Constance.secondaryColor,
                                thickness: 0.1.h,
                              ),
                            ),
                            data.referHistory.isNotEmpty
                                ? ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (cont, count) {
                                      var current = data.referHistory[count];
                                      return Padding(
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
                                                SizedBox(
                                                  width: 55.w,
                                                  child: Text(
                                                    current.title ?? "",
                                                    maxLines: 2,
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
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Text(
                                                  '${current.is_credit == 1 ? '+' : '-'}${current.points ?? '250'} points',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(Navigation
                                                          .instance
                                                          .navigatorKey
                                                          .currentContext!)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                        color:
                                                            current.is_credit ==
                                                                    1
                                                                ? Colors.green
                                                                : Constance
                                                                    .thirdColor,
                                                        // fontSize: 11.sp,
                                                        // fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              Jiffy.parse(
                                                      current.updated_at ?? "",
                                                      pattern: "yyyy-MM-dd")
                                                  .format(
                                                      pattern: "dd/MM/yyyy"),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: Theme.of(Navigation
                                                      .instance
                                                      .navigatorKey
                                                      .currentContext!)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                    color: Colors.black,
                                                    // fontSize: 11.sp,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (cont, count) {
                                      return SizedBox(
                                        height: 1.h,
                                      );
                                    },
                                    itemCount: currentLength,
                                  )
                                : Center(
                                    child: Text(
                                      data.refer_history_msg,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                              color: Constance.thirdColor),
                                    ),
                                  ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                color: Constance.secondaryColor,
                                thickness: 0.1.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              child: GestureDetector(
                                onTap: () {
                                  if (currentLength * 2 <=
                                      data.referHistory.length) {
                                    setState(() {
                                      currentLength = currentLength * 2;
                                    });
                                  }
                                },
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
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        }),
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
            return bd.Badge(
              // badgeColor: Constance.secondaryColor,
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
            Navigation.instance.navigate('/search', args: "");
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      Navigation.instance.navigate('/loadingDialog');
      await fetchHistory();
      await fetchReferEarn();
    });
  }

  Future<void> fetchReferEarn() async {
    final response = await ApiProvider.instance.getReferAndEarn();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setReferEarn(response.data!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  Future<void> fetchHistory() async {
    final response = await ApiProvider.instance.fetchReferEarnHistory();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setReferEarnHistory(
              response.history, response.empty!, response.invite!);
      setState(() {
        currentLength = Provider.of<DataProvider>(context, listen: false)
            .referHistory
            .length;
      });
    } else {}
  }

  getStoreLink() {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? 'com.appbazooka.gplus' : '6444875975';
      final url = Uri.parse(
        Platform.isAndroid
            ? "https://play.google.com/store/apps/details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      return url;
    }
  }
}
