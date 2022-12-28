import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/toppicks_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/DataProvider.dart';
import '../../../Navigation/Navigate.dart';

class SuggestedForYou extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember;

  const SuggestedForYou(
      {super.key, required this.data, required this.showNotaMember});

  @override
  Widget build(BuildContext context) {
    return data.home_toppicks.isEmpty
        ? Container()
        : Container(
            height: 30.h,
            width: double.infinity,
            color: Constance.secondaryColor,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'Top Picks For You',
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
                      itemCount: data.home_toppicks.length > 4
                          ? 4
                          : data.home_toppicks.length + 1,
                      itemBuilder: (cont, count) {
                        var item = data.home_toppicks[count];
                        if ((data.home_toppicks.length > 4
                                ? 3
                                : data.home_toppicks.length - 1) ==
                            count) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.w, vertical: 1.5.h),
                            // height: 5.h,
                            // width: 20.w,
                            child: TextButton(
                              onPressed: () {
                                Navigation.instance.navigate('/toppicks');
                              },
                              child: Text(
                                'View All',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp,
                                    ),
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              if (data.profile?.is_plan_active ?? false) {
                                Navigation.instance.navigate('/story',
                                    args:
                                        '${item.categories?.first.seo_name},${item.seo_name}');
                              } else {
                                showNotaMember();
                              }
                            },
                            child: SuggestedForYouCard(item: item),
                          );
                        }
                      },
                      separatorBuilder: (cont, inde) {
                        return SizedBox(
                          width: 1.w,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
