// import 'package:cached_video_player/cached_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/guwhati_connect_post_card.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:gplusapp/UI/view/video_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:multi_video_player/multi_video_player.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';

import '../../Model/short_video.dart';
import 'loader_screen.dart';

class VideoScrollPlayer extends StatefulWidget {
  const VideoScrollPlayer({super.key, required this.id});

  final String id;

  @override
  State<VideoScrollPlayer> createState() => _VideoScrollPlayerState();
}

class _VideoScrollPlayerState extends State<VideoScrollPlayer> {
  VideoPlayerController? _controller;
  List<ShortVideo> videos = [];
  int page_count = 0,
      video_count = 0,
      video_limit = 0,
      page_limit = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchVideos(context, page_count);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Controller controller = Controller()
      ..addListener((event) {
        _handleCallbackEvent(event.direction, event.success);
      });
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: page_limit==0
              ? const LoaderScreen()
          // : TikTokStyleFullPageScroller(
          //     contentSize: videos.length,
          //     swipePositionThreshold: 0.2,
          //     // ^ the fraction of the screen needed to scroll
          //     swipeVelocityThreshold: 2000,
          //     // ^ the velocity threshold for smaller scrolls
          //     animationDuration: const Duration(milliseconds: 400),
          //     // ^ how long the animation will take
          //     controller: controller,
          //     // ^ registering our own function to listen to page changes
          //     builder: (BuildContext context, int index) {
          //       final item = videos[video_count];
          //       return VideoScreen(controller: _controller!, item: item);
          //     },
          //   ),
              : Stack(
            children: [
              MultiVideoPlayer.network(
                height: double.infinity,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                videoSourceList: videos.map((e) => e.videoPath).toList(),
                scrollDirection: Axis.vertical,
                preloadPagesCount: 3,
                onPageChanged: (videoPlayerController, index) {
                  if (video_count<video_limit-2) {
                    setState(() {
                      video_count=index;
                    });
                  }else{
                    setState(() {
                      page_count++;
                      video_count=index;
                    });
                    fetchMoreVideos(context, page_count);
                  }
                },
                getCurrentVideoController: (videoPlayerController) {},
              ),
              Positioned(
                left: 0,
                bottom: 4.5.h,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.02)),
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
                            videos[video_count].title ?? "GPlus",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
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
                          videos[video_count].description ??
                              'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                          trimLines: 2,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                          moreStyle: Theme
                              .of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                          lessStyle: Theme
                              .of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
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
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05)),
                  child: Column(
                    children: [
                      // LikeButton(
                      //   isLiked: isLiked,
                      //   size: 10.w,
                      //   countPostion: CountPostion.bottom,
                      //   circleColor:
                      //       const CircleColor(start: Colors.white, end: Colors.red),
                      //   bubblesColor: const BubblesColor(
                      //     dotPrimaryColor: Color(0xff33b5e5),
                      //     dotSecondaryColor: Color(0xff0099cc),
                      //   ),
                      //   likeBuilder: (bool isLiked) {
                      //     return Icon(
                      //       isLiked
                      //           ? FontAwesomeIcons.solidHeart
                      //           : FontAwesomeIcons.heart,
                      //       color: isLiked ? Colors.red : Colors.grey.shade100,
                      //       size: 10.w,
                      //     );
                      //   },
                      //   likeCount: widget.item.viewCount??665,
                      //   countBuilder: (int? count, bool isLiked, String text) {
                      //     var color = isLiked ? Colors.red : Colors.grey.shade100;
                      //     Widget result;
                      //     if (count == 0) {
                      //       result = Container(
                      //         margin: EdgeInsets.only(top: 1.h),
                      //         child: Text(
                      //           "love",
                      //           style: TextStyle(color: color),
                      //         ),
                      //       );
                      //     } else {
                      //       result = Container(
                      //         margin: EdgeInsets.only(top: 1.h),
                      //         child: Text(
                      //           text,
                      //           style: TextStyle(
                      //             color: color,
                      //             fontSize: 16.sp,
                      //           ),
                      //         ),
                      //       );
                      //     }
                      //     return result;
                      //   },
                      // ),
                      SizedBox(
                        height: 2.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Share.share(
                            ""
                          );
                        },
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
                                // SizedBox(
                                //   height: 1.h,
                                // ),
                                // Text(
                                //   "0",
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 16.sp,
                                //   ),
                                // ),
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
          ),
        ),
      ),
    );
  }

  void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success,
      {int? currentIndex}) {
    print(
        "Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ??
            'not given'}}");
    if (success == ScrollSuccess.SUCCESS &&
        direction == ScrollDirection.FORWARD) {
      if (video_count < videos.length - 2) {
        setState(() {
          video_count++;
        });
        initVideoController(videos[video_count].videoPath);
      } else if (video_count == videos.length - 2) {
        setState(() {
          page_count++;
          video_count = 0;
        });
        fetchMoreVideos(context, page_count);
      }
    } else if (success == ScrollSuccess.SUCCESS &&
        direction == ScrollDirection.BACKWARDS) {
      if (video_count > 2) {
        setState(() {
          video_count--;
        });
        initVideoController(videos[video_count].videoPath);
      } else if (video_count == 2) {
        setState(() {
          page_count--;
          video_count = videos.length;
        });
        fetchVideos(context, page_count);
      }
    }
  }

  fetchVideos(context, page) async {
    final response = await ApiProvider.instance.shortVideo(page);
    if (response.success ?? false) {
      videos = response.result?.data ?? [];
      if (videos[video_count].videoPath != null) {
        initVideoController(videos[video_count].videoPath);
        setState(() {
          page_limit = response.result?.lastPage ?? 0;
          video_limit = response.result?.perPage ?? 0;
        });
      } else {
        showError("Something Went Wrong");
        Navigation.instance.goBack();
      }
    }
  }

  fetchMoreVideos(context, page) async {
    final response = await ApiProvider.instance.shortVideo(page);
    if (response.success ?? false) {
      videos.addAll(response.result?.data ?? []);
      initVideoController(videos[video_count].videoPath);
    }
  }

  initVideoController(url) {
    print("URL ${url}");
    _controller = VideoPlayerController.network(
      url,
      videoPlayerOptions: VideoPlayerOptions(),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        Future.delayed(
            const Duration(seconds: 2),
            () => setState(() {

                  _controller?.setLooping(true);
                  _controller?.play();
                }));
      });
  }
}
