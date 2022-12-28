import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Model/video_news.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Constance.secondaryColor,
        ),
        // height: 10.h,
        width: MediaQuery.of(context).size.width - 9.w,
        child: Row(
          children: [
            ImageView(item: item),
            SizedBox(
              width: 5.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 40.w,
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
                      .format("dd MMM,yyyy"),
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

class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
    required this.item,
  }) : super(key: key);

  final VideoNews item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 13.h,
          width: 35.w,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 13.h,
                width: 35.w,
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
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black]),
                  // color: Constance.secondaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 1.w, vertical: 0.3.h),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    Text(
                      'Play Now',
                      style: Theme.of(Navigation
                          .instance.navigatorKey.currentContext!)
                          .textTheme
                          .headline5
                          ?.copyWith(
                        color: Colors.white,
                        // fontSize: 2.2.h,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
