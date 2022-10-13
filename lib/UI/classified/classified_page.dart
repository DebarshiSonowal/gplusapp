import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/custom_button.dart';
import '../../Components/slider_home.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class ClassifiedPage extends StatefulWidget {
  const ClassifiedPage({Key? key}) : super(key: key);

  @override
  State<ClassifiedPage> createState() => _ClassifiedPageState();
}

class _ClassifiedPageState extends State<ClassifiedPage> {
  var current = 0;
  var selected = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String result = '';
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!Storage.instance.isClassified) {
        showDialogBox();
      }
      fetchClassified('');
    });
    // Future.delayed(
    //     Duration.zero,
    //         () => Provider.of<DataProvider>(
    //         Navigation.instance.navigatorKey.currentContext ?? context,
    //         listen: false)
    //         .setCurrent(4));
  }

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance
        .getClassified(getCategory(current), result, controller.text);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassified(response.classifieds ?? []);
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: BergerMenuMemPage(),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigation.instance.navigate('/postClassified');
        },
        icon: Icon(Icons.add),
        label: Text(
          "Post a listing",
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
              ),
        ),
      ),
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
        // onLoading: _onLoading,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // color: Constance.forthColor,
                    height: 5.h,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // showSortByOption();
                            setState(() {
                              selected = 1;
                            });
                            getFilter();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 5.w,
                            ),
                            color: selected == 1
                                ? Constance.secondaryColor
                                : Constance.forthColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.list,
                                  color: selected == 1
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  'List by',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: selected == 1
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 2.h,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                          child: Center(
                            child: Container(
                              height: double.infinity,
                              width: 0.5.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 2;
                            });
                            fetchClassified(result);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 3.w,
                            ),
                            color: selected == 2
                                ? Constance.secondaryColor
                                : Constance.forthColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: selected == 2
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  'Favourites',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: selected == 2
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 2.h,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                          child: Center(
                            child: Container(
                              height: double.infinity,
                              width: 0.5.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 3;
                            });
                            fetchClassified(result);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 5.w,
                            ),
                            color: selected == 3
                                ? Constance.secondaryColor
                                : Constance.forthColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.person,
                                  color: selected == 3
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  'My List',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: selected == 3
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 2.h,
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
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Divider(
                      thickness: 0.07.h,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Card(
                      color: Colors.white,
                      child: TextField(
                        controller: controller,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Search",
                          labelStyle: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2.0,
                            ),
                          ),
                        ),
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          fetchClassified(result);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Divider(
                      thickness: 0.07.h,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.classified.length,
                      itemBuilder: (cont, count) {
                        var current = data.classified[count];
                        return GestureDetector(
                          onTap: () {
                            Navigation.instance.navigate('/classifiedDetails',
                                args: current.id);
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey.shade900,
                                width: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 70.w,
                                          child: Text(
                                            current.title ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3
                                                ?.copyWith(
                                                    color:
                                                        Constance.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        LikeButton(
                                          size: 2.5.h,
                                          circleColor: const CircleColor(
                                              start: Color(0xff00ddff),
                                              end: Color(0xff0099cc)),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor: Color(0xff33b5e5),
                                            dotSecondaryColor:
                                                Color(0xff0099cc),
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              FontAwesomeIcons.heart,
                                              color: isLiked
                                                  ? Colors.deepPurpleAccent
                                                  : Colors.grey,
                                              size: 2.5.h,
                                            );
                                          },
                                          likeCount: 665,
                                          countBuilder: (int? count,
                                              bool isLiked, String text) {
                                            var color = isLiked
                                                ? Colors.deepPurpleAccent
                                                : Colors.grey;
                                            Widget result;
                                            if (count == 0) {
                                              result = Text(
                                                "",
                                                style: TextStyle(color: color),
                                              );
                                            } else {
                                              result = Text(
                                                '',
                                                style: TextStyle(color: color),
                                              );
                                            }
                                            return result;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  current.price == null || current.price == 0
                                      ? Container()
                                      : SizedBox(
                                          height: 0.5.h,
                                        ),
                                  current.price == null
                                      ? Container()
                                      : Text(
                                          'Rs:${current.price}' ?? '0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              ?.copyWith(
                                                  color: Constance.thirdColor,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Text(
                                    current.description ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 5.h,
                                          child: Text(
                                            '4999 views',
                                            // overflow: TextOverflow.clip,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: Colors.black,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   height: 0.4.h,
                                  // ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 5.h,
                                          child: Text(
                                            current.locality?.name ??
                                                'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                                            // overflow: TextOverflow.clip,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: Colors.black,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   height: 1.h,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 1.h,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
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
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search');
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void showDialogBox() {
    Storage.instance.setClassified();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Post your listing',
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Constance.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.newspaper,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Hello ${Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ?? context,
                      listen: false).profile?.name}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                  ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                  ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                  ' remaining essentially unchanged',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchClassified(result) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance
        .getClassified(getCategory(current), result, controller.text);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassified(response.classifieds ?? []);

      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  getCategory(int current) {
    switch (current) {
      case 3:
        return "my-list";
      case 2:
        return "favourites";
      default:
        return "list-by";
    }
  }

  void getFilter() async {
    final result = await Navigation.instance.navigate('/filterPage');
    if (result != null) {
      fetchClassified(result);
    }
  }
}
