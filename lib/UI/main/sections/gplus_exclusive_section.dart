import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/gplus_execl_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/DataProvider.dart';
import '../../../Helper/Storage.dart';
import '../../../Navigation/Navigate.dart';

class GPlusExclusiveSection extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember;

  const GPlusExclusiveSection(
      {super.key, required this.data, required this.showNotaMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.h,
      width: double.infinity,
      // color: Constance.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              'G Plus Exclusive',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 16.sp,
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Constance.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            height: 0.3.h,
          ),
          data.home_exclusive.isNotEmpty?Expanded(
            child: Container(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (cont, count) {
                  var item = data.home_exclusive[count];
                  if ((data.home_exclusive.length > 4
                          ? 3
                          : data.home_exclusive.length - 1) ==
                      count) {
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          if (data.profile?.is_plan_active ?? false) {
                            Navigation.instance.navigate('/exclusivePage');
                          } else {
                            showNotaMember();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Text(
                            'Read More',
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Constance.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        if (data.profile?.is_plan_active ?? false) {
                          Navigation.instance.navigate('/story',
                              args: '${'exclusive-news'},${item.seo_name}');
                        } else {
                          showNotaMember();
                        }
                      },
                      child: GPlusExecCard(item: item),
                    );
                  }
                },
                separatorBuilder: (cont, inde) {
                  return SizedBox(
                    width: 1.w,
                  );
                },
                itemCount: data.home_exclusive.length > 4
                    ? 4
                    : data.home_exclusive.length + 1,
              ),
            ),
          ):Container(),

        ],
      ),
    );
  }
}
