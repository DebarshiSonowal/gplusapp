import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Helper/Constance.dart';

class SocialMediaSection extends StatelessWidget {
  const SocialMediaSection({Key? key, required this.onTap}) : super(key: key);
  final Function(String,String) onTap;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: ExpansionTile(
          title: Row(
            children: [
              const Icon(
                FontAwesomeIcons.meta,
                color: Constance.secondaryColor,
              ),
              SizedBox(
                width: 3.w,
              ),
              Text(
                'Our Socials',
                style:
                Theme.of(context).textTheme.headline4?.copyWith(
                  color: Colors.white,
                  // fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 3.h,
              ),
            ],
          ),
          trailing: Container(
            height: 6,
            width: 6,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          children: [
            InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.w,
              onTap: () {
                onTap("social_media","facebook");
                _launchUrl(Uri.parse(
                    'https://www.facebook.com/guwahatiplus/'));
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  Icon(
                    FontAwesomeIcons.facebook,
                    color: Constance.secondaryColor,
                    size: 12.sp,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'Facebook',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.w,
              onTap: () {
                onTap("social_media","instagram");
                _launchUrl(Uri.parse(
                    'https://www.instagram.com/guwahatiplus/'));
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  Icon(
                    FontAwesomeIcons.instagram,
                    color: Constance.secondaryColor,
                    size: 12.sp,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'Instagram',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.w,
              onTap: () {
                onTap("social_media","twitter");
                _launchUrl(
                    Uri.parse('https://twitter.com/guwahatiplus'));
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  Icon(
                    FontAwesomeIcons.twitter,
                    color: Constance.secondaryColor,
                    size: 12.sp,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'Twitter',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.w,
              onTap: () {
                onTap("social_media","youtube");
                _launchUrl(
                    Uri.parse('https://youtube.com/@GPlusGuwahati'));
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 4.w,
                  ),
                  Icon(
                    FontAwesomeIcons.youtube,
                    color: Constance.secondaryColor,
                    size: 12.sp,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'YouTube',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _launchUrl(url) async {
    // if (!await launchUrl(_url)) {
    //   throw 'Could not launch $_url';
    // }
    try {
      bool launched = await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication
      ); // Launch the app if installed!

      if (!launched) {
        launchUrl(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launchUrl(url); // Launch web view if app is not installed!
    }
  }
}
