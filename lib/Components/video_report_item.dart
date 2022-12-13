import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/video_news.dart';
import '../Navigation/Navigate.dart';

class VideoReportItem extends StatelessWidget {
  final VideoNews item;

  const VideoReportItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
      ),
      // height: 5.h,
      width: MediaQuery.of(context).size.width - 7.w,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: 40.w,
                    height: 12.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: item.image_file_name ?? '',
                        placeholder: (cont, _) {
                          return Image.asset(
                            Constance.logoIcon,
                            // color: Colors.black,
                          );
                        },
                        errorWidget: (cont, _, e) {
                          return Image.network(
                            Constance.defaultImage,
                            fit: BoxFit.fitWidth,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 40.w,
                    decoration: const BoxDecoration(
                      color: Constance.secondaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.3.h),
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                        ),
                        Text(
                          'Play Now',
                          style: Theme.of(Navigation
                                  .instance.navigatorKey.currentContext!)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                color: Colors.black,
                                // fontSize: 2.2.h,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                // item.publish_date?.split(" ")[0] ??
                //     "",
                Jiffy(item.publish_date?.split(" ")[0] ?? "", "yyyy-MM-dd")
                    .format("dd/MM/yyyy"),
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
          SizedBox(
            width: 5.w,
          ),
          Expanded(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  item.title ?? "",
                  overflow: TextOverflow.clip,
                  maxLines: 4,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      // fontSize: 2.2.h,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor),
                ),
                SizedBox(
                  height: 7.h,
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
          ),
        ],
      ),
    );
  }
}
