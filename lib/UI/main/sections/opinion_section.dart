import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/opinion_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/Storage.dart';
import '../../../Navigation/Navigate.dart';

class OpinionSection extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember;

  const OpinionSection({super.key, required this.data,required this.showNotaMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // color: Constance.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'Opinion',
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  ?.copyWith(
                fontSize: 16.sp,
                color: Storage.instance.isDarkMode
                    ? Colors.white
                    : Constance.fifthColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (cont, count) {
                var item = data.latestOpinions[count];
                return GestureDetector(
                    onTap: () {
                      if (data.profile?.is_plan_active ??
                          false) {
                        Navigation.instance.navigate(
                            '/opinionDetails',
                            args: '${item.seo_name?.trim()},${item.category_gallery?.id}');
                      } else {
                        showNotaMember();
                      }
                    },
                    child: OpinionCard(item: item));
              },
              separatorBuilder: (cont, inde) {
                return SizedBox(
                  width: 10.w,
                  height: 1.h,
                );
              },
              itemCount: (data.latestOpinions.length > 3
                  ? data.latestOpinions.length / 3.toInt()
                  : data.latestOpinions.length)
                  .toInt(),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (data.profile?.is_plan_active ?? false) {
                    Navigation.instance.navigate('/opinionPage');
                  } else {
                   showNotaMember();
                  }

                  // Navigation.instance
                  //     .navigate('/authorPage', args: 1);
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
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
