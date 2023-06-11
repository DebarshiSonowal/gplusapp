import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';

class NoInternetConnectionScreen extends StatefulWidget {
  const NoInternetConnectionScreen({super.key});

  @override
  State<NoInternetConnectionScreen> createState() =>
      _NoInternetConnectionScreenState();
}

class _NoInternetConnectionScreenState
    extends State<NoInternetConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.w),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Oops! You are not connected to Internet',
              style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Constance.thirdColor, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {

              },
              child: Text(
                "Open Settings",
                style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
