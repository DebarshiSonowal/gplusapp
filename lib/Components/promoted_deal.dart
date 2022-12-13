import 'package:flutter/material.dart';
import 'package:gplusapp/Components/promoted_deals_item.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:sizer/sizer.dart';

class PromotedDeal extends StatelessWidget {
  final DataProvider current;

  const PromotedDeal({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        current.deals.isEmpty
            ? SizedBox(
                height: 6.h,
              )
            : SizedBox(
                height: 2.h,
              ),
        current.deals.isEmpty
            ? Container()
            : SizedBox(
                height: 29.h,
                width: double.infinity,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: current.deals.length,
                  itemBuilder: (cont, cout) {
                    var data = current.deals[cout];
                    return PromotedDealsItem(data: data);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 2.h,
                    );
                  },
                ),
              ),
      ],
    );
  }
}
