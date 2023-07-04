import 'package:badges/badges.dart' as bd;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Components/bookmark_item_widget.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  bool isEmpty = false;

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance.fetchBookmarks();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setBookmarkItems(response.bookmarks);
      setState(() {
        isEmpty = (response.bookmarks.isEmpty ?? false) ? true : false;
      });
      _refreshController.refreshCompleted();
    } else {
      setState(() {
        isEmpty = true;
      });
      _refreshController.refreshFailed();
      // showError(response.message ?? "Something went wrong");
    }
    // final response = await ApiProvider.instance.getArticle('exclusive-news');
    // if (response.success ?? false) {
    //   Provider.of<DataProvider>(
    //           Navigation.instance.navigatorKey.currentContext ?? context,
    //           listen: false)
    //       .setHomeExecl(response.articles ?? []);
    //   _refreshController.refreshCompleted();
    // } else {
    //   _refreshController.refreshFailed();
    // }
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
      appBar: Constance.buildAppBar2("bookmark"),
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
              padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 5.w),
              child: data.bookmarks.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Constance.secondaryColor,
                                size: 4.h,
                              ),
                              Text(
                                'Bookmarks',
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
                          GestureDetector(
                            onTap: () {
                              if (data.bookmarks[0].has_permission ?? false) {
                                Navigation.instance.navigate('/story',
                                    args:
                                        '${data.bookmarks[0].cat_seo_name},${data.bookmarks[0].seo_name},bookmarks_page');
                              } else {
                                Constance.showMembershipPrompt(context, () {});
                              }
                            },
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
                                    data.bookmarks[0].image_file_name ??
                                        'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          // SizedBox(
                          //   height: 2.h,
                          // ),
                          GestureDetector(
                            onTap: () {
                              if (data.profile?.is_plan_active ?? false) {
                                Navigation.instance.navigate('/story',
                                    args:
                                        '${data.bookmarks[0].cat_seo_name},${data.bookmarks[0].seo_name},bookmarks_page');
                              } else {
                                Constance.showMembershipPrompt(context, () {});
                              }
                            },
                            child: Text(
                              data.bookmarks[0].title ??
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
                              // Navigation.instance.navigate('/authorPage',
                              //     args: data.bookmarks[0].user_id);
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
                                            '${data.bookmarks[0].author_name ?? "G Plus"}',
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
                                            ' , ${Jiffy.parse(data.bookmarks[0].publish_date?.split(" ")[0] ?? "", pattern: "yyyy-MM-dd").format(pattern: "dd MMM, yyyy")}',
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
                          //   '${data.bookmarks[0].author_name}, ${Jiffy(data.bookmarks[0].publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}',
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
                              var item = data.bookmarks[count];
                              if (count != 0) {
                                return GestureDetector(
                                  onTap: () {
                                    if (data.profile?.is_plan_active ?? false) {
                                      Navigation.instance.navigate('/story',
                                          args:
                                              '${item.cat_seo_name},${item.seo_name},bookmarks_page');
                                    } else {
                                      Constance.showMembershipPrompt(
                                          context, () {});
                                    }
                                  },
                                  child: BookmarkItemWidget(item: item),
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
                            itemCount: data.bookmarks.length,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    )
                  : (isEmpty
                      ? Image.asset(
                          "assets/images/no_data.png",
                          scale: 4,
                        )
                      : Lottie.asset(
                          Constance.searchingIcon,
                        )));
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
              // badgeColor: Constance.secondaryColor,
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

  void fetchBookmarks() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.fetchBookmarks();
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setBookmarkItems(response.bookmarks);
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
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

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () => fetchBookmarks());
  }
}
