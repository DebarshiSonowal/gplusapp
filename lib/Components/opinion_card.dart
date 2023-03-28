import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/opinion.dart';

class OpinionCard extends StatelessWidget {
  const OpinionCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Opinion item;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
            width: 0.5,
            color: Storage.instance.isDarkMode
                ? Colors.white
                : Constance.primaryColor),
      ),
      child: Container(
        // padding: EdgeInsets.symmetric(
        //     horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        ),
        height: 12.5.h,
        width: MediaQuery.of(context).size.width - 7.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border(
                      top: BorderSide(
                          width: 0.5,
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor),
                      bottom: BorderSide(
                          width: 0.5,
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor),
                      right: BorderSide(
                          width: 0.5,
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor),
                      left: BorderSide(
                          width: 0.5,
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor),
                    ),
                    color: Storage.instance.isDarkMode
                        ? Colors.black
                        : Colors.white,
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: Text(
                            item.title ?? "",
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      fontSize: 12.sp,
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Constance.fifthColor,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            Constance.authorIcon,
                            color: Constance.secondaryColor,
                            // size: 8.sp,
                            scale: 37,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          SizedBox(
                            width: 45.w,
                            child: Text(
                              item.user?.name ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.fifthColor,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        // item.publish_date?.split(" ")[0] ?? "",
                        Jiffy(item.publish_date?.split(" ")[0] ?? "",
                                "yyyy-MM-dd")
                            .format("dd MMM, yyyy"),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black54,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
