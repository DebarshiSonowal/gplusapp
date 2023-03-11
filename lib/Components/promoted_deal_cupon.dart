import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/promoted_deal.dart';

class PromotedDealItemCupon extends StatelessWidget {
  const PromotedDealItemCupon({
    Key? key,
    required this.data,
  }) : super(key: key);

  final PromotedDeal data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 1.w,
        bottom: 0.5.h,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 1.h,
        horizontal: 1.w,
      ),
      width: 30.w,
      height: 8.5.h,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            data.title ?? "",
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline5?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            // ),
          ),
        ],
      ),
    );
  }
}