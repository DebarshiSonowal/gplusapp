import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      child: Container(
        // height: 30.h,
        width: 53.w,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                Storage.instance.isDarkMode ? Colors.white : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(
                        10.0,
                      ),
                      // bottomRight: Radius.circular(
                      //   10.0,
                      // ),
                      topLeft: Radius.circular(
                        10.0,
                      ),
                      // bottomLeft: Radius.circular(
                      //   10.0,
                      // ),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(
                        data.vendor?.image_file_name ??
                            "https://source.unsplash.com/user/c_v_r/1900x800",
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 1.h,
              // ),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.vendor?.shop_name ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(
                        //   height: 0.5.h,
                        // ),
                        Text(
                          data.vendor?.address ?? "",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    // fontWeight: FontWeight.bold
                                  ),
                        ),
                        // SizedBox(
                        //   height: 0.5.h,
                        // ),
                        Text(
                          data.title ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  color: Constance.thirdColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
