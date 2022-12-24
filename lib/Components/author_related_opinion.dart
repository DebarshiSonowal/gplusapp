import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/opinion.dart';
import '../Navigation/Navigate.dart';
import 'opinion_card.dart';

class AuthorRelatedOpinions extends StatelessWidget {
  final List<Opinion> opinions;
  final DataProvider data;

  const AuthorRelatedOpinions(
      {Key? key, required this.opinions, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return opinions.isEmpty
        ? Container()
        : Container(
            height: 22.h,
            width: double.infinity,
            // color: Constance.secondaryColor,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'Opinions from same author',
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
                Expanded(
                  child: Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: opinions.length,
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
              ],
            ),
          );
  }

  void showNotaMember(context) {

    Constance.showMembershipPrompt(context, () {

    });
  }
}
