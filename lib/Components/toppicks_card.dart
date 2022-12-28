import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Model/top_picks.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';

class SuggestedForYouCard extends StatelessWidget {
  final TopPicks item;

  const SuggestedForYouCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.symmetric(horizontal: 5.s),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: const BorderSide(
          width: 0.5,
          color: Colors.black,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Colors.white,
        ),
        height: 12.h,
        width: MediaQuery.of(context).size.width - 10.w,
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
                ],
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text(
                      item.title ??
                          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient.",
                      maxLines: 8,
                      style: (item.title?.length??0)>80?Theme.of(context).textTheme.headline5?.copyWith(
                          // fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          color: Constance.primaryColor):Theme.of(context).textTheme.headline4?.copyWith(
                        fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          color: Constance.primaryColor),
                    ),
                  ),
                  // SizedBox(
                  //   height: 1.5.h,
                  // ),
                  Spacer(),
                  Text(
                    Jiffy(item.date, "yyyy-MM-dd").format("dd MMM,yyyy"),
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black87,
                          fontSize: 8.sp,
                        ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    item.author_name ?? "",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black87,
                          fontSize: 8.5.sp,
                        ),
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
