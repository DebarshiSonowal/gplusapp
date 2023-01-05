import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class ReferAndEarn extends StatefulWidget {
  const ReferAndEarn({Key? key}) : super(key: key);

  @override
  State<ReferAndEarn> createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      appBar: Constance.buildAppBar(),
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
                            'Refers & Earn',
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
                        Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .refer_earn ??
                            'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution',
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
                                data.referEarn?.referral_link ??
                                    'https://guwahatiplus.com/topic/bollywood',
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
                                        text: data.referEarn?.referral_link
                                                ?.split('/')[3] ??
                                            'https://guwahatiplus.com/topic/bollywood'))
                                    .then((_) {
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
                                "Hello I welcome you to G Plus. Join me and download their app using my referral code ${data.referEarn?.referral_link?.split('/')[3]}");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Card(
                        color: Color(0xff001f34),
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
                                    '${data.referEarn?.subscriber_added_point ?? '50'} points',
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
                                    'added per subscriber added',
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
                                          '${current?.base_price?.toInt() ?? 0} points',
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
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 4.w, vertical: 1.h),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         '500 points',
                            //         overflow: TextOverflow.ellipsis,
                            //         textAlign: TextAlign.start,
                            //         style: Theme.of(Navigation.instance
                            //                 .navigatorKey.currentContext!)
                            //             .textTheme
                            //             .headline4
                            //             ?.copyWith(
                            //               color: Colors.white,
                            //               // fontSize: 11.sp,
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //       ),
                            //       Text(
                            //         '2 month',
                            //         overflow: TextOverflow.ellipsis,
                            //         textAlign: TextAlign.start,
                            //         style: Theme.of(Navigation.instance
                            //                 .navigatorKey.currentContext!)
                            //             .textTheme
                            //             .headline4
                            //             ?.copyWith(
                            //               color: Colors.white,
                            //               // fontSize: 11.sp,
                            //               // fontWeight: FontWeight.bold,
                            //             ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 4.w, vertical: 1.h),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         '1000 points',
                            //         overflow: TextOverflow.ellipsis,
                            //         textAlign: TextAlign.start,
                            //         style: Theme.of(Navigation.instance
                            //                 .navigatorKey.currentContext!)
                            //             .textTheme
                            //             .headline4
                            //             ?.copyWith(
                            //               color: Colors.white,
                            //               // fontSize: 11.sp,
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //       ),
                            //       Text(
                            //         '7 month',
                            //         overflow: TextOverflow.ellipsis,
                            //         textAlign: TextAlign.start,
                            //         style: Theme.of(Navigation.instance
                            //                 .navigatorKey.currentContext!)
                            //             .textTheme
                            //             .headline4
                            //             ?.copyWith(
                            //               color: Colors.white,
                            //               // fontSize: 11.sp,
                            //               // fontWeight: FontWeight.bold,
                            //             ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
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
                            ListView.separated(
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
                                            Text(
                                              current.is_subscription == 1
                                                  ? 'Redeem for subscription'
                                                  : 'Referral',
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              '${current.points ?? '250'} points',
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
                                        const Spacer(),
                                        Text(
                                          Jiffy(current.updated_at,
                                                  "yyyy-MM-dd")
                                              .format("dd/MM/yyyy"),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(Navigation.instance
                                                  .navigatorKey.currentContext!)
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
                                itemCount: data.referHistory.length),
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
    Future.delayed(Duration.zero, () {
      fetchReferEarn();
      fetchHistory();
    });
  }

  void fetchReferEarn() async {
    Navigation.instance.navigate('/loadingDialog');
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

  void fetchHistory() async {
    final response = await ApiProvider.instance.fetchReferEarnHistory();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setReferEarnHistory(response.history);
    } else {}
  }
}
