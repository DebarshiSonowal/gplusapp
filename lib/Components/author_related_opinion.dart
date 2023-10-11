import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/UI/category/category_details.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/opinion.dart';
import '../Navigation/Navigate.dart';
import 'opinion_card.dart';

class AuthorRelatedOpinions extends StatefulWidget {
  final List<Opinion> opinions;
  final DataProvider data;
  final Function updateState;

  // final String title;
  AuthorRelatedOpinions({
    Key? key,
    required this.opinions,
    required this.data,
    required this.updateState,
    // required this.title,
  }) : super(key: key);

  @override
  State<AuthorRelatedOpinions> createState() => _AuthorRelatedOpinionsState();
}

class _AuthorRelatedOpinionsState extends State<AuthorRelatedOpinions> {
  int currentCount = 4;

  @override
  Widget build(BuildContext context) {
    return widget.opinions.isEmpty
        ? Container()
        : Container(
            // height: 22.h,
            width: double.infinity,
            // color: Constance.secondaryColor,
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    // widget.title.capitalize(),
                    'Editorials',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Constance.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: widget.opinions.length > currentCount
                          ? currentCount
                          : widget.opinions.length,
                      itemBuilder: (cont, count) {
                        var item = widget.opinions[count];
                        return GestureDetector(
                            onTap: () {
                              if (widget.data.profile?.is_plan_active ??
                                  false) {
                                Navigation.instance.navigate('/opinionDetails',
                                    args:
                                        '${item.seo_name?.trim()},${item.category_gallery?.id}');
                              } else {
                                showNotaMember(context);
                              }
                            },
                            child: OpinionCard(item: item));
                      },
                      separatorBuilder: (cont, inde) {
                        return SizedBox(
                          width: 2.w,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                widget.opinions.length > currentCount
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                currentCount = currentCount * 2;
                              });
                              // updateState();
                              debugPrint(currentCount.toString());
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'Read More',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Constance.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          // CustomButton(
                          //     txt: 'Load More',
                          //     onTap: () {
                          //       opinions.removeRange(0, 4);
                          //       updateState();
                          //       // page++;
                          //       // fetchMoreData();
                          //     }),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
  }

  void showNotaMember(context) {
    Constance.showMembershipPrompt(context, () {});
  }
}
