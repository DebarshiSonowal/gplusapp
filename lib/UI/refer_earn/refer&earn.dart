import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2.h,
          horizontal: 7.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.h),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Constance.primaryColor,
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
                    style: Theme.of(
                            Navigation.instance.navigatorKey.currentContext!)
                        .textTheme
                        .headline1
                        ?.copyWith(
                          color: Constance.primaryColor,
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
                      style: Theme.of(
                              Navigation.instance.navigatorKey.currentContext!)
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
                      '100000',
                      style: Theme.of(
                              Navigation.instance.navigatorKey.currentContext!)
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
                child: Expanded(
                  child: CustomButton(
                    txt: 'Redeem Coin',
                    onTap: () {
                      Navigation.instance.navigate('/redeemPoints');
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution',
                style:
                    Theme.of(Navigation.instance.navigatorKey.currentContext!)
                        .textTheme
                        .headline5
                        ?.copyWith(
                          color: Colors.black,
                          // fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                decoration: BoxDecoration(
                  // color: Color(0xff001f34),
                  border: Border.all(
                    color: Colors.black26,
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
                        'https://guwahatiplus.com/topic/bollywood',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline6
                            ?.copyWith(
                              color: Colors.black,
                              // fontSize: 11.sp,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const Icon(
                      Icons.copy,
                      color: Colors.black,
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
                child: Expanded(
                  child: CustomButton(
                    txt: 'Send to us',
                    onTap: () {},
                  ),
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
                    style: Theme.of(
                            Navigation.instance.navigatorKey.currentContext!)
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        children: [
                          Text(
                            'Redeem for subscription',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                            '50 points',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        children: [
                          Text(
                            'added per subscriber added',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(
                        color: Constance.secondaryColor,
                        thickness: 0.1.h,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '250 points',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                  color: Colors.white,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '1 month',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '500 points',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                  color: Colors.white,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '2 month',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1000 points',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                  color: Colors.white,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '7 month',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                    style: Theme.of(
                            Navigation.instance.navigatorKey.currentContext!)
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(
                        color: Constance.secondaryColor,
                        thickness: 0.1.h,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Redeem for subscription',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '250 points',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
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
                            '26-12-2022',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Redeem for subscription',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                  color: Colors.black,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '250 points',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                            '26-12-2022',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
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
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Redeem for subscription',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                  color: Colors.black,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '250 points',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                            '26-12-2022',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
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
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Redeem for subscription',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                  color: Colors.black,
                                  // fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '250 points',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
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
                            '26-12-2022',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
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
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(
                        color: Constance.secondaryColor,
                        thickness: 0.1.h,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
        ),
      ),
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
}