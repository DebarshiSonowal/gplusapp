import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/opinion.dart';
import '../Navigation/Navigate.dart';
import 'custom_button.dart';
import 'opinion_card.dart';

class AuthorRelatedOpinions extends StatelessWidget {
  final List<Opinion> opinions;
  final DataProvider data;
  int currentCount = 4;
  final Function updateState;
   AuthorRelatedOpinions(
      {Key? key, required this.opinions, required this.data, required this.updateState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return opinions.isEmpty
        ? Container()
        : Container(
            // height: 22.h,
            width: double.infinity,
            // color: Constance.secondaryColor,
            padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    'Opinions',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Colors.black,
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
                      itemCount: opinions.length>4?4:opinions.length,
                      itemBuilder: (cont, count) {
                        var item = opinions[count];
                        return GestureDetector(
                            onTap: () {
                              if (data.profile?.is_plan_active ?? false) {
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
                opinions.length>4?Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        txt: 'Load More',
                        onTap: () {
                          opinions.removeRange(0, 4);
                          updateState();
                          // page++;
                          // fetchMoreData();
                        }),
                  ],
                ):Container(),
              ],
            ),
          );
  }

  void showNotaMember(context) {

    Constance.showMembershipPrompt(context, () {

    });
  }
}
