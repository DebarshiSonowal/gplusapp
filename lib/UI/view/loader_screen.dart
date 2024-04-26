import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [

          Positioned(
            left: 0,
            bottom: 4.5.h,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.02)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.shade300,
                        enabled: true,
                        child: CircleAvatar(
                          radius: 7.5.w, // Image radius
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.shade300,
                        enabled: true,
                        child: Container(
                          color: Colors.grey.shade100,
                          child: Text(
                            "GPlus",
                            style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade100,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey.shade300,
                    enabled: true,
                    child: Container(
                      margin: EdgeInsets.only(left: 2.w, top: 2.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      padding: EdgeInsets.only(
                        top: 3.w,
                        left: 4.w,
                      ),
                      width: 85.w,
                      child: ReadMoreText(
                        'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                        trimLines: 2,
                        colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade100,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                        lessStyle:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 4.w,
            bottom: 4.5.h,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
              child: Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey.shade300,
                    enabled: true,
                    child: Icon(
                      Icons.heart_broken,
                      color: Colors.grey.shade100,
                      size: 10.w,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey.shade300,
                    enabled: true,
                    child: SizedBox(
                      height: 9.h,
                      child: Icon(
                        Icons.share,
                        size: 10.w,
                        color: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    height: 9.h,
                    child: Icon(
                      Icons.more_vert,
                      size: 10.w,
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