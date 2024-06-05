import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:sizer/sizer.dart';

// import 'package:uni_links/uni_links.dart';

import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class LinkFailedPage extends StatefulWidget {
  final String path;

  const LinkFailedPage({Key? key, required this.path}) : super(key: key);

  @override
  State<LinkFailedPage> createState() => _LinkFailedPageState();
}

class _LinkFailedPageState extends State<LinkFailedPage> {
  StreamSubscription? _sub;


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Constance.primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Constance.logoIcon,
              scale: 1,
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Something went wrong with your link.',
              style: Theme.of(Navigation.instance.navigatorKey.currentContext!)
                  .textTheme
                  .headline4
                  ?.copyWith(
                    color: Colors.white,
                    // fontSize: 2.2.h,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Please check it again.',
              style: Theme.of(Navigation.instance.navigatorKey.currentContext!)
                  .textTheme
                  .headline4
                  ?.copyWith(
                    color: Colors.white,
                    // fontSize: 2.2.h,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 2.h,
            ),
            CustomButton(
              txt: 'Reload',
              onTap: () {
                Navigation.instance.navigateAndRemoveUntil('/main');
              },
            ),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // initUniLinks();
    checkForLinks();
  }

  void checkForLinks() {
    debugPrint("path ${widget.path}");


  }
}
