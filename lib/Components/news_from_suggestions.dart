import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Navigation/Navigate.dart';
import '../UI/news_from/news_from.dart';
import 'news_from_more_item.dart';

class newsfrom_suggestion extends StatelessWidget {
  const newsfrom_suggestion({
    Key? key,
    required this.widget, required this.data,
  }) : super(key: key);

  final NewsFrom widget;
  final DataProvider data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (cont, count) {
          var item = data.news_from[count];
          if (count != 0) {
            return GestureDetector(
              onTap: () {
                if (item.has_permission?? false) {
                  Navigation.instance.navigate('/story',
                      args:
                      '${widget.categ},${item.seo_name},news_from');
                } else {
                  Constance.showMembershipPrompt(
                      context, () {});
                }
              },
              child: NewsFromMoreItem(item: item),
            );
          } else {
            return Container();
          }
        },
        separatorBuilder: (cont, inde) {
          if (inde == 0) {
            return Container();
          } else {
            return SizedBox(
              height: 1.h,
              child: Divider(
                color: Storage.instance.isDarkMode
                    ? Colors.white
                    : Colors.black,
                thickness: 0.3.sp,
              ),
            );
          }
        },
        itemCount: data.news_from.length);
  }
}