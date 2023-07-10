import 'package:flutter/material.dart';
import 'package:gplusapp/Model/citizen_journalist.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Navigation/Navigate.dart';

class StoriesSubmittedItem extends StatelessWidget {
  const StoriesSubmittedItem({super.key, required this.item});
  final CitizenJournalist item;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: Storage.instance.isDarkMode
            ? Colors.black
            : Colors.white,
      ),
      height: 12.h,
      width: MediaQuery.of(context).size.width - 7.w,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow:
                        TextOverflow.ellipsis,
                        color: Storage
                            .instance.isDarkMode
                            ? Colors.white
                            : Constance
                            .primaryColor),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                  child: Text(
                    item.story ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
                        color: Storage
                            .instance.isDarkMode
                            ? Colors.white70
                            : Colors.black),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        Jiffy.parse(item.created_at ?? "",
                            pattern: "yyyy-MM-dd")
                            .format(pattern: "dd/MM/yyyy"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(
                            color: Storage.instance
                                .isDarkMode
                                ? Colors.white70
                                : Colors.black),
                      ),
                    ),
                    Text(
                      getStatusText(item.status),
                      style: Theme.of(Navigation
                          .instance
                          .navigatorKey
                          .currentContext!)
                          .textTheme
                          .headline5
                          ?.copyWith(
                        color: Storage
                            .instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        // fontSize: 2.2.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String getStatusText(int? status) {
    switch (status) {
      case 1:
        return "Authenticity Check";
      case 2:
        return "Published";
      case 3:
        return "Rejected";
      default:
        return "Pending";
    }
  }
}
