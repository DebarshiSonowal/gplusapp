import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Helper/Constance.dart';

class BergerMenuMemPage extends StatefulWidget {
  const BergerMenuMemPage({Key? key}) : super(key: key);

  @override
  State<BergerMenuMemPage> createState() => _BergerMenuMemPageState();
}

class _BergerMenuMemPageState extends State<BergerMenuMemPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return Drawer(
        backgroundColor:
            Storage.instance.isDarkMode ? Colors.black : Constance.forthColor,
        child: Padding(
          padding: EdgeInsets.only(left: 2.w, right: 2.w),
          child: ListView(
            children: [
              DrawerHeader(
                child: SizedBox(
                  height: 12.5.h,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.profile?.f_name ?? 'Jonathan Doe',
                        style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
                            .textTheme
                            .subtitle2
                            ?.copyWith(
                              color: Colors.white,
                              // fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Text(
                            '+91 ${data.profile?.mobile ?? 'XXXXXXXXXX'}',
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                  color: Colors.white,
                                  // fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(
                            width: 1.5.w,
                          ),
                          // GestureDetector(
                          //
                          //   child: Text(
                          //     'Change',
                          //     style: Theme.of(Navigation
                          //             .instance.navigatorKey.currentContext!)
                          //         .textTheme
                          //         .headline6
                          //         ?.copyWith(
                          //           color: Constance.secondaryColor,
                          //           fontSize: 11.sp,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigation.instance.navigate('/editProfile');
                        },
                        child: Text(
                          'View Profile',
                          style: Theme.of(Navigation
                                  .instance.navigatorKey.currentContext!)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                color: Constance.secondaryColor,
                                fontSize: 11.sp,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              SizedBox(
                // height: 10.h,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigation.instance.navigate('/main');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Constance.secondaryColor,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            'Location',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 19.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigation.instance
                            .navigate('/editSavedAddresses', args: 1);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8.w,
                          ),
                          SizedBox(
                            width: 45.w,
                            child: Text(
                              data.profile?.addresses
                                          .where((element) =>
                                              element.is_primary == 1)
                                          .isEmpty ??
                                      false
                                  ? ""
                                  : data.profile?.addresses
                                          .where((element) =>
                                              element.is_primary == 1)
                                          .first
                                          .address ??
                                      '',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: EdgeInsets.all(0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        const Icon(
                          Icons.backpack,
                          color: Constance.secondaryColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'News from',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 19.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 3.h,
                        ),
                      ],
                    ),
                    trailing: Container(
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    children: [
                      InkWell(
                        splashColor: Constance.secondaryColor,
                        radius: 15.w,
                        onTap: () {
                          Navigation.instance
                              .navigate('/newsfrom', args: 'guwahati');
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Guwahati',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: 6,
                              width: 6,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      InkWell(
                        splashColor: Constance.secondaryColor,
                        radius: 15.w,
                        onTap: () {
                          Navigation.instance
                              .navigate('/newsfrom', args: 'assam');
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Assam',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: 6,
                              width: 6,
                              decoration: const BoxDecoration(
                                // color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      InkWell(
                        splashColor: Constance.secondaryColor,
                        radius: 15.w,
                        onTap: () {
                          Navigation.instance
                              .navigate('/newsfrom', args: 'northeast');
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'Northeast',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: 6,
                              width: 6,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      InkWell(
                        splashColor: Constance.secondaryColor,
                        radius: 15.w,
                        onTap: () {
                          Navigation.instance
                              .navigate('/newsfrom', args: 'india');
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'India',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: 6,
                              width: 6,
                              decoration: const BoxDecoration(
                                // color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      InkWell(
                        splashColor: Constance.secondaryColor,
                        radius: 15.w,
                        onTap: () {
                          Navigation.instance
                              .navigate('/newsfrom', args: 'international');
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              'International',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              height: 6,
                              width: 6,
                              decoration: const BoxDecoration(
                                // color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              Container(
                // height: 30.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: Constance.secondaryColor,
                      radius: 5.h,
                      onTap: () {
                        Navigation.instance.navigate('/exclusivePage');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Constance.secondaryColor,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            'G Plus Exclusive',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            height: 6,
                            width: 6,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      // height: 8.h,
                      child: ListTileTheme(
                        contentPadding: EdgeInsets.all(0),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              const Icon(
                                Icons.backpack,
                                color: Constance.secondaryColor,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                'Buzz',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 3.h,
                              ),
                            ],
                          ),
                          trailing: Container(
                            height: 6,
                            width: 6,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          children: [
                            InkWell(
                              splashColor: Constance.secondaryColor,
                              radius: 15.h,
                              onTap: () {
                                Navigation.instance.navigate('/newsfrom',
                                    args: 'entertainment');
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Entertainment',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                      // color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            InkWell(
                              splashColor: Constance.secondaryColor,
                              radius: 15.h,
                              onTap: () {
                                Navigation.instance
                                    .navigate('/newsfrom', args: 'buzz');
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Featured',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                      // color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    InkWell(
                      splashColor: Constance.secondaryColor,
                      radius: 15.h,
                      onTap: () {
                        Navigation.instance.navigate('/opinionPage');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.message,
                            color: Constance.secondaryColor,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            'Opinion',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            height: 6,
                            width: 6,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ListTileTheme(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              const Icon(
                                Icons.video_call,
                                color: Constance.secondaryColor,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                'Video Reports',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 3.h,
                              ),
                            ],
                          ),
                          trailing: Container(
                            height: 6,
                            width: 6,
                            decoration: const BoxDecoration(
                              // color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          children: [
                            SizedBox(
                              height: 1.5.h,
                            ),
                            InkWell(
                              splashColor: Constance.secondaryColor,
                              radius: 15.h,
                              onTap: () {
                                Navigation.instance
                                    .navigate('/videoReport', args: 'news');
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'News',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                      // color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            InkWell(
                              splashColor: Constance.secondaryColor,
                              radius: 15.h,
                              onTap: () {
                                Navigation.instance
                                    .navigate('/videoReport', args: 'featured');
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Features',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                      // color: Colors.red,
                                      shape: BoxShape.circle,
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
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0.h),
                child: GestureDetector(
                  onTap: () {
                    if (Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .profile
                            ?.is_plan_active ??
                        false) {
                      Navigation.instance.navigate('/bookmarks');
                      // showError("Oops! You are not a member yet");
                    } else {
                      showError("Oops! You are not a member yet");
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bookmark,
                        color: Constance.secondaryColor,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'Bookmarks',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.white,
                              // fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              InkWell(
                splashColor: Constance.secondaryColor,
                radius: 15.h,
                onTap: () {
                  if (Provider.of<DataProvider>(
                              Navigation.instance.navigatorKey.currentContext ??
                                  context,
                              listen: false)
                          .profile
                          ?.is_plan_active ??
                      false) {
                    downloadEpaper();
                    // showError("Oops! You are not a member yet");
                  } else {
                    showError("Oops! You are not a member yet");
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.download,
                        color: Constance.secondaryColor,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'Download E-Paper',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.white,
                              // fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              InkWell(
                splashColor: Constance.secondaryColor,
                radius: 15.h,
                onTap: () {
                  if (data.profile?.is_plan_active ?? false) {
                    Navigation.instance.navigate('/profile');
                  } else {
                    Navigation.instance.navigate('/beamember');
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.user,
                        color: Constance.secondaryColor,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        (data.profile?.is_plan_active ?? false)
                            ? 'Membership Info'
                            : 'Be a member',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Constance.secondaryColor,
                              // fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0.h),
                child: InkWell(
                  splashColor: Constance.secondaryColor,
                  radius: 15.h,
                  onTap: () {
                    Navigation.instance.navigate('/refer&earn');
                  },
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.indianRupeeSign,
                        color: Constance.secondaryColor,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'Refer and Earn',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.white,
                              // fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: Constance.secondaryColor,
                      radius: 15.h,
                      onTap: () {
                        Navigation.instance.navigate('/aboutUs');
                      },
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.users,
                            color: Constance.secondaryColor,
                            size: 2.5.h,
                          ),
                          SizedBox(
                            width: 3.5.w,
                          ),
                          Text(
                            'About Us',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    InkWell(
                      splashColor: Constance.secondaryColor,
                      radius: 15.h,
                      onTap: () {
                        Navigation.instance.navigate('/contactUs');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Constance.secondaryColor,
                            // size: 2.h,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            'Contact Us',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    InkWell(
                      splashColor: Constance.secondaryColor,
                      radius: 15.h,
                      onTap: () {
                        Navigation.instance.navigate('/privacy');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock,
                            color: Constance.secondaryColor,
                            // size: 2.h,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            'Privacy Policy',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    InkWell(
                      splashColor: Constance.secondaryColor,
                      radius: 15.h,
                      onTap: () {
                        Navigation.instance.navigate('/grieveanceRedressal');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone_android,
                            color: Constance.secondaryColor,
                            // size: 2.h,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            'Grievance Redressal',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    InkWell(
                      splashColor: Constance.secondaryColor,
                      radius: 15.h,
                      onTap: () {
                        Navigation.instance.navigate('/advertiseWithUs');
                      },
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.ad,
                            color: Constance.secondaryColor,
                            size: 2.5.h,
                          ),
                          SizedBox(
                            width: 3.5.w,
                          ),
                          Text(
                            'Advertise with us',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigation.instance.navigate('/settingsPage');
                      },
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.gear,
                            color: Constance.secondaryColor,
                            size: 2.5.h,
                          ),
                          SizedBox(
                            width: 3.5.w,
                          ),
                          Text(
                            'Settings',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 1.5.h,
                    // ),
                    // InkWell(
                    //   splashColor: Constance.secondaryColor,
                    //   radius: 15.h,
                    //   onTap: () async {
                    //     final FirebaseAuth _auth = FirebaseAuth.instance;
                    //     await _auth.signOut();
                    //     Storage.instance.logout();
                    //     Navigation.instance.navigateAndRemoveUntil('/login');
                    //   },
                    //   child: Row(
                    //     children: [
                    //       const Icon(
                    //         Icons.exit_to_app,
                    //         color: Constance.secondaryColor,
                    //         // size: 2.h,
                    //       ),
                    //       SizedBox(
                    //         width: 2.w,
                    //       ),
                    //       Text(
                    //         'Logout',
                    //         style:
                    //             Theme.of(context).textTheme.headline4?.copyWith(
                    //                   color: Colors.white,
                    //                   // fontSize: 14.sp,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
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
    );
  }

  void downloadEpaper() async {
    showLoaderDialog(context);
    final response = await ApiProvider.instance.getEpaper();
    if (response.success ?? false) {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        if (await Permission.storage.request().isGranted) {
          await ApiProvider.instance
              .download2(response.e_paper?.news_pdf ?? "");
        } else {
          showError("We require storage permissions");
        }
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
      } else {
        await ApiProvider.instance.download2(response.e_paper?.news_pdf ?? "");
      }
    } else {
      showError("Failed to download E-paper");
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        color: Colors.white,
        child: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(
                "Loading...",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Not Subscribed",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }
}
