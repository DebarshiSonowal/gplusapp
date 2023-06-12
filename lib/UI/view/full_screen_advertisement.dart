import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenAdvertisement extends StatelessWidget {
  FullScreenAdvertisement() {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        backgroundColor: Colors.black.withOpacity(0.75),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigation.instance.goBack();
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              // decoration: const BoxDecoration(
              //   color: Colors.white,
              //   shape: BoxShape.circle,
              // ),
              child: Consumer<DataProvider>(builder: (context, data, _) {
                return GestureDetector(
                  onTap: () {
                    if (data.full_screen_ad?.link==null) {
                      Navigation.instance.goBack();
                      _launchURL(data.full_screen_ad!.link);
                    }
                  },
                  child: SizedBox(
                    // height: 70.h,
                    // width: 70.h,
                    child: CachedNetworkImage(
                      imageUrl:
                          data.full_screen_ad?.data ?? Constance.defaultFullAd,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                );
              }),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
