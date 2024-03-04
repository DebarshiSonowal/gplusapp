// import 'package:cached_video_player/cached_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/UI/view/video_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';

class VideoScrollPlayer extends StatefulWidget {
  const VideoScrollPlayer({super.key});

  @override
  State<VideoScrollPlayer> createState() => _VideoScrollPlayerState();
}

class _VideoScrollPlayerState extends State<VideoScrollPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-fashion-model-with-a-cold-and-pale-appearance-39877-large.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        Future.delayed(
            Duration(seconds: 1),
            () => setState(() {
                  _controller.play();
                }));
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
          child: TikTokStyleFullPageScroller(
            contentSize: 4,
            swipePositionThreshold: 0.2,
            // ^ the fraction of the screen needed to scroll
            swipeVelocityThreshold: 2000,
            // ^ the velocity threshold for smaller scrolls
            animationDuration: const Duration(milliseconds: 400),
            // ^ how long the animation will take
            controller: controller,
            // ^ registering our own function to listen to page changes
            builder: (BuildContext context, int index) {
              return VideoScreen(controller: _controller);
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
  }
}
