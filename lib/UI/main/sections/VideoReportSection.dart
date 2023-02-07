import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/video_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/Storage.dart';
import '../../../Navigation/Navigate.dart';

class VideoReportSection extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember;

  const VideoReportSection(
      {super.key, required this.data, required this.showNotaMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 35.h,
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
              'Videos Of The Week',
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
          data.home_weekly.isNotEmpty?SizedBox(
            height: 20.h,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (cont, count) {
                var item = data.home_weekly[count];
                if ((data.home_weekly.length > 4
                        ? 3
                        : data.home_weekly.length - 1) ==
                    count) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        if (data.profile?.is_plan_active ?? false) {
                          Navigation.instance
                              .navigate('/videoReport', args: 'news');
                        } else {
                          showNotaMember();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          'Watch More',
                          style: Theme.of(context).textTheme.headline5?.copyWith(
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
                          Navigation.instance.navigate('/videoPlayer',
                              args: '${item.youtube_id},${1}');
                        } else {
                          showNotaMember();
                        }
                      },
                      child: VideoCard(item: item));
                }
              },
              separatorBuilder: (cont, inde) {
                return SizedBox(
                  width: 1.w,
                );
              },
              itemCount:
                  data.home_weekly.length > 4 ? 4 : data.home_weekly.length + 1,
            ),
          ):Container(),

          // SizedBox(
          //   height: 1.h,
          // ),
        ],
      ),
    );
  }
}
