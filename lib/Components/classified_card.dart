import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/classified.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'alert.dart';

class ClassifiedCard extends StatelessWidget {
  final Classified current;
  bool like;
  var f = NumberFormat("###,###", "en_US");
  ClassifiedCard({Key? key, required this.current, required this.like})
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
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          current.title ?? "",
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      LikeButton(
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
                            color: like ? Constance.thirdColor : Colors.grey,
                            size: 3.h,
                          );
                        },
                        likeCount: 665,
                        countBuilder: (int? count, bool isLiked, String text) {
                          var color =
                              like ? Colors.deepPurpleAccent : Colors.grey;
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
                        height: 1.h,
                      ),
                current.price == null
                    ? Container()
                    : Text(
                        'Rs:${f.format(current.price?.toInt())}' ?? '0',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Constance.thirdColor,
                              // fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                SizedBox(
                  height: 1.h,
                ),
                ReadMoreText(
                  current.description ?? "",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black54,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
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
                      current.locality?.name ??
                          'NA',
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
              ],
            ),
          ),
        ),
      );
    });
  }

  void setAsFavourite(int? id, String type) async {
    final response = await ApiProvider.instance.setAsFavourite(id, type);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Added to favourites");
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
