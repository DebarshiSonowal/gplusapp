import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String youtube_id;


  VideoPlayerScreen(this.youtube_id);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {

    setState(() {
      _controller = YoutubePlayerController(
        initialVideoId:
        '${widget.youtube_id}' ??
            // '${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context).home_weekly[0].youtube_id}' ??
            'iLnmTe5Q2Qw',
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        aspectRatio: 2/3,
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
    );
  }
}
