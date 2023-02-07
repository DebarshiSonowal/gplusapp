import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Model/promoted_deal.dart';

class PromotedDealItemData extends StatelessWidget {
  const PromotedDealItemData({
    Key? key,
    required this.data,
  }) : super(key: key);

  final PromotedDeal data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 4.w, vertical: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 50.w,
                child: Text(
                  data.vendor?.shop_name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // SizedBox(
              //   height: 0.5.h,
              // ),
              SizedBox(
                width: 50.w,
                child: Text(
                  data.vendor?.address ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold
                  ),
                ),
              ),
              // SizedBox(
              //   height: 0.5.h,
              // ),
            ],
          ),
        ));
  }
}