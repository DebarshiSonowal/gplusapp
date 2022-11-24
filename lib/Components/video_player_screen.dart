import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class VideoPlayerScreen extends StatefulWidget {
  final String input;

  VideoPlayerScreen(this.input){
   print(input.toString().split(',')[1]);
  }

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController? _controller;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  PageController controller = PageController(initialPage: 0);
  int page = 1;
  String currentId = '';
  List<YoutubePlayerController> _controllers = [];

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
        _controllers = (widget.input.toString().split(',')[1] == '1'
                ? Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .home_weekly
                : Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .video_news)
            .map<YoutubePlayerController>(
              (videoId) => YoutubePlayerController(
                initialVideoId: videoId.youtube_id!,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                ),
              ),
            )
            .toList();
        // itemScrollController.jumpTo(
        //     index: Provider.of<DataProvider>(
        //             Navigation.instance.navigatorKey.currentContext ?? context,
        //             listen: false)
        //         .home_weekly
        //         .indexWhere(
        //             (element) => element.youtube_id == widget.youtube_id));
        controller.jumpToPage((widget.input.toString().split(',')[1] == '1'
                ? Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .home_weekly
                : Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .video_news)
            .indexWhere((element) => element.youtube_id == widget.input.toString().split(',')[0]));

        page = (widget.input.toString().split(',')[1] == '1'
                ? Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .home_weekly
                : Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .video_news)
            .indexWhere((element) => element.youtube_id ==  widget.input.toString().split(',')[0]);
        // _controller = YoutubePlayerController(
        //   initialVideoId: widget.youtube_id,
        //   flags: const YoutubePlayerFlags(
        //     autoPlay: false,
        //     mute: false,
        //   ),
        // );
        currentId = widget.input;
      });
      // controller.addListener(() {
      //   Future.delayed(Duration.zero, () {
      //     print(Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext ??
      //             context,
      //         listen: false)
      //         .home_weekly[controller.page?.ceil() ?? 0].title);
      //     setState(() {
      //       _controller?.load(Provider.of<DataProvider>(
      //           Navigation.instance.navigatorKey.currentContext ??
      //               context,
      //           listen: false)
      //           .home_weekly[controller.page?.ceil() ?? 0]
      //           .youtube_id ??
      //           "");
      //     });
      //   });
      // });
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          padding: EdgeInsets.symmetric(
            horizontal: 1.w,
          ),
          child: Consumer<DataProvider>(builder: (context, data, _) {
            return Container(
              padding: EdgeInsets.only(top: 0.h),
              child: PageView.builder(
                itemCount: _controllers.length,
                scrollDirection: Axis.horizontal,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  var current = (widget.input.toString().split(',')[1] == '1'
                      ? data.home_weekly
                      : data.video_news)[index];
                  // _controller = PodPlayerController(
                  //   playVideoFrom: PlayVideoFrom.youtube(
                  //       'https://youtu.be/${current.youtube_id}'),
                  // _controller?.load(current.youtube_id!);
                  currentId = current.youtube_id!;

                  return Stack(
                    // alignment: Alignment.bottomCenter,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 70.h,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: 7.h, bottom: 15.h),
                            child: YoutubePlayer(
                              // controller: _controller = YoutubePlayerController(
                              //   initialVideoId: current.youtube_id!,
                              //   flags: const YoutubePlayerFlags(
                              //     autoPlay: false,
                              //     mute: false,
                              //   ),
                              // ),
                              controller: _controllers[index],
                              showVideoProgressIndicator: true,
                              aspectRatio: 2 / 3,
                              // videoProgressIndicatorColor: Colors.amber,
                              progressColors: const ProgressBarColors(
                                playedColor: Colors.amber,
                                handleColor: Colors.amberAccent,
                              ),
                              onReady: () {
                                print('R12345&d');
                                // _controller
                                //     .addListener(() {});
                                // _controller!.play();
                                setState(() {
                                  _controllers[index].play();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -80.h,
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
                                  "${page + 1} of ${(widget.input.toString().split(',')[1] == '1'
                                      ? data.home_weekly
                                      : data.video_news).length}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
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
                        top: -87.h,
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
                        top: 75.h,
                        left: 20,
                        right: 10,
                        bottom: 1.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.h, horizontal: 2.w),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black]),
                          ),
                          child: Center(
                            child: Text(
                              current.title?.trim() ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
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
                },
                onPageChanged: (count) {
                  setState(() {
                    page = count;
                  });
                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      currentId = (widget.input.toString().split(',')[1] == '1'
                          ? Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                          .home_weekly
                          : Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                          .video_news)[count]
                          .youtube_id!;
                    });
                  });
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
