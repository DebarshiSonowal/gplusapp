import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      // child: GestureDetector(
      //   onTap: () {
      //     Navigation.instance.navigate('/bigdealpage');
      //     Provider.of<DataProvider>(
      //             Navigation.instance.navigatorKey.currentContext ?? context,
      //             listen: false)
      //         .setCurrent(1);
      //   },
      //   child: Card(
      //     color: Constance.thirdColor,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     child: Container(
      //       padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      //       decoration: const BoxDecoration(
      //         borderRadius: BorderRadius.all(
      //           Radius.circular(10),
      //         ),
      //       ),
      //       child: Row(
      //         children: [
      //           Expanded(
      //             child: Center(
      //               child: Text(
      //                 'Big Deals\nand Offers',
      //                 style: Theme.of(context).textTheme.headline3?.copyWith(
      //                     color: Colors.white, fontWeight: FontWeight.bold),
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //               child: Container(
      //             decoration: BoxDecoration(
      //               border: Border.all(
      //                 color: Colors.white,
      //               ),
      //               borderRadius: const BorderRadius.all(
      //                 Radius.circular(5),
      //               ),
      //             ),
      //             child: Center(
      //               child: Consumer<DataProvider>(builder: (context, data, _) {
      //                 return GestureDetector(
      //                   onTap: () {
      //                     if (data.smallImage?.link!=null) {
      //                       _launchURL(data.smallImage?.link ?? "");
      //                     }
      //                   },
      //                   child: CachedNetworkImage(
      //                     imageUrl:
      //                         data.smallImage?.data ?? Constance.kfc_offer,
      //                     placeholder: (cont, _) {
      //                       return Image.asset(
      //                         Constance.logoIcon,
      //                         // color: Colors.black,
      //                       );
      //                     },
      //                     errorWidget: (cont, _, e) {
      //                       return Image.network(
      //                         Constance.defaultImage,
      //                         fit: BoxFit.fitWidth,
      //                       );
      //                     },
      //                   ),
      //                 );
      //               }),
      //             ),
      //           )),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: Constance.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 1.w),
                // margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Ad',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 7.sp,
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Consumer<DataProvider>(builder: (context, data, _) {
            return GestureDetector(
              onTap: () {
                if (data.smallImage?.link!=null) {
                  _launchURL(data.smallImage?.link ?? "");
                }
              },
              child: CachedNetworkImage(
                imageUrl:
                data.smallImage?.data ?? Constance.kfc_offer,
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
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
