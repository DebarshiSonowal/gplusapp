import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../Model/short_video.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key, required this.controller, required this.item});
  final ShortVideo item;
  final VideoPlayerController controller;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              isLiked = true;
            });
          },
          child: AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(widget.controller),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 4.5.h,
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.02)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    CircleAvatar(
                      radius: 7.5.w, // Image radius
                      backgroundImage: const CachedNetworkImageProvider(
                          "https://cdn.pixabay.com/photo/2024/02/15/13/55/ai-generated-8575453_1280.png"),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      widget.item.title??"GPlus",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.02)),
                  padding: EdgeInsets.only(
                    top: 3.w,
                    left: 4.w,
                  ),
                  width: 85.w,
                  child: ReadMoreText(
                    widget.item.description??'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                    lessStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 4.w,
          bottom: 4.5.h,
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
            child: Column(
              children: [
                LikeButton(
                  isLiked: isLiked,
                  size: 10.w,
                  countPostion: CountPostion.bottom,
                  circleColor:
                      const CircleColor(start: Colors.white, end: Colors.red),
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: isLiked ? Colors.red : Colors.grey.shade100,
                      size: 10.w,
                    );
                  },
                  likeCount: widget.item.viewCount??665,
                  countBuilder: (int? count, bool isLiked, String text) {
                    var color = isLiked ? Colors.red : Colors.grey.shade100;
                    Widget result;
                    if (count == 0) {
                      result = Container(
                        margin: EdgeInsets.only(top: 1.h),
                        child: Text(
                          "love",
                          style: TextStyle(color: color),
                        ),
                      );
                    } else {
                      result = Container(
                        margin: EdgeInsets.only(top: 1.h),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: color,
                            fontSize: 16.sp,
                          ),
                        ),
                      );
                    }
                    return result;
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 9.h,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.share,
                            size: 10.w,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            "5,352",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 9.h,
                    child: Icon(
                      Icons.more_vert,
                      size: 10.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
