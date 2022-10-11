import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class OpinionPage extends StatefulWidget {
  const OpinionPage({Key? key}) : super(key: key);

  @override
  State<OpinionPage> createState() => _OpinionPageState();
}

class _OpinionPageState extends State<OpinionPage> {
  int page_no = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    page_no = 1;
    final response = await ApiProvider.instance.getOpinion(11, page_no);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setOpinions(response.opinion ?? []);
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    page_no++;
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
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      // drawer: BergerMenuMemPage(),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
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
            height: MediaQuery.of(context).size.height - 6.h,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 1.h, bottom: 4.h),
            // color: Colors.grey.shade200,
            child: data.opinions.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Constance.thirdColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 5.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.newspaper,
                                color: Colors.white,
                                size: 4.h,
                              ),
                              Text(
                                ' Opinions',
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Colors.white,
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
                                args: data.opinions[0].seo_name?.trim());
                          },
                          child: Padding(
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
                                    data.opinions[0].image_file_name ??
                                        'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigation.instance.navigate('/opinionDetails',
                                args: data.opinions[0].seo_name?.trim());
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
                                    color: Constance.primaryColor,
                                    // fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.opinions[0].author_name ?? 'GPlus Admin',
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Constance.thirdColor,
                                      // fontSize: 2.2.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                Jiffy(
                                        data.opinions[0].publish_date
                                            ?.split(" ")[0],
                                        "yyyy-MM-dd")
                                    .format("dd/MM/yyyy"),
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
                              return GestureDetector(
                                onTap: () {
                                  Navigation.instance.navigate(
                                      '/opinionDetails',
                                      args: item.seo_name?.trim());
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
                                              Jiffy(
                                                      item.publish_date
                                                          ?.split(" ")[0],
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
                                              style: Theme.of(Navigation
                                                      .instance
                                                      .navigatorKey
                                                      .currentContext!)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                    color: Constance.thirdColor,
                                                    // fontSize: 2.2.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (cont, inde) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: SizedBox(
                                  height: 1.h,
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 0.3.sp,
                                  ),
                                ),
                              );
                            },
                            itemCount: data.opinions.length),
                        // SizedBox(
                        //   height: 1.h,
                        //
                        // ),
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

  @override
  void initState() {
    super.initState();
    fetchOpinions();
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
}
