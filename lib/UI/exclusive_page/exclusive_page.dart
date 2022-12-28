import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/article.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Components/exclusive_item.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class ExclusivePage extends StatefulWidget {
  const ExclusivePage({Key? key}) : super(key: key);

  @override
  State<ExclusivePage> createState() => _ExclusivePageState();
}

class _ExclusivePageState extends State<ExclusivePage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int skip = 10;

  @override
  void initState() {
    super.initState();
    fetchGplus();
    // secureScreen();
  }

  void _onRefresh() async {
    setState(() {
      skip = 10;
    });
    // monitor network fetch
    final response = await ApiProvider.instance.getArticle('exclusive-news');
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeExecl(response.articles ?? []);
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
      appBar: buildAppBar(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              Constance.exclusiveIcon,
                              color: Constance.secondaryColor,
                              scale: 20,
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Text(
                              'G Plus Exclusive',
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
                        Container(
                          height: 30.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                data.home_exclusive[0].image_file_name ??
                                    'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (data.profile?.is_plan_active ?? false) {
                              Navigation.instance.navigate('/story',
                                  args:
                                      '${'exclusive-news'},${data.home_exclusive[0].seo_name}');
                            } else {
                              Constance.showMembershipPrompt(context, () {});
                            }
                          },
                          child: Text(
                            data.home_exclusive[0].title ??
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
                          height: 2.h,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              Constance.authorIcon,
                              scale: 35,
                              color: Constance.secondaryColor,
                            ),
                            SizedBox(
                              width: 0.5.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigation.instance.navigate('/authorPage',
                                    args: data.home_exclusive[0].author);
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: data.home_exclusive[0].author_name ??
                                          "G Plus",
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
                                      ' , ${Jiffy(data.home_exclusive[0].publish_date?.split(" ")[0], "yyyy-MM-dd").format("dd MMM,yyyy")}',
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
                          ],
                        ),
                        // Text(
                        //   '${data.home_exclusive[0].author_name}, ${Jiffy(data.home_exclusive[0].publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}',
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
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          thickness: 0.5.sp,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (cont, count) {
                            var item = data.home_exclusive[count];
                            if (count != 0) {
                              return GestureDetector(
                                onTap: () {
                                  if (data.profile?.is_plan_active ?? false) {
                                    Navigation.instance.navigate('/story',
                                        args:
                                            '${'exclusive-news'},${item.seo_name}');
                                  } else {
                                    Constance.showMembershipPrompt(
                                        context, () {});
                                  }
                                },
                                child: ExclusiveItem(item: item),
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
                          itemCount: data.home_exclusive.length,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                                txt: 'Load More',
                                onTap: () {
                                  skip = skip * 2;
                                  fetchMoreContent();
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
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
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return Badge(
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
            Navigation.instance.navigate('/search', args: "");
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void fetchGplus() async {
    final response = await ApiProvider.instance.getArticle('exclusive-news');
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeExecl(response.articles ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
    }
  }

  void fetchMoreContent() async {
    Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.getMoreArticle('exclusive-news', 5, 1, skip);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .addHomeExecl(response.articles ?? []);
      // _refreshController.refreshCompleted();
    } else {
      Navigation.instance.goBack();
      // _refreshController.refreshFailed();
    }
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
