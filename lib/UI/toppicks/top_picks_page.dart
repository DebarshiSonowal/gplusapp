import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Model/top_picks.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class TopPicksPage extends StatefulWidget {
  const TopPicksPage({Key? key}) : super(key: key);

  @override
  State<TopPicksPage> createState() => _TopPicksPageState();
}

class _TopPicksPageState extends State<TopPicksPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchToppicks();
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {

        } else {
          // print('At the bottom');
          _refreshController.requestLoading();
        }
      }
    });
  }

  void _onRefresh() async {
    setState(() {
      page = 1;
    });
    // monitor network fetch
    final response = await ApiProvider.instance.getTopPicks(1);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeTopPicks(response.toppicks ?? []);
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
    setState(() {
      page++;
    });
    fetchMoreToppicks(page);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:Constance.buildAppBar2(),
      backgroundColor: Colors.white,
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
            color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            child: data.home_exclusive.isNotEmpty
                ? SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Icon(
                            //   Icons.star,
                            //   color: Constance.secondaryColor,
                            //   size: 4.h,
                            // ),
                            Text(
                              'Suggested for you',
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
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.w),
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
                                  data.home_toppicks[0].image_file_name ??
                                      'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
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
                              Navigation.instance.navigate('/story',
                                  args:
                                      '${data.home_toppicks[0].categories?.first.seo_name},${data.home_toppicks[0].seo_name}');
                            } else {
                              Constance.showMembershipPrompt(context, () {});
                            }
                          },
                          child: Text(
                            data.home_toppicks[0].title ??
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
                        SizedBox(
                          height: 1.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigation.instance.navigate('/authorPage',
                                args: data.home_toppicks[0].author_id);
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                Constance.authorIcon,
                                scale: 30,
                                color: Constance.secondaryColor,
                              ),
                              SizedBox(
                                width: 0.5.w,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${data.home_toppicks[0].author_name ?? "G Plus"}',
                                      style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            color: Constance.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' , ${Jiffy(data.home_toppicks[0].date?.split(" ")[0], "yyyy-MM-dd").format("dd MMM,yyyy")}',
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
                            ],
                          ),
                        ),
                        // Text(
                        //   '${data.home_toppicks[0].author_name ?? "G Plus Admin"}, ${Jiffy(data.home_exclusive[0].publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}',
                        //   style: Theme.of(Navigation
                        //           .instance.navigatorKey.currentContext!)
                        //       .textTheme
                        //       .headline5
                        //       ?.copyWith(
                        //         color: Storage.instance.isDarkMode
                        //             ? Colors.white
                        //             : Colors.black,
                        //         // fontSize: 2.2.h,
                        //         // fontWeight: FontWeight.bold,
                        //       ),
                        // ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.5.sp,
                        ),
                        toppickSuggestions(data:data),
                        // SizedBox(
                        //   height: 2.h,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     CustomButton(
                        //         txt: 'Load More',
                        //         onTap: () {
                        //           setState(() {
                        //             page++;
                        //           });
                        //           fetchMoreToppicks(page);
                        //         }),
                        //   ],
                        // ),
                        SizedBox(
                          height: 3.h,
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
    );
  }

  void fetchToppicks() async {
    final response = await ApiProvider.instance.getTopPicks(1);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeTopPicks(response.toppicks ?? []);
    }
  }

  void fetchMoreToppicks(page) async {
    final response = await ApiProvider.instance.getTopPicks(page);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .addHomeTopPicks(response.toppicks ?? []);
      _refreshController.loadComplete();
    }else{
      _refreshController.loadFailed();
    }
  }
}

class toppickSuggestions extends StatelessWidget {
  const toppickSuggestions({
    Key? key, required this.data,
  }) : super(key: key);
  final DataProvider data;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (cont, count) {
        var item = data.home_toppicks[count];
        if (count != 0) {
          return SuggestedForYouCard(
            item: item,
            data: data,
          );
        } else {
          return Container();
        }
      },
      separatorBuilder: (cont, inde) {
        if (inde == 0) {
          return Container();
        } else {
          return SizedBox(
            height: 1.h,
            child: Divider(
              color: Storage.instance.isDarkMode
                  ? Colors.white
                  : Colors.black,
              thickness: 0.3.sp,
            ),
          );
        }
      },
      itemCount: data.home_toppicks.length,
    );
  }
}

class SuggestedForYouCard extends StatelessWidget {
  const SuggestedForYouCard({
    Key? key,
    required this.item,
    required this.data,
  }) : super(key: key);

  final TopPicks item;
  final DataProvider data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.profile?.is_plan_active ?? false) {
          Navigation.instance.navigate('/story',
              args: '${item.categories?.first.seo_name},${item.seo_name}');
        } else {
          Constance.showMembershipPrompt(context, () {});
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        ),
        height: 20.h,
        width: MediaQuery.of(context).size.width - 7.w,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  height: 17.7.h,
                  width: 45.w,
                  imageUrl: item.image_file_name ?? '',
                  fit: BoxFit.fill,
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  errorWidget: (cont, _, e) {
                    // print(e);
                    print(_);
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              width: 4.w,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title ?? "",
                    maxLines: 6,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor),
                  ),
                  // SizedBox(
                  //   height: 5.h,
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  Spacer(),
                  Text(
                    Jiffy(item.date?.split(" ")[0] ?? "", "yyyy-MM-dd")
                        .format("dd MMM,yyyy"),
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    item.author_name ?? "G Plus News",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
