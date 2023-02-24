import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/video_news.dart';
import '../Navigation/Navigate.dart';

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
          height: 17.5.h,
          width: 35.w,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 17.5.h,
                width: 35.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
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