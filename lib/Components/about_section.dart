import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class aboutSection extends StatelessWidget {
  const aboutSection({
    Key? key, required this.onTap,
  }) : super(key: key);
  final Function(String) onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            child: InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.h,
              onTap: () {
                onTap("about_us");
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
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(
                      color: Colors.white,
                      // fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 1.5.h,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            child: InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.h,
              onTap: () {
                onTap("contact_us");
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
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(
                      color: Colors.white,
                      // fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 1.5.h,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            child: InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.h,
              onTap: () {
                onTap("privacy_policy");
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
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(
                      color: Colors.white,
                      // fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            child: InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.h,
              onTap: () {
                onTap("refund_policy");
                Navigation.instance.navigate('/refundPolicy');
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.policy,
                    color: Constance.secondaryColor,
                    // size: 2.h,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    'Refund Policy',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(
                      color: Colors.white,
                      // fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            child: InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.h,
              onTap: () {
                onTap("terms_and_conditions");
                Navigation.instance.navigate('/termsConditions');
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.policy,
                    color: Constance.secondaryColor,
                    // size: 2.h,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    'Terms and Conditions',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(
                      color: Colors.white,
                      // fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 1.5.h,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            child: InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.h,
              onTap: () {
                onTap("grieveance_redressal");
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
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(
                      color: Colors.white,
                      // fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 1.5.h,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.4.h),
            child: InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.h,
              onTap: () {
                onTap("advertise_with_us");
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
                    'Advertise With Us',
                    // 'AD with us',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(
                      color: Colors.white,
                      // fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}