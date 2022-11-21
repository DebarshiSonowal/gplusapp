import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class AllImagePage extends StatefulWidget {
  final int id;

  AllImagePage(this.id);

  @override
  State<AllImagePage> createState() => _AllImagePageState();
}

class _AllImagePageState extends State<AllImagePage> {
  bool like = false, dislike = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        like = Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .guwahatiConnect[widget.id]
                .is_liked ??
            false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      body: Consumer<DataProvider>(builder: (context, data, _) {
        return Container(
          padding: EdgeInsets.only(top: 2.h),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  // height: 30.h,
                  width: double.infinity,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.guwahatiConnect[widget.id].user
                                            ?.name ??
                                        "GPlus Author",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                          color: Storage.instance.isDarkMode
                                              ? Colors.white
                                              : Constance.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 0.7.h,
                                  ),
                                  Text(
                                    Jiffy(
                                                data.guwahatiConnect[widget.id]
                                                    .updated_at,
                                                "yyyy-MM-dd")
                                            .fromNow() ??
                                        '${15} mins ago' ??
                                        "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          color: Storage.instance.isDarkMode
                                              ? Colors.white70
                                              : Colors.black45,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.more_vert,
                                color: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        ReadMoreText(
                          data.guwahatiConnect[widget.id].question ?? "",
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    // fontWeight: FontWeight.bold,
                                  ),
                          trimLines: 5,
                          colorClickableText: Constance.secondaryColor,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.separated(
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      data.guwahatiConnect[widget.id].attachment?.length ?? 1,
                  itemBuilder: (context, count) {
                    var current =
                        data.guwahatiConnect[widget.id].attachment![count];
                    return GestureDetector(
                      onTap: () {
                        Navigation.instance.navigate('/viewImage',
                            args: current.file_name ?? Constance.defaultImage);
                      },
                      child: Container(
                        height: 40.h,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.w, vertical: 1.h),
                        child: CachedNetworkImage(
                          placeholder: (cont, _) {
                            return Image.asset(
                              Constance.logoIcon,
                              // color: Colors.black,
                            );
                          },
                          imageUrl: current.file_name ?? Constance.defaultImage,
                          fit: BoxFit.fitHeight,
                          errorWidget: (cont, _, e) {
                            return Image.network(
                              Constance.defaultImage,
                              fit: BoxFit.fitWidth,
                            );
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 4.h,
                      width: double.infinity,
                      child: Center(
                        child: Divider(
                          thickness: 0.1.h,
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 2.h,
                  child: Center(
                    child: Divider(
                      thickness: 0.05.h,
                      color: Storage.instance.isDarkMode
                          ? Colors.white70
                          : Colors.black26,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${data.guwahatiConnect[widget.id].total_liked} likes' ??
                            "",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                      // Text(
                      //   '${data.guwahatiConnect[widget.id].total_disliked} dislikes' ??
                      //       "",
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .headline6
                      //       ?.copyWith(
                      //     color: Storage.instance.isDarkMode?Colors.white:Colors.black,
                      //     // fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Text(
                        '${data.guwahatiConnect[widget.id].total_comment} comments' ??
                            "",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                SizedBox(
                  height: 2.h,
                  child: Center(
                    child: Divider(
                      thickness: 0.05.h,
                      color: Storage.instance.isDarkMode
                          ? Colors.white70
                          : Colors.black26,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Material(
                            type: MaterialType.transparency,
                            child: IconButton(
                              onPressed: () {
                                postLike(data.guwahatiConnect[widget.id].id, 1);
                                setState(() {
                                  like = !like;
                                  if (dislike) {
                                    dislike = !like;
                                  }
                                });
                                debugPrint('${like}');
                              },
                              splashRadius: 20.0,
                              splashColor: !like
                                  ? Constance.secondaryColor
                                  : Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Constance.primaryColor,
                              icon: Icon(
                                Icons.thumb_up,
                                color: like
                                    ? Constance.secondaryColor
                                    : Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.primaryColor,
                              ),
                            ),
                          ),
                          // Material(
                          //   type: MaterialType.transparency,
                          //   child: IconButton(
                          //     onPressed: () {
                          //       postLike(data.guwahatiConnect[widget.id].id, 0);
                          //       setState(() {
                          //         dislike = !dislike;
                          //         if (like) {
                          //           like = !dislike;
                          //         }
                          //       });
                          //     },
                          //     splashRadius: 20.0,
                          //     splashColor: !dislike
                          //         ? Constance.secondaryColor
                          //         : Constance.primaryColor,
                          //     icon: Icon(
                          //       Icons.thumb_down,
                          //       color: dislike
                          //           ? Constance
                          //           .secondaryColor
                          //           : Constance
                          //           .primaryColor,
                          //     ),
                          //   ),
                          // ),
                          Material(
                            type: MaterialType.transparency,
                            child: IconButton(
                              onPressed: () {},
                              splashRadius: 20.0,
                              splashColor: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Constance.secondaryColor,
                              icon: Icon(
                                Icons.comment,
                                color: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Constance.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void postLike(id, is_like) async {
    final response =
        await ApiProvider.instance.postLike(id, is_like, 'guwahati-connect');
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "Post Liked");
      // fetchGuwahatiConnect();
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
}
