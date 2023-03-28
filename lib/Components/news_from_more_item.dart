import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/article.dart';

class NewsFromMoreItem extends StatelessWidget {
  const NewsFromMoreItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Article item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: Storage.instance.isDarkMode
            ? Colors.black
            : Colors.white,
      ),
      height: 20.h,
      width:
      MediaQuery.of(context).size.width - 7.w,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  height: 17.5.h,
                  width: 45.w,
                  imageUrl:
                  item.image_file_name ?? '',
                  fit: BoxFit.fill,
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
                // SizedBox(
                //   height: 1.h,
                // ),
              ],
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.title ?? "",
                    maxLines: 6,
                    style: (item.title?.length ??
                        0) >
                        70
                        ? Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(
                      fontWeight:
                      FontWeight.bold,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      color: Storage
                          .instance
                          .isDarkMode
                          ? Colors.white
                          : Constance
                          .primaryColor,
                    )
                        : Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(
                      fontWeight:
                      FontWeight.bold,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      color: Storage
                          .instance
                          .isDarkMode
                          ? Colors.white
                          : Constance
                          .primaryColor,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 1.h,
                // ),
                Row(
                  children: [
                    // SizedBox(
                    //   width: 4.w,
                    // ),
                    Text(
                      Jiffy(item.publish_date?.split(" ")[0] ?? "", "yyyy-MM-dd")
                          .format("dd MMM, yyyy"),
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
    );
  }
}