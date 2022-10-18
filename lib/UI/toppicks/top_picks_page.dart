import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';
import '../Menu/berger_menu_member_page.dart';

class TopPicksPage extends StatefulWidget {
  const TopPicksPage({Key? key}) : super(key: key);

  @override
  State<TopPicksPage> createState() => _TopPicksPageState();
}

class _TopPicksPageState extends State<TopPicksPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    fetchToppicks();
  }

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance.getTopPicks();
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
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            child: data.home_exclusive.isNotEmpty
                ? SingleChildScrollView(
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
                              'Top Picks',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Constance.primaryColor,
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
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Container(
                            height: 30.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
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
                          height: 2.h,
                        ),
                        Row(
                          children: [
                            Container(
                              color: Constance.primaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 1.h),
                              child: Text(
                                'Guwahati',
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
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
                        SizedBox(
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (data.profile?.is_plan_active ?? false) {
                              Navigation.instance.navigate('/story',
                                  args:
                                      '${data.home_toppicks[0].categories?.first.seo_name},${data.home_toppicks[0].seo_name}');
                            } else {
                              Constance.showMembershipPrompt(context);
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
                                  color: Constance.primaryColor,
                                  // fontSize: 2.2.h,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          '${data.home_toppicks[0].author_name??"GPlus Admin"}, ${Jiffy(data.home_exclusive[0].publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}',
                          style: Theme.of(Navigation
                                  .instance.navigatorKey.currentContext!)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                color: Colors.black,
                                // fontSize: 2.2.h,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.5.sp,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (cont, count) {
                            var item = data.home_toppicks[count];
                            if (count != 0) {
                              return GestureDetector(
                                onTap: () {
                                  if (data.profile?.is_plan_active ?? false) {
                                    Navigation.instance.navigate('/story',
                                        args:
                                            '${item.categories?.first.seo_name},${item.seo_name}');
                                  } else {
                                    Constance.showMembershipPrompt(context);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.h),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: Colors.white,
                                  ),
                                  height: 20.h,
                                  width:
                                      MediaQuery.of(context).size.width - 7.w,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    item.image_file_name ?? '',
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
                                                  return Text(_);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            Text(
                                              // item.publish_date
                                              //         ?.split(" ")[0] ??
                                              //     "",
                                              Jiffy(
                                                      item.date
                                                              ?.split(" ")[0] ??
                                                          "",
                                                      "yyyy-MM-dd")
                                                  .format("dd/MM/yyyy"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                      color: Colors.black),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.title ?? "",
                                                maxLines: 3,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Constance
                                                            .primaryColor),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            Text(
                                              item.author_name ?? "GPlus News",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                  color: Colors.black,
                                  thickness: 0.3.sp,
                                ),
                              );
                            }
                          },
                          itemCount: data.home_toppicks.length,
                        ),
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

  void fetchToppicks() async {
    final response = await ApiProvider.instance.getTopPicks();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeTopPicks(response.toppicks ?? []);
    }
  }
}
