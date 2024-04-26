// import 'package:cached_video_player/cached_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:gplusapp/UI/view/video_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
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
  int page_count = 0, video_count = 0;

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
          child: _controller == null
              ? const LoaderScreen()
              : TikTokStyleFullPageScroller(
                  contentSize: videos.length,
                  swipePositionThreshold: 0.2,
                  // ^ the fraction of the screen needed to scroll
                  swipeVelocityThreshold: 2000,
                  // ^ the velocity threshold for smaller scrolls
                  animationDuration: const Duration(milliseconds: 400),
                  // ^ how long the animation will take
                  controller: controller,
                  // ^ registering our own function to listen to page changes
                  builder: (BuildContext context, int index) {
                    final item = videos[video_count];
                    return VideoScreen(controller: _controller!,item:item);
                  },
                ),
        ),
      ),
    );
  }

  void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success,
      {int? currentIndex}) {
    print(
        "Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ?? 'not given'}}");
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
      initVideoController(videos[video_count].videoPath);
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
    _controller = VideoPlayerController.network(
      url,
      videoPlayerOptions: VideoPlayerOptions(),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        Future.delayed(
            const Duration(seconds: 1),
            () => setState(() {
                  _controller?.play();
                }));
      });
  }
}


