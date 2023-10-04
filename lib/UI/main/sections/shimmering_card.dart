import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmeringCard extends StatelessWidget {
  const ShimmeringCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4.w),
      width: 95.w,
      height: 18.h,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(
              width: 0.5,
              color: Colors.white,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 2.5.w, vertical: 1.5.h),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Colors.white,
            ),
            height: 16.h,
            width: MediaQuery.of(context).size.width - 10.w,
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey.shade400,
              enabled: true,
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        height: 1.h,
                        width: 40.w,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        color: Colors.grey.shade200,
                        height: 1.h,
                        width: 35.w,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        color: Colors.grey.shade200,
                        height: 1.h,
                        width: 25.w,
                      ),
                      const Spacer(),
                      Container(
                        color: Colors.grey.shade200,
                        height: 1.h,
                        width: 15.w,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        color: Colors.grey.shade200,
                        height: 1.h,
                        width: 20.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}