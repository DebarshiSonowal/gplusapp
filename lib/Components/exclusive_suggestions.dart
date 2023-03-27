import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Navigation/Navigate.dart';
import 'exclusive_item.dart';

class exclusiveSuggestions extends StatelessWidget {
  const exclusiveSuggestions({
    Key? key, required this.data,
  }) : super(key: key);
  final DataProvider data;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (cont, count) {
        var item = data.home_exclusive[count];
        if (count != 0) {
          return GestureDetector(
            onTap: () {
              if (item.has_permission?? false) {
                Navigation.instance.navigate('/story',
                    args:
                    '${'exclusive-news'},${item.seo_name},g_plus_exclusive');
              } else {
                Constance.showMembershipPrompt(
                    context, () {});
              }
            },
            child: ExclusiveItem(item: item),
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
      itemCount: data.home_exclusive.length,
    );
  }
}