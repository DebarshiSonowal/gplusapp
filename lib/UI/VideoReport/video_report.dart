import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Components/video_report_item.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';
import '../Menu/berger_menu_member_page.dart';

class VideoReport extends StatefulWidget {
  final String category;

  const VideoReport(this.category);

  @override
  State<VideoReport> createState() => _VideoReportState();
}

class _VideoReportState extends State<VideoReport> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  final ScrollController controller = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchData();
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          debugPrint("check ${controller.position}");
          _refreshController.requestRefresh();
        } else {
          // print('At the bottom');
          debugPrint("check2 ${controller.position}");
          // _refreshController.requestLoading();
          page++;
          fetchMoreData();
        }
      }
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    setState(() {
      page = 1;
    });
    final response =
        await ApiProvider.instance.getVideoMoreNews(widget.category, 10, 1);
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
    page++;
    fetchMoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      // appBar: Constance.buildAppBar("video", true, _scaffoldKey),
      appBar: Constance.buildAppBar2("video"),
      // drawer: const BergerMenuMemPage(screen: "video",),
      // drawer: BergerMenuMemPage(),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropHeader(),
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
        child: SafeArea(
          child: Consumer<DataProvider>(builder: (context, data, _) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
              // padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
              child: data.video_news.isNotEmpty
                  ? SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                height: 35.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
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
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black],
                                  ),
                                ),
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
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // if (data.profile
                                              //         ?.is_plan_active ??
                                              //     false) {
                                                Navigation.instance.navigate(
                                                    '/videoPlayer',
                                                    args:
                                                        '${data.video_news[0].youtube_id},${'2'}');
                                              // } else {
                                              //   Constance.showMembershipPrompt(
                                              //       context, () {
                                              //     setState(() {});
                                              //   });
                                              // }
                                            },
                                            child: Text(
                                              'Play Now',
                                              style: Theme.of(Navigation
                                                      .instance
                                                      .navigatorKey
                                                      .currentContext!)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                    color: Colors.black,
                                                    // fontSize: 2.2.h,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      data.video_news[0].title ??
                                          'It is a long established fact that a reader will be distracted by the readable content of a',
                                      style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
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
                                      Jiffy(data.video_news[0].publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow(),
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
                                    SizedBox(
                                      height: 1.h,
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
                                return GestureDetector(
                                  onTap: () {
                                    // if (data.profile?.is_plan_active ?? false) {
                                      Navigation.instance.navigate(
                                          '/videoPlayer',
                                          args: '${item.youtube_id},${2}');
                                    // } else {
                                    //   Constance.showMembershipPrompt(
                                    //       context, () {});
                                    // }
                                  },
                                  child: VideoReportItem(item: item),
                                );
                              },
                              separatorBuilder: (cont, inde) {
                                if (inde == 0) {
                                  return Container();
                                }
                                return SizedBox(
                                  height: 1.h,
                                  child: Divider(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    thickness: 0.3.sp,
                                  ),
                                );
                              },
                              itemCount: data.video_news.length),
                          // SizedBox(
                          //   height: 2.h,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     CustomButton(
                          //         txt: 'Load More',
                          //         onTap: () {
                          //           page++;
                          //           fetchMoreData();
                          //         }),
                          //   ],
                          // ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: SizedBox(
                          height: 2.h,
                          width: 2.h,
                          child: const CircularProgressIndicator()),
                    ),
            );
          }),
        ),
      ),
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

  void fetchData() async {
    final response =
        await ApiProvider.instance.getVideoMoreNews(widget.category, 10, 1);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setVideoNews(response.videos ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
    }
  }

  void fetchMoreData() async {
    final response =
        await ApiProvider.instance.getVideoMoreNews(widget.category, 10, page);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .addVideoNews(response.videos ?? []);
      // _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    } else {
      // _refreshController.refreshFailed();
      _refreshController.loadFailed();
    }
  }
}
