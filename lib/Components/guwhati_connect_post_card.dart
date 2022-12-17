import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Components/three_images_widget.dart';
import 'package:gplusapp/Components/two_image_widget.dart';
import 'package:gplusapp/Model/comment.dart';
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
import 'comment_item.dart';
import 'comment_ui.dart';
import 'four_images_widget.dart';
import 'multiple_image_widget.dart';

class GuwahatiConnectPostCard extends StatelessWidget {
  GuwahatiConnect data;
  int count, type;
  bool like, dislike, is_mine;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final _searchQueryController = TextEditingController();
  final void Function() fetchGuwahatiConnect;
  final Function(int, int) postLike;
  final Function(int) showing;
  final ScrollController _controller = ScrollController();

  GuwahatiConnectPostCard(
    this.data,
    this.count,
    this.like,
    this.dislike,
    this.scaffoldKey,
    this.fetchGuwahatiConnect,
    this.postLike,
    this.showing,
    this.type,
    this.is_mine,
  );

  void _scrollDown() {
    Future.delayed(const Duration(seconds: 1), () {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

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
                        GestureDetector(
                          onTap:(){
                            showComments(count, context);
                          },
                          child: Text(
                            '${data.total_comment} comments' ?? "",
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      // fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ],
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
                  is_mine
                      ? Text(
                          statusText(data.status!),
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white70
                                        : Colors.black45,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        )
                      : Container(),
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
    _scrollDown();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return CommentUI(
          count: count,
          controller: _controller,
          searchQueryController: _searchQueryController,
          fetchGuwahatiConnect: () => fetchGuwahatiConnect(),
        );
      },
    ).then((value) {
      showing(1);
      fetchGuwahatiConnect();
    });
  }

  void postCommentLike(id, is_like) async {
    final response = await ApiProvider.instance.postCommentLike(id, is_like);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Post Liked");
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
        return TwoImagesWidget(attachment: attachment ?? []);
      case 3:
        return ThreeImagesWidget(attachment: attachment ?? []);
      case 4:
        return FourImagesWidget(attachment: attachment ?? []);
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
        return MultipleImageWidget(attachment: attachment ?? []);
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

  String statusText(int status) {
    switch (status) {
      case 1:
        return 'Accepted';
      case 2:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }
}

//  StatefulBuilder CommentItem(
//       Comment current, BuildContext context, bool liked) {
//     bool like = liked;
//     return StatefulBuilder(builder: (context, _) {
//       return SizedBox(
//         height: 16.h,
//         width: 40.w,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     current.name ?? "",
//                     style: Theme.of(context).textTheme.headline5?.copyWith(
//                       color: Storage.instance.isDarkMode
//                           ? Colors.black
//                           : Constance.primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   // Icon(
//                   //   Icons.menu,
//                   //   color: Colors.black,
//                   // ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 1.h,
//             ),
//             Row(
//               children: [
//                 Text(
//                   current.comment ?? "",
//                   style: Theme.of(context).textTheme.headline6?.copyWith(
//                     color: Colors.black,
//                     // fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 1.h,
//             ),
//             // Text(
//             //   "",
//             //   style: Theme.of(context)
//             //       .textTheme
//             //       .headline5
//             //       ?.copyWith(
//             //         color: Colors.black,
//             //         fontWeight: FontWeight.bold,
//             //       ),
//             // ),
//             // SizedBox(
//             //   height: 1.h,
//             // ),
//             SizedBox(
//               width: double.infinity,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       Material(
//                         type: MaterialType.transparency,
//                         child: IconButton(
//                           onPressed: () {
//                             _(() {
//                               like = !like;
//                             });
//                             postCommentLike(current.id, like ? 1 : 0);
//                           },
//                           splashRadius: 20.0,
//                           splashColor: Constance.secondaryColor,
//                           icon: Icon(
//                             Icons.thumb_up,
//                             color: like
//                                 ? Constance.secondaryColor
//                                 : Constance.primaryColor,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         '${like ? (current.like_count ?? 0 + 1) : current.like_count} likes' ??
//                             "",
//                         style: Theme.of(context).textTheme.headline6?.copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(
//               height: 1.h,
//             ),
//           ],
//         ),
//       );
//     });
//   }
