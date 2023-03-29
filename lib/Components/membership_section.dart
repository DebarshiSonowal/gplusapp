import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';

class MembershipSection extends StatelessWidget {
  const MembershipSection({
    Key? key,
    required this.data, required this.onTap,
  }) : super(key: key);
  final DataProvider data;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Constance.secondaryColor,
      radius: 15.h,
      onTap: () {
        onTap();
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
    );
  }
}