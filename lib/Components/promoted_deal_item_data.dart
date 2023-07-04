import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/promoted_deal.dart';

class PromotedDealItemData extends StatelessWidget {
  const PromotedDealItemData({
    Key? key,
    required this.data,
  }) : super(key: key);

  final PromotedDeal data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 8.5.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40.w,
                child: Text(
                  data.vendor?.shop_name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          // flex: 1,
          child: Container(
            height: 8.5.h,
            padding: EdgeInsets.symmetric(
              vertical: 0.3.h,
              horizontal: 1.w,
            ),
            // width: 20.w,
            // height: 8.5.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                // topRight: Radius.circular(
                //   10.0,
                // ),
                bottomRight: Radius.circular(
                  10.0,
                ),
                // topLeft: Radius.circular(
                //   10.0,
                // ),
                // bottomLeft: Radius.circular(
                //   10.0,
                // ),
              ),
              color: Constance.thirdColor,
            ),
            child: Center(
              child: Text(
                data.title ?? "",
                // "fzcficvadqlltdvzfoqcwakpuqahtixfwrxfwdvlkxelkukvmtkppskxsnbftvwcawheivqjenbxnrgz",
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                // ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
