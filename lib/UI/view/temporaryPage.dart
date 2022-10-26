//var current = data.home_weekly[index];
//             _controller = YoutubePlayerController(
//               initialVideoId:
//                   // widget.youtube_id ??
//                   '${current.youtube_id}' ?? 'iLnmTe5Q2Qw',
//               flags: const YoutubePlayerFlags(
//                 autoPlay: true,
//                 mute: false,
//               ),
//             );
//             return SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: VisibilityDetector(
//                 key: Key(current.youtube_id!),
//                 onVisibilityChanged: (visibilityInfo) {
//                   var visiblePercentage = visibilityInfo.visibleFraction * 100;
//                   if (visiblePercentage < 80) {
//                     _controller!.pause();
//                     print('pause');
//                   }
//                 },
//                 child: YoutubePlayer(
//                   controller: _controller!,
//                   showVideoProgressIndicator: true,
//                   aspectRatio: 2 / 3,
//                   // videoProgressIndicatorColor: Colors.amber,
//                   progressColors: const ProgressBarColors(
//                     playedColor: Colors.amber,
//                     handleColor: Colors.amberAccent,
//                   ),
//                   onReady: () {
//                     // _controller
//                     //     .addListener(() {});
//                     _controller!.play();
//                   },
//                 ),
//               ),
//             );

// return ScrollablePositionedList.builder(
//           itemScrollController: itemScrollController,
//           itemPositionsListener: itemPositionsListener,
//           itemCount: data.home_weekly.length,
//           itemBuilder: (context, index) {
//             var current = data.home_weekly[index];
//             _controller = YoutubePlayerController(
//               initialVideoId:
//                   // widget.youtube_id ??
//                   '${current.youtube_id}' ?? 'iLnmTe5Q2Qw',
//               flags: const YoutubePlayerFlags(
//                 autoPlay: true,
//                 mute: false,
//               ),
//             );
//             return SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: VisibilityDetector(
//                 key: Key(current.youtube_id!),
//                 onVisibilityChanged: (visibilityInfo) {
//                   var visiblePercentage = visibilityInfo.visibleFraction * 100;
//                   if (visiblePercentage < 80) {
//                     _controller!.pause();
//                     print('pause');
//                   }
//                 },
//                 child: YoutubePlayer(
//                   controller: _controller!,
//                   showVideoProgressIndicator: true,
//                   aspectRatio: 2 / 3,
//                   // videoProgressIndicatorColor: Colors.amber,
//                   progressColors: const ProgressBarColors(
//                     playedColor: Colors.amber,
//                     handleColor: Colors.amberAccent,
//                   ),
//                   onReady: () {
//                     // _controller
//                     //     .addListener(() {});
//                     _controller!.play();
//                   },
//                 ),
//               ),
//             );
//           },
//         );