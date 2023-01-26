import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          SizedBox(
            height: 1.5.h,
          ),
          GestureDetector(
            onTap: () {
              Navigation.instance.navigate('/blockedUsers');
            },
            child: Row(
              children: [
                Icon(
                  Icons.block,
                  color: Constance.secondaryColor,
                  size: 2.5.h,
                ),
                SizedBox(
                  width: 3.5.w,
                ),
                Text(
                  'Blocked User List',
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
    );
  }
}