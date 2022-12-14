import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Model/article.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';

class GPlusExecCard extends StatelessWidget {
  const GPlusExecCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Article item;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          width: 0.5,
          color: Storage.instance.isDarkMode ? Colors.white70 : Colors.black26,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        ),
        height: 10.h,
        width: MediaQuery.of(context).size.width - 9.w,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                  // SizedBox(
                  //   height: 1.5.h,
                  // ),
                ],
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title ?? "",
                      maxLines: 7,
                      style: (item.title?.length ?? 0) > 70
                          ? Theme.of(context).textTheme.headline5?.copyWith(
                                // fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Constance.primaryColor,
                              )
                          : Theme.of(context).textTheme.headline4?.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                color: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Constance.primaryColor,
                              ),
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 4.w,
                      // ),
                      Text(
                        Jiffy(item.publish_date?.split(" ")[0] ?? "",
                                "yyyy-MM-dd")
                            .format("dd MMM,yyyy"),
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Row(
                    children: [
                      // Image.asset(
                      //   Constance.authorIcon,
                      //   color: Constance.secondaryColor,
                      //   // size: 8.sp,
                      //   scale: 37,
                      // ),
                      // SizedBox(
                      //   width: 1.w,
                      // ),
                      Text(
                        item.author_name ?? "",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
