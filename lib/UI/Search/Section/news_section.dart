import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/search_news_item.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/Storage.dart';
import '../../../Navigation/Navigate.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({Key? key, required this.data}) : super(key: key);
  final DataProvider data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (cont, count) {
          var item = data.searchlist[count];
          return GestureDetector(
            onTap: () {
              if (data.profile?.is_plan_active ?? false) {
                Navigation.instance.navigate('/story',
                    args: '${item.first_cat_name?.seo_name},${item.seo_name}');
              } else {
                Constance.showMembershipPrompt(context, () {
                  // setState(() {
                  //   showing = false;
                  // });
                });
              }
            },
            child: SearchNewsItem(item: item),
          );
        },
        separatorBuilder: (cont, inde) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: SizedBox(
              height: 1.h,
              child: Divider(
                color:
                    Storage.instance.isDarkMode ? Colors.white : Colors.black,
                thickness: 0.3.sp,
              ),
            ),
          );
        },
        itemCount: data.searchlist.length);
  }
}