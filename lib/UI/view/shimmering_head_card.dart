import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmeringHeadCard extends StatelessWidget {
  const ShimmeringHeadCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 37.h,
      child: Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Colors.grey.shade300,
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star,
                    color: Colors.grey.shade100),
                SizedBox(
                  width: 4.w,
                ),
                Container(
                  width: 20.w,
                  height: 1.5.h,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              width: 85.w,
              height: 23.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Container(
              width: 70.w,
              height: 1.5.h,
              color: Colors.grey.shade100,
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              width: 50.w,
              height: 1.5.h,
              color: Colors.grey.shade100,
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Colors.grey.shade100,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Container(
                  width: 20.w,
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