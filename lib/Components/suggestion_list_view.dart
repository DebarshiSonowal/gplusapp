import 'package:flutter/material.dart';
import 'package:gplusapp/Components/suggestion_card.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Storage.dart';

class SuggestionListView extends StatelessWidget {
  final DataProvider data;
  final String dropdownvalue;
  const SuggestionListView({Key? key, required this.data, required this.dropdownvalue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(
          bottom: 2.h
        ),
        itemBuilder: (cont, count) {
          var item = data.suggestion[count];
          if (count != 0) {
            return SuggestionCard(dropdownvalue: dropdownvalue, item: item);
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
                color:
                Storage.instance.isDarkMode ? Colors.white : Colors.black,
                thickness: 0.3.sp,
              ),
            );
          }
        },
        itemCount: data.suggestion.length);
  }
}
