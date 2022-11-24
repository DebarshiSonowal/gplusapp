import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/guwahati_connect.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'alert.dart';

class GuwahatiConnectPostCard extends StatelessWidget {
  GuwahatiConnect data;
  int count, type;
  bool like, dislike;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final _searchQueryController = TextEditingController();
  final void Function() fetchGuwahatiConnect;
  final Function(int, int) postLike;
  final Function(int) showing;

  GuwahatiConnectPostCard(
      this.data,
      this.count,
      this.like,
      this.dislike,
      this.scaffoldKey,
      this.fetchGuwahatiConnect,
      this.postLike,
      this.showing,
      this.type);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatefulBuilder(builder: (context, _) {
          return Card(
            elevation: 3,
            color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.user?.name ?? "G Plus Author",
                          style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        (data.is_post_by_me ?? false)
                            ? PopupMenuButton<int>(
                                color: Constance.secondaryColor,
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuItem<int>>[
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          'Edit',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(color: Colors.black),
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
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          'Delete',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (int value) {
                                  // setState(() {});
                                  switch (value) {
                                    case 2:
                                      deletePost(data.id!);
                                      break;
                                    default:
                                      Navigation.instance.navigate(
                                          '/editAskAQuestion',
                                          args: '${type},${count}');
                                      break;
                                  }
                                },
                                // color: Colors.white,
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Constance.primaryColor,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  data.attachment?.isEmpty ?? false
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: SizedBox(
                            // height: 35.h,
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                // Navigation.instance.goBack();
                                (data.attachment?.length ?? 1) > 1
                                    ? showAllImages(count)
                                    : showThisImage(
                                        data.attachment![0].file_name ??
                                            Constance.defaultImage);
                              },
                              child: (data.attachment?.length ?? 1) > 1
                                  ? getGridBasedOnNumbers(
                                      data.attachment, context)
                                  : CachedNetworkImage(
                                      placeholder: (cont, _) {
                                        return Image.asset(
                                          Constance.logoIcon,
                                          // color: Colors.black,
                                        );
                                      },
                                      imageUrl:
                                          data.attachment![0].file_name ?? "",
                                      fit: BoxFit.fill,
                                      errorWidget: (cont, _, e) {
                                        return Image.network(
                                          Constance.defaultImage,
                                          fit: BoxFit.fitWidth,
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 1.h,
                  ),
                  ReadMoreText(
                    data.question ?? "",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
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
                  // SizedBox(
                  //   height: 2.h,
                  //   child: Center(
                  //     child: Divider(
                  //       thickness: 0.05.h,
                  //       color: Storage.instance.isDarkMode
                  //           ? Colors.white70
                  //           : Colors.black26,
                  //     ),
                  //   ),
                  // ),
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
                        Row(
                          children: [
                            Text(
                              '${like ? ((data.total_liked ?? 0) + 1) : data.total_liked} likes' ??
                                  "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        // Text(
                        //   '${dislike ? ((data.total_disliked ?? 0) + 1) : data.total_disliked} dislikes' ??
                        //       "",
                        //   style: Theme.of(context).textTheme.headline6?.copyWith(
                        //         color: Storage.instance.isDarkMode
                        //             ? Colors.white
                        //             : Colors.black,
                        //         // fontWeight: FontWeight.bold,
                        //       ),
                        // ),
                        Text(
                          '${data.total_comment} comments' ?? "",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 0.5.h,
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  //   child: Center(
                  //     child: Divider(
                  //       thickness: 0.05.h,
                  //       color: Storage.instance.isDarkMode
                  //           ? Colors.white70
                  //           : Colors.black26,
                  //     ),
                  //   ),
                  // ),
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
                                  postLike(data.id!, 1);
                                  _(() {
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
                            Material(
                              type: MaterialType.transparency,
                              child: IconButton(
                                onPressed: () {
                                  showComments(count, context);
                                },
                                splashRadius: 20.0,
                                splashColor: Constance.secondaryColor,
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
                        Text(
                          Jiffy(data.updated_at, "yyyy-MM-dd hh:mm:ss")
                                  .fromNow() ??
                              '${15} mins ago' ??
                              "",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white70
                                        : Colors.black45,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void showComments(count, context) {
    showing(0);
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, _) {
          return Consumer<DataProvider>(builder: (context, data, __) {
            return Card(
              elevation: 3,
              color: Storage.instance.isDarkMode
                  ? Colors.white
                  : Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                // side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 1.h),
                height: 70.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 5.h,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigation.instance.goBack();
                            },
                            icon: Icon(
                              Icons.menu,
                              color: Storage.instance.isDarkMode
                                  ? Colors.black
                                  : Constance.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Comments",
                            style:
                                Theme.of(context).textTheme.headline3?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.black
                                          : Constance.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      // height: 35.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                data.guwahatiConnect[count].comments.length,
                            itemBuilder: (cont, ind) {
                              var current =
                                  data.guwahatiConnect[count].comments[ind];
                              return SizedBox(
                                height: 16.h,
                                width: 40.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            current.name ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: Storage
                                                          .instance.isDarkMode
                                                      ? Colors.black
                                                      : Constance.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          // Icon(
                                          //   Icons.menu,
                                          //   color: Colors.black,
                                          // ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          current.comment ?? "",
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
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    // Text(
                                    //   "",
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .headline5
                                    //       ?.copyWith(
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    // ),
                                    // SizedBox(
                                    //   height: 1.h,
                                    // ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Material(
                                                type: MaterialType.transparency,
                                                child: IconButton(
                                                  onPressed: () {
                                                    postCommentLike(
                                                        current.id, 1);
                                                  },
                                                  splashRadius: 20.0,
                                                  splashColor:
                                                      Constance.secondaryColor,
                                                  icon: Icon(
                                                    Icons.thumb_up,
                                                    color: current.is_liked
                                                        ? Constance
                                                            .secondaryColor
                                                        : Constance
                                                            .primaryColor,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${current.like_count} likes' ??
                                                    "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 1.h,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                    Container(
                      height: 8.h,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 0.5.h),
                            child: TextField(
                              controller: _searchQueryController,
                              autofocus: false,
                              decoration: InputDecoration(
                                hintText: "Write a comment",
                                border: InputBorder.none,
                                hintStyle:
                                    const TextStyle(color: Colors.black26),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (_searchQueryController
                                        .text.isNotEmpty) {
                                      // search(_searchQueryController.text);
                                      _(() {
                                        postComment(
                                            data.guwahatiConnect[count].id,
                                            'guwahati-connect',
                                            _searchQueryController.text);
                                      });
                                    } else {
                                      showError('Enter something to search');
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(color: Colors.black),
                              onChanged: (query) => {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
      },
    ).then((value) {
      showing(1);
    });
  }

  void postCommentLike(id, is_like) async {
    final response = await ApiProvider.instance.postCommentLike(id, is_like);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Post Liked");
      fetchGuwahatiConnect();
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

  void postComment(int? id, String s, String text) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.postComment(id, s, text);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      fetchGuwahatiConnect();
      _searchQueryController.text = '';
    } else {
      Navigation.instance.goBack();
    }
  }

  showAllImages(data) {
    Navigation.instance.navigate('/allImagesPage', args: data);
  }

  showThisImage(String s) {
    Navigation.instance.navigate('/viewImage', args: s);
  }

  getGridBasedOnNumbers(List<GCAttachment>? attachment, BuildContext context) {
    switch (attachment?.length) {
      case 2:
        return StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      //                   <--- left side
                      color: Colors.grey.shade200,
                      width: 3.0,
                    ),
                    // top: BorderSide( //                    <--- top side
                    //   color: Colors.white,
                    //   width: 3.0,
                    // ),
                  ),
                ),
                child: CachedNetworkImage(
                  width: double.infinity,
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment![0].file_name) ?? "",
                  fit: BoxFit.fill,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment[1].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      case 3:
        return StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      //                   <--- left side
                      color: Colors.grey.shade200,
                      width: 3.0,
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment![0].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      //                   <--- left side
                      color: Colors.grey.shade200,
                      width: 3.0,
                    ),
                    // top: BorderSide( //                    <--- top side
                    //   color: Colors.white,
                    //   width: 3.0,
                    // ),
                  ),
                ),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment[1].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: const BoxDecoration(
                  border: Border(),
                ),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment[2].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      case 4:
        return StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      //                   <--- left side
                      color: Colors.grey.shade200,
                      width: 3.0,
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment![0].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment![1].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      //                   <--- left side
                      color: Colors.grey.shade200,
                      width: 3.0,
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment[2].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: const BoxDecoration(
                  border: Border(),
                ),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment[3].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      case 1:
        return CachedNetworkImage(
          placeholder: (cont, _) {
            return Image.asset(
              Constance.logoIcon,
              // color: Colors.black,
            );
          },
          imageUrl: (attachment![0].file_name) ?? "",
          fit: BoxFit.fitHeight,
          errorWidget: (cont, _, e) {
            return Image.network(
              Constance.defaultImage,
              fit: BoxFit.fitWidth,
            );
          },
        );
      default:
        return StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      //                   <--- left side
                      color: Colors.grey.shade200,
                      width: 3.0,
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment![0].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment[1].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      //                   <--- left side
                      color: Colors.grey.shade200,
                      width: 3.0,
                    ),
                    // top: BorderSide( //                    <--- top side
                    //   color: Colors.white,
                    //   width: 3.0,
                    // ),
                  ),
                ),
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: (attachment[2].file_name) ?? "",
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                decoration: const BoxDecoration(
                  border: Border(),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.3,
                      child: CachedNetworkImage(
                        placeholder: (cont, _) {
                          return Image.asset(
                            Constance.logoIcon,
                            // color: Colors.black,
                          );
                        },
                        imageUrl: (attachment[3].file_name) ?? "",
                        fit: BoxFit.fitHeight,
                        errorWidget: (cont, _, e) {
                          return Image.network(
                            Constance.defaultImage,
                            fit: BoxFit.fitWidth,
                          );
                        },
                      ),
                    ),
                    Text(
                      "View ${attachment.length - 4} More",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Constance.primaryColor,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  void deletePost(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.deleteGuwhatiConnect(id);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: "Post Deleted");
      fetchGuwahatiConnect();
    } else {
      Navigation.instance.goBack();
    }
  }
}
