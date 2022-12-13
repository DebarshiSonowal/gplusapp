import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/comment.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'alert.dart';

class CommentItem extends StatelessWidget {
  final Comment current;
  final BuildContext context;
  final bool liked;
  bool like = false;

  CommentItem(
      {super.key,
      required this.current,
      required this.context,
      required this.liked}) {
    like = liked;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, _) {
      return SizedBox(
        height: 16.h,
        width: 40.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    current.name ?? "",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
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
                  style: Theme.of(context).textTheme.headline6?.copyWith(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                          onPressed: () {
                            _(() {
                              like = !like;
                            });
                            postCommentLike(current.id, like ? 1 : 0,_);
                          },
                          splashRadius: 20.0,
                          splashColor: Constance.secondaryColor,
                          icon: Icon(
                            Icons.thumb_up,
                            color: like
                                ? Constance.secondaryColor
                                : Constance.primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        '${like ? (current.like_count ?? 0 + 1) : current.like_count} likes' ??
                            "",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
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
    });
  }

  void postCommentLike(id, is_like, _) async {
    final response = await ApiProvider.instance.postCommentLike(id, is_like);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "");
      _((){
        like = is_like == 0 ? false : true;
      });
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
}
