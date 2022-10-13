import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Model/video_news.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Helper/Constance.dart';
import '../Model/top_picks.dart';
import '../Navigation/Navigate.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final VideoNews item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation.instance.navigate('/videoPlayer', args: item.youtube_id);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
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
          height: 5.h,
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
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Text(
                    // item.publish_date?.split(" ")[0] ?? "",
                    Jiffy(item.publish_date?.split(" ")[0] ?? "", "yyyy-MM-dd")
                        .format("dd/MM/yyyy"),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Text(
                      "",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
