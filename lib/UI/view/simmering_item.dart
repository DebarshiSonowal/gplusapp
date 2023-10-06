import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmeringItem extends StatelessWidget {
  const ShimmeringItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20.h,
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey.shade300,
        enabled: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 45.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 35.w,
                  height: 1.5.h,
                  color: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  width: 28.w,
                  height: 1.5.h,
                  color: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  width: 22.w,
                  height: 1.5.h,
                  color: Colors.grey.shade100,
                ),
                const Spacer(),
                Container(
                  width: 20.w,
                  height: 1.5.h,
                  color: Colors.grey.shade100,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  width: 15.w,
                  height: 1.5.h,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}