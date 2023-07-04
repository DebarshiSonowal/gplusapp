import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class ReferAndEarnSection extends StatelessWidget {
  const ReferAndEarnSection({
    Key? key, required this.onTap,
  }) : super(key: key);
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              'Refers and Earn',
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
    );
  }
}