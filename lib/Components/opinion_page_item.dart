import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/opinion.dart';
import '../Navigation/Navigate.dart';

class OpionionPageItem extends StatelessWidget {
  final DataProvider data;
  const OpionionPageItem({
    Key? key,
    required this.item, required this.data,
  }) : super(key: key);

  final Opinion item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.profile?.is_plan_active ?? false) {
          // Navigation.instance.navigate(
          //     '/opinionDetails',
          //     args: item.seo_name?.trim());
          Navigation.instance.navigate('/opinionDetails',
              args: '${item.seo_name?.trim()},${item.category_gallery?.id}');
        } else {
          Constance.showMembershipPrompt(
              context, () {});
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 3.w, vertical: 1.h),
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
                    height: 17.7.h,
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
                      maxLines: 8,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight:
                          FontWeight.bold,
                          overflow: TextOverflow
                              .ellipsis,
                          color: Storage
                              .instance
                              .isDarkMode
                              ? Colors.white
                              : Constance
                              .primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 4.w,
                      // ),
                      Text(
                        Jiffy(item.publish_date?.split(" ")[0] ?? "", "yyyy-MM-dd")
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
                        item.user?.name ?? "",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black54),
                      ),
                    ],
                  ),
                  // Text(
                  //   Jiffy(
                  //       item.publish_date
                  //           ?.split(" ")[0],
                  //       "yyyy-MM-dd")
                  //       .format("dd MMM,yyyy"),
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headline6
                  //       ?.copyWith(
                  //       color: Storage.instance
                  //           .isDarkMode
                  //           ? Colors.white
                  //           : Colors.black),
                  // ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  // Text(
                  //   item.user?.name ??
                  //       "G Plus News",
                  //   style: Theme.of(Navigation
                  //       .instance
                  //       .navigatorKey
                  //       .currentContext!)
                  //       .textTheme
                  //       .headline5
                  //       ?.copyWith(
                  //     color: Storage.instance
                  //         .isDarkMode
                  //         ? Colors.white
                  //         : Constance
                  //         .fifthColor,
                  //     // fontSize: 2.2.h,
                  //     // fontWeight:
                  //     // FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}