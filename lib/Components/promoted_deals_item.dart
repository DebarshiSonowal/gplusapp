import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Components/promoted_deal_cupon.dart';
import 'package:gplusapp/Components/promoted_deal_item_data.dart';
import 'package:gplusapp/Components/promoted_deal_item_image.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/promoted_deal.dart';
import '../Navigation/Navigate.dart';

class PromotedDealsItem extends StatelessWidget {
  const PromotedDealsItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final PromotedDeal data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile
                ?.is_plan_active ??
            false) {
          Navigation.instance.navigate('/categorySelect', args: data.vendor_id);
        } else {
          Constance.showMembershipPrompt(context, () {});
        }
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            color: Storage.instance.isDarkMode
                ? Constance.secondaryColor
                : Constance.forthColor,
            child: Container(
              width: 83.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PromotedDealItemImage(data: data),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  PromotedDealItemData(data: data),
                ],
              ),
            ),
          ),
          PromotedDealItemCupon(data: data),
        ],
      ),
    );
  }
}






