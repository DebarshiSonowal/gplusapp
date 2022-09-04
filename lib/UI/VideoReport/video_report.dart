import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';
import '../Menu/berger_menu_member_page.dart';

class VideoReport extends StatefulWidget {
  const VideoReport({Key? key}) : super(key: key);

  @override
  State<VideoReport> createState() => _VideoReportState();
}

class _VideoReportState extends State<VideoReport> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance.getVideoNews();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setVideoNews(response.videos ?? []);
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted)
    //   setState(() {
    //
    //   });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      // drawer: BergerMenuMemPage(),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            // padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 30.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                              data.video_news[0].image_file_name ??
                                  'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: Constance.secondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  )),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 1.h),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      YoutubePlayerController _controller =
                                          YoutubePlayerController(
                                        initialVideoId:
                                            '${data.video_news[0].youtube_id}' ??
                                                'iLnmTe5Q2Qw',
                                        flags: const YoutubePlayerFlags(
                                          autoPlay: true,
                                          mute: true,
                                        ),
                                      );

                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                data.video_news[0].title
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.headline5?.copyWith(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              backgroundColor: Colors.white,
                                              content: YoutubePlayer(
                                                controller: _controller,
                                                showVideoProgressIndicator:
                                                    true,
                                                // videoProgressIndicatorColor: Colors.amber,
                                                progressColors:
                                                    const ProgressBarColors(
                                                  playedColor: Colors.amber,
                                                  handleColor:
                                                      Colors.amberAccent,
                                                ),
                                                onReady: () {
                                                  // _controller
                                                  //     .addListener(() {});
                                                  _controller.play();
                                                },
                                              ),
                                              actions: <Widget>[
                                                // TextButton(
                                                //     onPressed: () {
                                                //       //action code for "Yes" button
                                                //     },
                                                //     child: Text('Yes')),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context); //close Dialog
                                                  },
                                                  child: Text('Close'),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(
                                      'Play Now',
                                      style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            color: Colors.white,
                                            // fontSize: 2.2.h,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              data.video_news[0].title ??
                                  'It is a long established fact that a reader will be distracted by the readable content of a',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Colors.white,
                                    // fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'GPlus Admin, ${data.video_news[0].publish_date?.split(" ")[0]}',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.grey.shade500,
                                    // fontSize: 2.2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (cont, count) {
                        var item = data.video_news[count];
                        if (count == 0) {
                          return Container();
                        }
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 2.h),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Colors.white,
                          ),
                          height: 20.h,
                          width: MediaQuery.of(context).size.width - 7.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Expanded(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  item.image_file_name ?? '',
                                              fit: BoxFit.cover,
                                              placeholder: (cont, _) {
                                                return const Icon(
                                                  Icons.image,
                                                  color: Colors.black,
                                                );
                                              },
                                              errorWidget: (cont, _, e) {
                                                // print(e);
                                                print(_);
                                                return Text(_);
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              YoutubePlayerController _controller =
                                              YoutubePlayerController(
                                                initialVideoId:
                                                '${item.youtube_id}' ??
                                                    'iLnmTe5Q2Qw',
                                                flags: const YoutubePlayerFlags(
                                                  autoPlay: true,
                                                  mute: true,
                                                ),
                                              );

                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        item.title
                                                            .toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: Theme.of(context).textTheme.headline5?.copyWith(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      backgroundColor: Colors.white,
                                                      content: YoutubePlayer(
                                                        controller: _controller,
                                                        showVideoProgressIndicator:
                                                        true,
                                                        // videoProgressIndicatorColor: Colors.amber,
                                                        progressColors:
                                                        const ProgressBarColors(
                                                          playedColor: Colors.amber,
                                                          handleColor:
                                                          Colors.amberAccent,
                                                        ),
                                                        onReady: () {
                                                          // _controller
                                                          //     .addListener(() {});
                                                          _controller.play();
                                                        },
                                                      ),
                                                      actions: <Widget>[
                                                        // TextButton(
                                                        //     onPressed: () {
                                                        //       //action code for "Yes" button
                                                        //     },
                                                        //     child: Text('Yes')),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context); //close Dialog
                                                          },
                                                          child: Text('Close'),
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Constance.secondaryColor,
                                                // borderRadius: BorderRadius.all(
                                                //   Radius.circular(5.0),
                                                // ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1.w,
                                                  vertical: 0.3.h),
                                              child: Row(
                                                // mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    'Play Now',
                                                    style: Theme.of(Navigation
                                                            .instance
                                                            .navigatorKey
                                                            .currentContext!)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                          color: Colors.white,
                                                          // fontSize: 2.2.h,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      item.publish_date?.split(" ")[0] ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title ?? "",
                                        maxLines: 3,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                color: Constance.primaryColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      "GPlus News",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (cont, inde) {
                        if (inde == 0) {
                          return Container();
                        }
                        return SizedBox(
                          height: 1.h,
                          child: Divider(
                            color: Colors.black,
                            thickness: 0.3.sp,
                          ),
                        );
                      },
                      itemCount: data.video_news.length > 5
                          ? 4
                          : data.video_news.length),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }
}
