import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Helper/DataProvider.dart';
import '../../Model/video_news.dart';
import '../../Navigation/Navigate.dart';

class LandscapeVideoPlayer extends StatelessWidget {
  const LandscapeVideoPlayer({
    super.key,
    required this.index,
    required this.controller,
    required this.input,
    required this.current,
    required this.getYoutubeThumbnail,
    required this.page,
    required this.data,
  });

  final int index, page;
  final YoutubePlayerController controller;
  final String input;
  final VideoNews current;
  final Function(String) getYoutubeThumbnail;
  final DataProvider data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: Alignment.bottomCenter,
      children: [
        Center(
          child: SizedBox(
            // color: Colors.white,
            // height: 70.h,
            height: 100.h,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                top: 8.h,
                bottom: 8.h,
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                child: YoutubePlayer(
                  // controller: _controller = YoutubePlayerController(
                  //   initialVideoId: current.youtube_id!,
                  //   flags: const YoutubePlayerFlags(
                  //     autoPlay: false,
                  //     mute: false,
                  //   ),
                  // ),
                  controller: controller,
                  showVideoProgressIndicator: true,
                  // aspectRatio: 16 / 9,
                  thumbnail: Image.network(
                    getYoutubeThumbnail(current.youtube_id!),
                    // fit: BoxFit.fill,
                  ),
                  // aspectRatio: 16 / 10,
                  // videoProgressIndicatorColor: Colors.amber,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),

                  onReady: () {
                    // print('R12345&d');
                    // _controller
                    //     .addListener(() {});
                    // _controller!.play();
                    controller.play();
                    // setState(() {
                    //
                    // });
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -32.h,
          left: 10,
          right: 10,
          bottom: 0,
          child: Container(
            width: double.infinity,
            height: 6.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.1.h,
                    color: Colors.white,
                  ),
                ),
                Container(
                  height: 4.h,
                  width: 4.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 0.2.h,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text(
                    "${page + 1} of ${(input.toString().split(',')[1] == '1' ? data.home_weekly : data.video_news).length}",
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Divider(
                    thickness: 0.1.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -36.h,
          left: 10,
          right: 10,
          bottom: 0,
          child: Container(
            width: double.infinity,
            height: 6.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Share.share(
                        'http://www.youtube.com/watch?v=${current.youtube_id}');
                  },
                  icon: const Icon(Icons.share),
                ),
                IconButton(
                  onPressed: () {
                    Navigation.instance.goBack();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 39.h,
          left: 20,
          right: 10,
          bottom: 1.h,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 2.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black]),
            ),
            child: Center(
              child: Text(
                current.title?.trim() ?? "",
                style: Theme.of(context).textTheme.headline3?.copyWith(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}