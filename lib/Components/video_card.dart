import 'package:flutter/material.dart';
import 'package:gplusapp/Components/video_report_card.dart';
import 'package:gplusapp/Model/video_news.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final VideoNews item;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: const BorderSide(
          width: 0.5,
          color: Colors.black26,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 1.2.h),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Constance.secondaryColor,
        ),
        // height: 10.h,
        height: 15.h,
        width: MediaQuery.of(context).size.width - 9.w,
        child: Row(
          children: [
            ImageView(item: item),
            SizedBox(
              width: 2.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 45.w,
                  child: Text(
                    item.title ?? "",
                    maxLines: 4,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        // fontSize: 2.2.h,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        color: Constance.primaryColor),
                  ),
                ),
                // SizedBox(
                //   height: 1.5.h,
                // ),
                Text(
                  Jiffy(item.publish_date?.split(" ")[0] ?? "", "yyyy-MM-dd")
                      .format("dd MMM ,yyyy"),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.black54),
                ),
                // Text(
                //   "",
                //   style: Theme.of(context)
                //       .textTheme
                //       .headline6
                //       ?.copyWith(color: Colors.black),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


