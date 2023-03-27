import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/Constance.dart';
import '../../../Helper/DataProvider.dart';
import '../../../Navigation/Navigate.dart';

class BigDealsAdSection extends StatelessWidget {
  const BigDealsAdSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 20.h,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
      child: GestureDetector(
        onTap: () {
          Navigation.instance.navigate('/bigdealpage');
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .setCurrent(1);
        },
        child: Card(
          color: Constance.thirdColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Big Deals\nand Offers',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Center(
                    child: Consumer<DataProvider>(
                      builder: (context,data,_) {
                        return CachedNetworkImage(
                          imageUrl: data
                                  .ad_image ??
                              Constance.kfc_offer,
                          placeholder: (cont, _) {
                            return Image.asset(
                              Constance.logoIcon,
                              // color: Colors.black,
                            );
                          },
                          errorWidget: (cont, _, e) {
                            return Image.network(
                              Constance.defaultImage,
                              fit: BoxFit.fitWidth,
                            );
                          },
                        );
                      }
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
