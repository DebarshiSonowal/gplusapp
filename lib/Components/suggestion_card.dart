import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/article.dart';
import '../Navigation/Navigate.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    Key? key,
    required this.dropdownvalue,
    required this.item,
  }) : super(key: key);

  final String dropdownvalue;
  final Article item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation.instance
            .navigate('/story', args: '$dropdownvalue,${item.seo_name}');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        ),
        height: 20.h,
        width: MediaQuery.of(context).size.width - 7.w,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    height: 17.7.h,
                    width: 45.w,
                    imageUrl: item.image_file_name ?? '',
                    fit: BoxFit.fill,
                    placeholder: (cont, _) {
                      return Image.asset(
                        Constance.logoIcon,
                      );
                    },
                    errorWidget: (cont, _, e) {
                      return Image.network(
                        Constance.defaultImage,
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),

                ],
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title ?? "",
                      maxLines: 8,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor),
                    ),
                  ),

                  Text(
                    Jiffy(item.publish_date?.split(" ")[0] ?? "", "yyyy-MM-dd")
                        .format("dd MMM,yyyy"),
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    item.author_name ?? "G Plus News",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black),
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
