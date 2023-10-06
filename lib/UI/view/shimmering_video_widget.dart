import 'package:flutter/material.dart';
import 'package:gplusapp/UI/view/simmering_item.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmeringVideoWidget extends StatelessWidget {
  const ShimmeringVideoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90.h,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            width: double.infinity,
            height: 30.h,
            // color: Colors.grey.shade100,
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.grey.shade300,
              enabled: true,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Container(
                    width: 30.w,
                    height: 4.h,
                    color: Colors.grey.shade100,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    width: 85.w,
                    height: 2.h,
                    color: Colors.grey.shade100,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    width: 50.w,
                    height: 2.h,
                    color: Colors.grey.shade100,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    width: 20.w,
                    height: 2.h,
                    color: Colors.grey.shade100,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Divider(
            thickness: 0.3.h,
            color: Colors.grey.shade300,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            child: const ShimmeringItem(),
          ),
          Divider(
            thickness: 0.3.h,
            color: Colors.grey.shade200,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
            ),
            child: const ShimmeringItem(),
          ),
          Divider(
            thickness: 0.3.h,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}