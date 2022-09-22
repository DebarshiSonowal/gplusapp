import 'package:flutter/material.dart';
import 'package:flutter_cards_reel/cards_reel_view.dart';
import 'package:flutter_cards_reel/sliver_cards_reel.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        itemScrollController.jumpTo(
            index: Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .home_weekly
                .indexWhere(
                    (element) => element.youtube_id == widget.youtube_id));
      });
      print(Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .home_weekly
          .indexWhere((element) => element.youtube_id == widget.youtube_id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Consumer<DataProvider>(builder: (context, data, _) {
        return ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: data.home_weekly.length,
          itemBuilder: (context, index) {
            var current = data.home_weekly[index];
            _controller = YoutubePlayerController(
              initialVideoId:
                  // widget.youtube_id ??
                  '${current.youtube_id}' ?? 'iLnmTe5Q2Qw',
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
              ),
            );
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: VisibilityDetector(
                key: Key(current.youtube_id!),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                  if (visiblePercentage < 80) {
                    _controller!.pause();
                    print('pause');
                  }
                },
                child: YoutubePlayer(
                  controller: _controller!,
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
            );
          },
        );
      }),
    );
  }
}
