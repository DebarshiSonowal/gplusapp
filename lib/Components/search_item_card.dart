import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/search_result.dart';

class SearchItemCard extends StatelessWidget {
  final OthersSearchResult item;

  const SearchItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
      ),
      // height: 10.h,
      width: MediaQuery.of(context).size.width - 7.w,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CachedNetworkImage(
                //   height: 15.h,
                //   width: 45.w,
                //   imageUrl: item.image_file_name ?? '',
                //   fit: BoxFit.fill,
                //   placeholder: (cont, _) {
                //     return Image.asset(
                //       Constance.logoIcon,
                //       // color: Colors.black,
                //     );
                //   },
                //   errorWidget: (cont, _, e) {
                //     return Image.asset(
                //       Constance.logoIcon,
                //       // color: Colors.black,
                //     );
                //   },
                // ),
                Text(
                  item.title ??
                      "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient.",
                  maxLines: 8,
                  style: (item.title?.length ?? 0) > 80
                      ? Theme.of(context).textTheme.headline5?.copyWith(
                    // fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: Constance.primaryColor)
                      : Theme.of(context).textTheme.headline4?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: Constance.primaryColor),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  getMessage(item.type),
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   width: 4.w,
          // ),
          // Expanded(
          //   flex: 1,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // Expanded(
          //       //   child: Text(
          //       //     item.title ?? "",
          //       //     maxLines: 3,
          //       //     style: Theme.of(context).textTheme.headline6?.copyWith(
          //       //         fontWeight: FontWeight.bold,
          //       //         overflow: TextOverflow.ellipsis,
          //       //         color: Storage.instance.isDarkMode
          //       //             ? Colors.white
          //       //             : Constance.primaryColor),
          //       //   ),
          //       // ),
          //       Text(
          //         item.title ??
          //             "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient.",
          //         maxLines: 8,
          //         style: (item.title?.length ?? 0) > 80
          //             ? Theme.of(context).textTheme.headline5?.copyWith(
          //           // fontSize: 11.sp,
          //             fontWeight: FontWeight.bold,
          //             overflow: TextOverflow.ellipsis,
          //             color: Constance.primaryColor)
          //             : Theme.of(context).textTheme.headline4?.copyWith(
          //             fontSize: 13.sp,
          //             fontWeight: FontWeight.bold,
          //             overflow: TextOverflow.ellipsis,
          //             color: Constance.primaryColor),
          //       ),
          //       SizedBox(
          //         height: 1.h,
          //       ),
          //       // Text(
          //       //   item.author_name ?? "G Plus News",
          //       //   style: Theme.of(Navigation.instance
          //       //       .navigatorKey.currentContext!)
          //       //       .textTheme
          //       //       .headline5
          //       //       ?.copyWith(
          //       //     color: Constance.thirdColor,
          //       //     // fontSize: 2.2.h,
          //       //     fontWeight: FontWeight.bold,
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  String getMessage(String? type) {
    switch (type) {
      case "guwahati-connect":
        return "Guwahati Connect";
      case "classified":
        return "Classified";
      case "vendor":
        return "Big Deal";
      default:
        return "News";
    }
  }
}
