import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/classified.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'alert.dart';

class ClassifiedMyListCard extends StatelessWidget {
  final Classified current;
  bool like;
  final String result;
  final int selected;
  final Function(String s) fetchClassified;

  ClassifiedMyListCard(
      {Key? key,
      required this.current,
      required this.like,
      required this.selected,
      required this.fetchClassified,
      required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, _) {
      return GestureDetector(
        onTap: () {
          Navigation.instance.navigate('/classifiedDetails', args: current.id);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 60.w,
                        child: Text(
                          current.title ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                                  fontSize: 14.sp,
                                  color: Constance.primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                      selected == 3
                          ? PopupMenuButton<int>(
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
                                if (value == 1) {
                                  updateClassified(current.id);
                                } else {
                                  deleteClassified(current.id);
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
                                setAsFavourite(current.id, 'classified');
                                _(() {
                                  like = !like;
                                });
                                return like;
                              },
                              circleColor: const CircleColor(
                                start: Colors.red,
                                end: Colors.black87,
                              ),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  like
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  color:
                                      like ? Constance.thirdColor : Colors.grey,
                                  size: 3.h,
                                );
                              },
                              likeCount: 665,
                              countBuilder:
                                  (int? count, bool isLiked, String text) {
                                var color = like
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
                // current.price == null || current.price == 0
                //     ? Container()
                //     : SizedBox(
                //         height: 0.h,
                //       ),
                current.price == null
                    ? Container()
                    : Text(
                        'Rs:${current.price}' ?? '0',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Constance.thirdColor,
                            fontWeight: FontWeight.bold),
                      ),
                SizedBox(
                  height: 1.h,
                ),
                ReadMoreText(
                  current.description ?? "",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontSize: 11.sp,
                        // fontWeight: FontWeight.bold,
                      ),
                  trimLines: 3,
                  colorClickableText: Constance.secondaryColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.black54,
                      size: 15.sp,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      '${current.total_views} views',
                      // overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.black54,
                      size: 15.sp,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      current.locality?.name ?? "",
                      // overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  getStatusText(current.status!),
                  // overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: getStatusColour(current.status!),
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

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }

  String getStatusText(int i) {
    switch (i) {
      case 1:
        return 'Accepted';
      case 2:
        return 'Rejected';
      default:
        return 'Pending For Approval';
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
