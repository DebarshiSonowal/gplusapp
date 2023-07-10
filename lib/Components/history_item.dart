import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Model/redeem_history.dart';
import '../Navigation/Navigate.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.current});
  final RedeemHistory current;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 4.w, vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 45.w,
                child: Text(
                  current.vendor?.shop_name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(Navigation.instance
                      .navigatorKey.currentContext!)
                      .textTheme
                      .headline4
                      ?.copyWith(
                    color: Colors.black,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: 0.5.h,
              ),
              SizedBox(
                width: 45.w,
                child: Text(
                  current.title ?? '25% OFF',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(Navigation.instance
                      .navigatorKey.currentContext!)
                      .textTheme
                      .headline5
                      ?.copyWith(
                    color: Colors.black,
                    fontSize: 10.sp,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 35.w,
                child: Text(
                  current.code ?? '8486',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(Navigation.instance
                      .navigatorKey.currentContext!)
                      .textTheme
                      .headline5
                      ?.copyWith(
                    color: Colors.grey.shade800,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Text(
                Jiffy.parse(current.valid_from.toString().split('T')[0] ?? "", pattern: "yyyy-MM-dd").format(pattern: "dd/MM/yyyy"),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: Theme.of(Navigation.instance
                    .navigatorKey.currentContext!)
                    .textTheme
                    .headline5
                    ?.copyWith(
                  color: Colors.black,
                  fontSize: 11.sp,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
