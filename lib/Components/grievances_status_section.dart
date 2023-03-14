import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';

class GrievancesStatus extends StatelessWidget {
  const GrievancesStatus({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return SizedBox(
        // height: 99.h,
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 2.h),
          itemBuilder: (context, index) {
            var item = data.grievences[index];
            return GrievancesItem(
              date: DateTime.parse(item.month!),
              received: item.received!,
              resolved: item.resolved!,
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 1.h,
            );
          },
          itemCount: data.grievences.length,
        ),
      );
    });
  }
}

class GrievancesItem extends StatelessWidget {
  const GrievancesItem({
    super.key,
    required this.date, required this.received, required this.resolved,
  });

  final DateTime date;
  final int received,resolved;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Storage.instance.isDarkMode
              ? Colors.white70
              : Colors.black26, //                   <--- border color
          // width: 5.0,
        ),
        borderRadius: const BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: ExpansionTile(
        collapsedIconColor:
            Storage.instance.isDarkMode ? Colors.white : Colors.black,
        iconColor: Storage.instance.isDarkMode ? Colors.white : Colors.black,
        title: Text(
          DateFormat("MMM yyyy").format(date),
          style: Theme.of(context).textTheme.headline4?.copyWith(
                color: Storage.instance.isDarkMode
                    ? Colors.white
                    : Constance.primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            height: 1.h,
            width: double.infinity,
            child: Divider(
              color:
                  Storage.instance.isDarkMode ? Colors.white70 : Colors.black26,
              thickness: 0.7.sp,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grievances Received',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  "$received",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grievances Resolved',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$resolved',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}
