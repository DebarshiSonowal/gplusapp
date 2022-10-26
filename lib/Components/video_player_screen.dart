import 'package:flutter/material.dart';
import 'package:flutter_cards_reel/cards_reel_view.dart';
import 'package:flutter_cards_reel/sliver_cards_reel.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String youtube_id;

  VideoPlayerScreen(this.youtube_id);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  PageController controller = PageController(initialPage: 0);
  int page = 0;

  // PodPlayerController? _controller;
  @override
  void dispose() {
    controller.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        // itemScrollController.jumpTo(
        //     index: Provider.of<DataProvider>(
        //             Navigation.instance.navigatorKey.currentContext ?? context,
        //             listen: false)
        //         .home_weekly
        //         .indexWhere(
        //             (element) => element.youtube_id == widget.youtube_id));
        controller.jumpToPage(Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .home_weekly
            .indexWhere((element) => element.youtube_id == widget.youtube_id));
        page = Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .home_weekly
            .indexWhere((element) => element.youtube_id == widget.youtube_id);
        _controller = YoutubePlayerController(
          initialVideoId: widget.youtube_id,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: true,
          ),
        );
      });
      // _controller = PodPlayerController(
      //   playVideoFrom: PlayVideoFrom.network(
      //     'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      //   ),
      // )..initialise();
      // print(Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext ?? context,
      //         listen: false)
      //     .home_weekly
      //     .indexWhere((element) => element.youtube_id == widget.youtube_id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
      child: Consumer<DataProvider>(builder: (context, data, _) {
        return Container(
          padding: EdgeInsets.only(top: 1.h),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 4.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.1.h,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: Text(
                        "${page+1} of ${data.home_weekly.length}",
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.1.h,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: data.home_weekly.length,
                  scrollDirection: Axis.horizontal,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    var current = data.home_weekly[index];
                    // _controller = PodPlayerController(
                    //   playVideoFrom: PlayVideoFrom.youtube(
                    //       'https://youtu.be/${current.youtube_id}'),
                    // _controller?.load(current.youtube_id!);

                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: current.youtube_id!,
                              flags: const YoutubePlayerFlags(
                                disableDragSeek: true,
                                autoPlay: false,
                                mute: false,
                              ),
                            ),
                            showVideoProgressIndicator: true,
                            aspectRatio: 2 / 3,
                            // videoProgressIndicatorColor: Colors.amber,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.amber,
                              handleColor: Colors.amberAccent,
                            ),
                            onReady: () {
                              // _controller
                              //     .addListener(() {});
                              _controller!.play();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.h, horizontal: 2.w),
                          child: Text(
                            current.title ?? "",
                            style:
                                Theme.of(context).textTheme.headline3?.copyWith(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
                    );
                  },
                  onPageChanged: (count) {
                    setState(() {
                      page = count;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
