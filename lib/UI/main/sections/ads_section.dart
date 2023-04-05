import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Helper/Constance.dart';

class AdsSection extends StatelessWidget {
  final DataProvider data;
  final int random;
  const AdsSection({Key? key, required this.data, required this.random}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: Constance.secondaryColor,
                padding: EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 1.w),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
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
          // SizedBox(
          //   height: 1.h,
          // ),
          SizedBox(
            // height: 8.5.h,
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                _launchUrl(Uri.parse(data.ads[random].link.toString()));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 4.w, right: 5.w, bottom: 0.9.h),
                child: CachedNetworkImage(
                  // height: 6.h,
                  fit: BoxFit.fill,
                  imageUrl: data.ads[random].image_file_name ?? '',
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (await canLaunchUrl(_url)) {
      launchUrl(_url);
    } else {
      launchUrl(
        Uri.parse('https://api.whatsapp.com/send?phone=919365974702'),
      );
    }
  }
}
