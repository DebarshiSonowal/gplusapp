import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              onTap("settings");
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
                  style: Theme.of(context).textTheme.headline4?.copyWith(
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
              onTap("blocked_user");
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
                  style: Theme.of(context).textTheme.headline4?.copyWith(
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
        ],
      ),
    );
  }
}
