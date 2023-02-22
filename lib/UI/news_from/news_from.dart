import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Model/article.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Components/news_from_more_item.dart';
import '../../Components/news_from_suggestions.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class NewsFrom extends StatefulWidget {
  final String categ;

  const NewsFrom(this.categ);

  @override
  State<NewsFrom> createState() => _NewsFromState();
}

class _NewsFromState extends State<NewsFrom> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController controller = ScrollController();
  int skip = 5;

  @override
  void initState() {
    super.initState();
    fetchContent();
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          _refreshController.requestRefresh();
        } else {
          // print('At the bottom');
          _refreshController.requestLoading();
        }
      }
    });
  }

  void _onRefresh() async {
    setState(() {
      skip = 10;
    });
    // monitor network fetch
    final response = await ApiProvider.instance.getArticle(widget.categ);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setNewsFrom(response.articles ?? []);
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
    skip = skip * 2;
    fetchMoreContent();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar("news_from",true),
      backgroundColor: Storage.instance.isDarkMode?Colors.black:Colors.white,
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
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: data.news_from.isNotEmpty
                ? SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            capitalize(widget.categ) == "Entertainment"
                                ? Image.asset(
                                    Constance.entertainmentIcon,
                                    color: Constance.secondaryColor,
                                    scale: 27,
                                  )
                                : Icon(
                                    Icons.star,
                                    color: Constance.secondaryColor,
                                    size: 4.h,
                                  ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Text(
                              capitalize(widget.categ) == "Buzz"
                                  ? "Featured"
                                  : capitalize(widget.categ),
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
                                data.news_from[0].image_file_name ??
                                    'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.7.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (data.profile?.is_plan_active ?? false) {
                              Navigation.instance.navigate('/story',
                                  args:
                                      '${widget.categ},${data.news_from[0].seo_name}');
                            } else {
                              Constance.showMembershipPrompt(context, () {});
                            }
                          },
                          child: Text(
                            data.news_from[0].title ??
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
                                    args: data.news_from[0].author);
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: data.news_from[0].author_name ??
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
                                          ' , ${Jiffy(data.news_from[0].publish_date?.split(" ")[0], "yyyy-MM-dd").format("dd MMM,yyyy")}',
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
                        Divider(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          thickness: 0.5.sp,
                        ),
                        newsfrom_suggestion(widget: widget, data: data,),
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



  String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  void fetchMoreContent() async {
    Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.getMoreArticle(widget.categ, 5, 1, skip);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .addNewsFrom(response.articles ?? []);
      // _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    } else {
      Navigation.instance.goBack();
      // _refreshController.refreshFailed();
      _refreshController.loadFailed();
    }
  }

  void fetchContent() async {
    final response = await ApiProvider.instance.getArticle(widget.categ);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setNewsFrom(response.articles ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
    }
  }
}


