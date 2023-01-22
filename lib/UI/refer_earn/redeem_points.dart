import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class RedeemPoints extends StatefulWidget {
  const RedeemPoints({Key? key}) : super(key: key);

  @override
  State<RedeemPoints> createState() => _RedeemPointsState();
}

class _RedeemPointsState extends State<RedeemPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      appBar: Constance.buildAppBar(),
      body: Consumer<DataProvider>(builder: (context, data, _) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
            horizontal: 7.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
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
                        '${data.referEarn?.coin_balance ?? 0}',
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
                Card(
                  color: Constance.primaryColor,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      // color: Color(0xff001f34),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7.0),
                        bottomRight: Radius.circular(7.0),
                        topLeft: Radius.circular(7.0),
                        bottomLeft: Radius.circular(7.0),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Redeem points',
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
                        SizedBox(
                          height: 1.h,
                        ),
                        Divider(
                          color: Constance.secondaryColor,
                          thickness: 0.1.h,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (cont, count) {
                            var current = data.referEarn?.plans[count];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      current?.name ?? '1 Month Subscription',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                            color: Colors.white,
                                            // fontSize: 11.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      '${current?.buying_points ?? 50} points',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                            color: Colors.white,
                                            // fontSize: 11.sp,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                CustomButton(
                                    txt: 'Spend Coin',
                                    onTap: () {
                                      confirm_Redeem(current?.id);
                                    }),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 1.h,
                                ),
                                Divider(
                                  color: Constance.secondaryColor,
                                  thickness: 0.1.h,
                                ),
                              ],
                            );
                          },
                          itemCount: data.referEarn?.plans.length ?? 0,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Card(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.all(0.2.h),
                    color: Storage.instance.isDarkMode
                        ? Colors.black
                        : Colors.white,
                    child: ExpansionTile(
                      collapsedIconColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      iconColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      title: Text(
                        'History',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline3
                            ?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              // fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: Theme.of(Navigation.instance
                                                  .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                color:
                                                    Storage.instance.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                // fontSize: 11.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          '${current.is_credit == 1 ? '+' : '-'}${current.points ?? '250'} points',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(Navigation.instance
                                                  .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                color: current.is_credit == 1
                                                    ? Colors.green
                                                    : Constance.thirdColor,
                                                // fontSize: 11.sp,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      Jiffy(current.updated_at, "yyyy-MM-dd")
                                          .format("dd/MM/yyyy"),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Constance.secondaryColor,
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
          ),
        );
      }),
    );
  }

  void confirm_Redeem(id) {
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
            'Hello ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context).profile?.name}',
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
                Text(
                  'Do you really want to spend coins?',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Constance.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .redeem ??
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
                // Text(
                //   'is simply dummy text of the printing and typesetting industry',
                //   style: Theme.of(context).textTheme.headline5?.copyWith(
                //         color: Colors.black,
                //         // fontWeight: FontWeight.bold,
                //       ),
                // ),
                // SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                        redeemByCoin(id);
                      }),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      Navigation.instance.goBack();
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white,
                            fontSize: 14.5.sp,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void success() {
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
            'Congratulations',
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
                SizedBox(height: 1.h),
                Text(
                  'You have just become a member for a month by spending 250 coins',
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
    Future.delayed(Duration.zero, () => fetchReferEarn());
  }

  void redeemByCoin(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.createOrder(
      id,
      1,
      Provider.of<DataProvider>(context, listen: false).profile?.name!,
      Provider.of<DataProvider>(context, listen: false).profile?.email!,
      Provider.of<DataProvider>(context, listen: false).profile?.mobile!,
      Platform.isAndroid?"android":"ios",
    );
    if (response.success ?? false) {
      Navigation.instance.goBack();
      success();
    } else {
      Navigation.instance.goBack();
      showError("Something went wrong");
    }
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

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }
}
