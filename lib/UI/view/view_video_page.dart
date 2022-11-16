import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class ViewVideoPage extends StatefulWidget {
  final String url;

  const ViewVideoPage(this.url);

  @override
  State<ViewVideoPage> createState() => _ViewVideoPageState();
}

class _ViewVideoPageState extends State<ViewVideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
          videoPlayerOptions: VideoPlayerOptions())
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            _controller.play();
          });
        });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onTap: (){
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: VideoPlayer(
          _controller,
        ),
      ),
    );
  }
}
