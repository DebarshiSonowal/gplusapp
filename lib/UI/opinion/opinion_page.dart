import 'package:badges/badges.dart' as bd;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/opinion.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Components/opinion_page_item.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class OpinionPage extends StatefulWidget {
  const OpinionPage({Key? key}) : super(key: key);

  @override
  State<OpinionPage> createState() => _OpinionPageState();
}

class _OpinionPageState extends State<OpinionPage> {
  int page_no = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final ScrollController controller = ScrollController();

  bool isEmpty = false;

  void _onRefresh() async {
    // monitor network fetch
    setState(() {
      page_no = 1;
    });
    final response = await ApiProvider.instance.getOpinion(11, page_no);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setOpinions(response.opinion ?? []);
      setState(() {
        isEmpty = (response.opinion?.isEmpty ?? false) ? true : false;
      });
      _refreshController.refreshCompleted();
    } else {
      setState(() {
        isEmpty=true;
      });
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    setState(() {
      page_no++;
    });
    // monitor network fetch
    final response = await ApiProvider.instance.getOpinion(11, page_no);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setOpinions(response.opinion ?? []);
      _refreshController.loadComplete();
    } else {
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      appBar: Constance.buildAppBar2("opinion"),
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
              body = const Text("No more Data");
            }
            return SizedBox(
              height: 30.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Container(
            height: MediaQuery.of(context).size.height - 6.h,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 0.h, bottom: 4.h),
            // color: Colors.grey.shade200,
            child: data.opinions.isNotEmpty
                ? SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.fifthColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 5.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.newspaper,
                                color: Storage.instance.isDarkMode
                                    ? Constance.secondaryColor
                                    : Colors.white,
                                size: 4.h,
                              ),
                              Text(
                                ' Opinions',
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      // fontSize: 2.2.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigation.instance.navigate('/opinionDetails',
                                args:
                                    '${data.opinions[0].seo_name?.trim()},${data.opinions[0].category_gallery?.id}');
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Container(
                              height: 30.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(
                                    data.opinions[0].image_file_name ??
                                        'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (data.profile?.is_plan_active ?? false) {
                              Navigation.instance.navigate('/opinionDetails',
                                  args:
                                      '${data.opinions[0].seo_name?.trim()},${data.opinions[0].category_gallery?.id}');
                            } else {
                              Constance.showMembershipPrompt(context, () {});
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              data.opinions[0].title ??
                                  'It is a long established fact that a reader will be distracted by the readable content of a',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.primaryColor,
                                    // fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   data.opinions[0].user?.name ?? 'G Plus Admin',
                              //   style: Theme.of(Navigation
                              //           .instance.navigatorKey.currentContext!)
                              //       .textTheme
                              //       .headline5
                              //       ?.copyWith(
                              //         color: Storage.instance.isDarkMode
                              //             ? Colors.white
                              //             : Constance.fifthColor,
                              //         // fontSize: 2.2.h,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              // ),
                              Image.asset(
                                Constance.authorIcon,
                                scale: 35,
                                color: Constance.secondaryColor,
                              ),
                              SizedBox(
                                width: 0.7.w,
                              ),
                              Expanded(
                                child: GestureDetector (
                                  onTap: () {
                                    Navigation.instance.navigate('/authorPage',
                                        args: data.opinions[0].user_id);
                                  },
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: data.opinions[0].user?.name ??
                                              "G Plus",
                                          style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                            color: Storage.instance.isDarkMode
                                                ? Constance.secondaryColor
                                                : Constance.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                          ' , ${Jiffy(data.opinions[0].publish_date?.split(" ")[0], "yyyy-MM-dd").format("dd MMM,yyyy")}',
                                          style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                            color: Storage.instance.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            // fontSize: 2.2.h,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Text(
                              //   Jiffy(
                              //           data.opinions[0].publish_date
                              //               ?.split(" ")[0],
                              //           "yyyy-MM-dd")
                              //       .format("dd/MM/yyyy"),
                              //   style: Theme.of(Navigation
                              //           .instance.navigatorKey.currentContext!)
                              //       .textTheme
                              //       .headline5
                              //       ?.copyWith(
                              //         color: Colors.black,
                              //         // fontSize: 2.2.h,
                              //         // fontWeight: FontWeight.bold,
                              //       ),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Divider(
                            color: Colors.black,
                            thickness: 0.5.sp,
                          ),
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (cont, count) {
                              var item = data.opinions[count];
                              if (count != 0) {
                                return OpionionPageItem(
                                  item: item,
                                  data: data,
                                );
                              } else {
                                return Container();
                              }
                            },
                            separatorBuilder: (cont, inde) {
                              if (inde != 0) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.w),
                                  child: SizedBox(
                                    height: 1.h,
                                    child: Divider(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      thickness: 0.3.sp,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                            itemCount: data.opinions.length),
                        // SizedBox(
                        //   height: 1.h,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     CustomButton(
                        //         txt: 'Load More',
                        //         onTap: () {
                        //           page_no++;
                        //           fetchMoreOpinions();
                        //         }),
                        //   ],
                        // ),
                        SizedBox(
                          height: 3.h,
                        ),
                      ],
                    ),
                  )
                : Lottie.asset(
                    isEmpty ? Constance.noDataLoader : Constance.searchingIcon,
                  ),
          );
        }),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .setCurrent(0);
          Navigation.instance.navigate('/main');
        },
        child: Image.asset(
          Constance.logoIcon,
          fit: BoxFit.fill,
          scale: 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return bd.Badge(
              badgeColor: Constance.secondaryColor,
              badgeContent: Text(
                '${data.notifications.length}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Constance.thirdColor,
                    ),
              ),
              child: const Icon(Icons.notifications),
            );
          }),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search',args: "");
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // fetchOpinions();
    controller.addListener(() {
      if (controller.position.atEdge) {
        print('At edge');
        if (controller.position.pixels == 0) {
          _refreshController.requestRefresh();
        } else {
          print('At the bottom');
         // _refreshController.requestLoading();
        setState(() {
          page_no++;
        });
          fetchMoreOpinions();
        }
      }
    });
  }

  void fetchOpinions() async {
    final response = await ApiProvider.instance.getOpinion(11, page_no);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setOpinions(response.opinion ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
    }
  }

  void fetchMoreOpinions() async {
    final response = await ApiProvider.instance.getOpinion(11, page_no);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setMoreOpinions(response.opinion ?? []);
      _refreshController.loadComplete();
    } else {
      // _refreshController.refreshFailed();
      _refreshController.loadFailed();
    }
  }
}
