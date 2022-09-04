import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Model/top_picks.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/gplus_execl_card.dart';
import '../../Components/toppicks_card.dart';
import '../../Components/video_card.dart';
import '../../Components/slider_home.dart';
import '../../Helper/Constance.dart';
import '../../Model/listing.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;

  String _poll = Constance.pollWeek[0];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  void _onRefresh() async {
    // monitor network fetch
    fetchOpinion();
    fetchGPlusExcl();
    fetchToppicks();
    final result = await ApiProvider.instance.getHomeAlbum();
    if (result.success ?? false) {
      Provider.of<DataProvider>(context, listen: false)
          .setHomeAlbum(result.articles ?? []);

      final response = await ApiProvider.instance.getWeekly();
      if (response.success ?? false) {
        Provider.of<DataProvider>(context, listen: false)
            .setVideoWeekly(response.videos ?? []);
        _refreshController.refreshCompleted();
      }
    } else {
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    // // monitor network fetch
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
      backgroundColor: Colors.grey.shade100,
      appBar: buildAppBar(),
      drawer: BergerMenuMemPage(),
      body: Padding(
        padding: EdgeInsets.only(top: 0.1.h),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("pull up load");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("release to load more");
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
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Consumer<DataProvider>(builder: (context, data, _) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade100,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CarouselWithIndicatorDemo(),
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 8.w),
                        child: Card(
                          color: Constance.thirdColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 0.5.h),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        'Big Deals\nand Offers',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl: Constance.kfc_offer,
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
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 25.h,
                        width: double.infinity,
                        color: Constance.secondaryColor,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'Top picks for you',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Expanded(
                              child: Container(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (cont, count) {
                                      var item = data.home_toppicks[count];
                                      return ToppicksCard(item: item);
                                    },
                                    separatorBuilder: (cont, inde) {
                                      return SizedBox(
                                        width: 10.w,
                                      );
                                    },
                                    itemCount: data.home_toppicks.length>4?4:data.home_toppicks.length),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      SizedBox(
                        height: 20.h,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.5.h),
                          child: Card(
                            color: Constance.primaryColor,
                            child: Center(
                              child: Text('AD'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          color: Colors.grey.shade800,
                          thickness: 0.1.h,
                        ),
                      ),
                      // SizedBox(
                      //   height: 1.h,
                      // ),
                      Container(
                        height: 30.h,
                        width: double.infinity,
                        // color: Constance.secondaryColor,
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'GPlus Exclusive',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Constance.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Expanded(
                              child: Container(
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (cont, count) {
                                      var item = data.home_exclusive[count];
                                      return GPlusExecCard(item: item);
                                    },
                                    separatorBuilder: (cont, inde) {
                                      return SizedBox(
                                        width: 10.w,
                                      );
                                    },
                                    itemCount: (data.home_exclusive.length>4?4:data.home_exclusive.length)),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'Read More',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          color: Colors.grey.shade800,
                          thickness: 0.1.h,
                        ),
                      ),
                      // SizedBox(
                      //   height: 0.5.h,
                      // ),
                      Container(
                        height: 35.h,
                        width: double.infinity,
                        // color: Constance.secondaryColor,
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'Video of the week',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Constance.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            SizedBox(
                              height: 20.h,
                              width: double.infinity,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (cont, count) {
                                    var item = data.home_weekly[count];
                                    return VideoCard(item: item);
                                  },
                                  separatorBuilder: (cont, inde) {
                                    return SizedBox(
                                      width: 10.w,
                                    );
                                  },
                                  itemCount: data.home_weekly.length>4?4:data.home_weekly.length),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'View All',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          color: Colors.grey.shade800,
                          thickness: 0.1.h,
                        ),
                      ),
                      Container(
                        // height: 35.h,
                        width: double.infinity,
                        // color: Constance.secondaryColor,
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Poll of the week',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                          color: Constance.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Container(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (cont, count) {
                                    var item = Constance.pollWeek[count];
                                    var value = Constance.pollValue[count];
                                    return Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor:
                                            Colors.grey.shade900,
                                        backgroundColor: Colors.grey.shade200,
                                      ),
                                      child: RadioListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        selected: _poll == item ? true : false,
                                        tileColor: Colors.grey.shade300,
                                        selectedTileColor: Colors.black,
                                        value: item,
                                        activeColor: Colors.black,
                                        groupValue: _poll,
                                        onChanged: (val) {
                                          setState(() {
                                            _poll = item;
                                          });
                                        },
                                        title: Text(
                                          item,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        secondary: Text(
                                          '${value}%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 1.7.h
                                                  // fontWeight: FontWeight.bold,
                                                  ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (cont, inde) {
                                    return SizedBox(
                                      width: 10.w,
                                    );
                                  },
                                  itemCount: Constance.pollWeek.length),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'View All',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Divider(
                          color: Colors.grey.shade800,
                          thickness: 0.1.h,
                        ),
                      ),
                      Container(
                        // height: 27.h,
                        width: double.infinity,
                        // color: Constance.secondaryColor,
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'Opinion',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Constance.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (cont, count) {
                                  var item = data.latestOpinions[count];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                          width: 0.5,
                                          color: Constance.primaryColor),
                                    ),
                                    child: Container(
                                      // padding: EdgeInsets.symmetric(
                                      //     horizontal: 3.w, vertical: 2.h),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        color: Colors.white,
                                      ),
                                      height: 12.h,
                                      width: MediaQuery.of(context).size.width -
                                          7.w,
                                      child: Column(
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w,
                                                    vertical: 2.h),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                  border: Border(
                                                    top: BorderSide(
                                                        width: 0.5,
                                                        color: Constance
                                                            .primaryColor),
                                                    bottom: BorderSide(
                                                        width: 0.5,
                                                        color: Constance
                                                            .primaryColor),
                                                    right: BorderSide(
                                                        width: 0.5,
                                                        color: Constance
                                                            .primaryColor),
                                                    left: BorderSide(
                                                        width: 0.5,
                                                        color: Constance
                                                            .primaryColor),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    item.title ?? "",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      item.author_name ?? "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          ?.copyWith(
                                                            color: Constance
                                                                .thirdColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    Text(
                                                      item.publish_date ?? "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                            // fontWeight: FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (cont, inde) {
                                  return SizedBox(
                                    width: 10.w,
                                  );
                                },
                                itemCount: (data.latestOpinions.length > 3
                                        ? data.latestOpinions.length / 3.toInt()
                                        : data.latestOpinions.length)
                                    .toInt(),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'Read More',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () {
      //     Navigation.instance.navigate('/bergerMenuMem');
      //   },
      //   icon: Icon(Icons.menu),
      // ),
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchPage<Listing>(
                items: Constance.listings,
                searchLabel: 'Search posts',
                suggestion: Center(
                  child: Text(
                    'Filter posts by name, descr',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                failure: const Center(
                  child: Text('No posts found :('),
                ),
                filter: (current) => [
                  current.title,
                  current.descr,
                  // person.age.toString(),
                ],
                builder: (data) => ListTile(
                  title: Text(
                    data.title ?? "",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(
                    data.descr ?? '',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // trailing: CachedNetworkImage(
                  //   imageUrl: data.image??'',
                  //   height: 20,
                  //   width: 20,
                  // ),
                ),
              ),
            );
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void fetchOpinion() async {
    final response = await ApiProvider.instance.getLatestOpinion();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLatestOpinions(response.opinion ?? []);
    }
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

  void fetchGPlusExcl() async {
    final response = await ApiProvider.instance.getArticle('exclusive-news');
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeExecl(response.articles ?? []);
    }
  }
}