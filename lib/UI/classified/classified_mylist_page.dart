import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
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

class ClassifiedMyList extends StatefulWidget {
  const ClassifiedMyList({Key? key}) : super(key: key);

  @override
  State<ClassifiedMyList> createState() => _ClassifiedMyListState();
}

class _ClassifiedMyListState extends State<ClassifiedMyList> {
  var current = 0;
  var selected = 3;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String result = '';
  final controller = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // secureScreen();
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
        .getClassified(getCategory(selected), result, controller.text);
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
      key: scaffoldKey,
      // drawer: BergerMenuMemPage(),
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          checkIt();
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
              body = const Text("No more Data");
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
            // color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
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
                              selected = 3;
                            });
                            fetchClassified(result);
                            // getFilter();
                          },
                          child: Container(
                            width: 48.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 5.w,
                            ),
                            color: selected == 3
                                ? Constance.secondaryColor
                                : Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Constance.forthColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.list,
                                  color: selected == 3
                                      ? Colors.black
                                      : Storage.instance.isDarkMode
                                          ? Constance.secondaryColor
                                          : Colors.white,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  'My listings',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: selected == 3
                                            ? Colors.black
                                            : Storage.instance.isDarkMode
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
                              color: Storage.instance.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       selected = 2;
                        //     });
                        //     fetchClassified(result);
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //       vertical: 1.h,
                        //       horizontal: 3.w,
                        //     ),
                        //     color: selected == 2
                        //         ? Constance.secondaryColor
                        //         : Constance.forthColor,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Icon(
                        //           FontAwesomeIcons.solidHeart,
                        //           color: selected == 2
                        //               ? Colors.black
                        //               : Colors.white,
                        //         ),
                        //         SizedBox(
                        //           width: 1.w,
                        //         ),
                        //         Text(
                        //           'Favourites',
                        //           style: Theme.of(context)
                        //               .textTheme
                        //               .headline6
                        //               ?.copyWith(
                        //                 color: selected == 2
                        //                     ? Colors.black
                        //                     : Colors.white,
                        //                 fontSize: 2.h,
                        //                 // fontWeight: FontWeight.bold,
                        //               ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: 2.w,
                          child: Center(
                            child: Container(
                              height: double.infinity,
                              width: 0.5.w,
                              color: Storage.instance.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
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
                            width: 48.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 5.w,
                            ),
                            color: selected == 2
                                ? Constance.secondaryColor
                                : Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Constance.forthColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: selected == 2
                                      ? Colors.black
                                      : Storage.instance.isDarkMode
                                          ? Constance.secondaryColor
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
                                            : Storage.instance.isDarkMode
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
                  data.classified.isEmpty
                      ? Center(
                        child: Lottie.asset(
                            Constance.searchingIcon,
                          ),
                      )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 1.h),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.classified.length,
                            itemBuilder: (cont, count) {
                              var current = data.classified[count];
                              bool like = selected == 2 ? true : false;
                              return StatefulBuilder(builder: (context, _) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigation.instance.navigate(
                                        '/classifiedDetails',
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 70.w,
                                                  child: Text(
                                                    current.title ?? "",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3
                                                        ?.copyWith(
                                                            color: Constance
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                                selected == 3
                                                    ? PopupMenuButton<int>(
                                                        itemBuilder: (BuildContext
                                                                context) =>
                                                            <
                                                                PopupMenuItem<
                                                                    int>>[
                                                          PopupMenuItem<int>(
                                                            value: 1,
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                SizedBox(
                                                                  width: 2.w,
                                                                ),
                                                                Text(
                                                                  'Edit',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6
                                                                      ?.copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          PopupMenuItem<int>(
                                                            value: 2,
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                SizedBox(
                                                                  width: 2.w,
                                                                ),
                                                                Text(
                                                                  'Delete',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6
                                                                      ?.copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                        onSelected:
                                                            (int value) {
                                                          if (value == 1) {
                                                            updateClassified(
                                                                current.id);
                                                          } else {
                                                            deleteClassified(
                                                                current.id);
                                                          }
                                                        },
                                                        color: Colors.white,
                                                        icon: const Icon(
                                                          Icons.more_horiz,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : LikeButton(
                                                        size: 2.5.h,
                                                        onTap: (val) async {
                                                          setAsFavourite(
                                                              current.id,
                                                              'classified');
                                                          _(() {
                                                            like = !like;
                                                          });
                                                          return like;
                                                        },
                                                        circleColor:
                                                            const CircleColor(
                                                          start: Colors.red,
                                                          end: Colors.black87,
                                                        ),
                                                        bubblesColor:
                                                            const BubblesColor(
                                                          dotPrimaryColor:
                                                              Color(0xff33b5e5),
                                                          dotSecondaryColor:
                                                              Color(0xff0099cc),
                                                        ),
                                                        likeBuilder:
                                                            (bool isLiked) {
                                                          return Icon(
                                                            like
                                                                ? FontAwesomeIcons
                                                                    .solidHeart
                                                                : FontAwesomeIcons
                                                                    .heart,
                                                            color: like
                                                                ? Constance
                                                                    .thirdColor
                                                                : Colors.grey,
                                                            size: 3.h,
                                                          );
                                                        },
                                                        likeCount: 665,
                                                        countBuilder:
                                                            (int? count,
                                                                bool isLiked,
                                                                String text) {
                                                          var color = like
                                                              ? Colors
                                                                  .deepPurpleAccent
                                                              : Colors.grey;
                                                          Widget result;
                                                          if (count == 0) {
                                                            result = Text(
                                                              "",
                                                              style: TextStyle(
                                                                  color: color),
                                                            );
                                                          } else {
                                                            result = Text(
                                                              '',
                                                              style: TextStyle(
                                                                  color: color),
                                                            );
                                                          }
                                                          return result;
                                                        },
                                                      ),
                                              ],
                                            ),
                                          ),
                                          current.price == null ||
                                                  current.price == 0
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
                                                          color: Constance
                                                              .thirdColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          ReadMoreText(
                                            current.description ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                            trimLines: 3,
                                            colorClickableText:
                                                Constance.secondaryColor,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: 'Show more',
                                            trimExpandedText: 'Show less',
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
                                                    '${current.total_views} views',
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
                                          Text(
                                            getStatusText(current.status!),
                                            // overflow: TextOverflow.clip,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: getStatusColour(
                                                      current.status!),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
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
                  'Hello ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.name}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Posting made easy! All you have to do is log in and click the “Post a Listing” button at the corner',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                // SizedBox(height: 1.h),
                // Text(
                //   'is simply dummy text of the printing and typesetting industry',
                //   style: Theme.of(context).textTheme.headline5?.copyWith(
                //         color: Colors.black,
                //         // fontWeight: FontWeight.bold,
                //       ),
                // ),
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
        .getClassified(getCategory(selected), result, controller.text);
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

  void setAsFavourite(int? id, String type) async {
    final response = await ApiProvider.instance.setAsFavourite(id, type);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Favourite Changed");
      fetchClassified(result);
    } else {
      showError("Something went wrong");
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

  void checkIt() async {
    if (Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.is_plan_active ??
        false) {
      final resp = await Navigation.instance.navigate('/postClassified');
      if (resp == null) {
        fetchClassified("");
      }
    } else {
      scaffoldKey.currentState?.showBottomSheet(
        (context) {
          return Consumer<DataProvider>(builder: (context, data, _) {
            return StatefulBuilder(builder: (context, _) {
              return Container(
                padding: EdgeInsets.only(
                    top: 1.h, right: 5.w, left: 5.w, bottom: 1.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                width: double.infinity,
                // height: 50.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigation.instance.goBack();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Text(
                      'Oops!',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: Constance.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 34.sp,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      'Sorry ${data.profile?.name}',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      '''Projected to be a smart city by 2025, Guwahati is a
major port on the banks of Brahmaputra, the capital
of Assam and the urban hub of the North East. This
metropolitan city is growing leaps and bounds, and 
for its unparalleled pace of growth, comes the need
for an unparalleled publication, that people call their''',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Do you want to be a member?',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: CustomButton(
                            txt: 'Yes, take me there',
                            onTap: () {
                              Navigation.instance.navigate('/beamember');
                            },
                            size: 12.sp,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Flexible(
                          child: CustomButton(
                            txt: '''No, I don't want it''',
                            onTap: () {
                              Navigation.instance.goBack();
                            },
                            color: Colors.black,
                            size: 12.sp,
                            fcolor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
          });
        },
        // context: context,
        backgroundColor: Colors.grey.shade100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
      );
    }
  }

  void updateClassified(id) {
    Navigation.instance.navigate('/editingAListing', args: id);
  }

  void deleteClassified(id) async {
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.deleteClassified(id);
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      Fluttertoast.showToast(msg: "Successfully deleted the post");
      // Navigation.instance.goBack();
      fetchClassified('');
    } else {
      // Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  String getStatusText(int i) {
    switch (i) {
      case 1:
        return 'Accepted';
      case 2:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  Color getStatusColour(int i) {
    switch (i) {
      case 1:
        return Constance.secondaryColor;
      case 2:
        return Constance.thirdColor;
      default:
        return Constance.primaryColor;
    }
  }
}