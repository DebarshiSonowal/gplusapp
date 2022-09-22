import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class AuthorPage extends StatefulWidget {
  final int id;

  AuthorPage(this.id);

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
          horizontal: 5.w,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 15.h,
              width: double.infinity,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.all(2.h),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constance.primaryColor,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            "https://images.unsplash.com/photo-1587590834224-3247f65be147?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
                            scale: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        'Joan Rivers',
                        style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline3
                            ?.copyWith(
                              color: Colors.black,
                              // fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Spacer(),
                      Text(
                        'Follow at',
                        style: Theme.of(Navigation
                                .instance.navigatorKey.currentContext!)
                            .textTheme
                            .headline5
                            ?.copyWith(
                              color: Colors.black,
                              // fontSize: 11.sp,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                      Row(
                        children: const [
                          Icon(
                            FontAwesomeIcons.facebookSquare,
                            color: Constance.primaryColor,
                            size: 30,
                          ),
                          Icon(
                            FontAwesomeIcons.instagramSquare,
                            color: Constance.primaryColor,
                            size: 30,
                          ),
                          Icon(
                            FontAwesomeIcons.twitterSquare,
                            color: Constance.primaryColor,
                            size: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'It is a long established fact that a reader will be '
              'distracted by the readable content of a page when '
              'looking at its layout. The point of using Lorem Ipsum '
              'is that it has a more-or-less normal distribution of letters, '
              'as opposed to using. Many desktop publishing packages and'
              ' web page editors now use Lorem Ipsum as their default model'
              ' text, and a search for will uncover many web sites still in'
              ' their infancy.',
              style: Theme.of(Navigation.instance.navigatorKey.currentContext!)
                  .textTheme
                  .headline4
                  ?.copyWith(
                    color: Colors.black,
                    // fontSize: 11.sp,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }
}