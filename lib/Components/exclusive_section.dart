import 'package:flutter/material.dart';
import 'package:gplusapp/Components/video_section_menu.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';
import 'buzz_section.dart';

class ExclusiveSection extends StatelessWidget {
  const ExclusiveSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                // const Icon(
                //   Icons.star,
                //   color: Constance.secondaryColor,
                // ),
                Image.asset(
                  Constance.exclusiveIcon,
                  color: Constance.secondaryColor,
                  scale: 20,
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  'G Plus Exclusive',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
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
            height: 1.2.h,
          ),
          const BuzzSection(),
          SizedBox(
            height: 1.2.h,
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
                  style: Theme.of(context).textTheme.headline4?.copyWith(
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
            height: 1.2.h,
          ),
          const VideoSectionMenu(),
        ],
      ),
    );
  }
}