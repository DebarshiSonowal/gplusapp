import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Model/notification_in_device.dart';
import '../Navigation/Navigate.dart';

class BuzzSection extends StatelessWidget {
  const BuzzSection({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function(String, String) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 8.h,
      child: ListTileTheme(
        contentPadding: EdgeInsets.all(0),
        child: ExpansionTile(
          title: Row(
            children: [
              Image.asset(
                "assets/images/buzz.png",
                color: Constance.secondaryColor,
                fit: BoxFit.fill,
                scale: 20,
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                'Buzz',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.white,
                      // fontSize: 14.sp,
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
          trailing: !filterToCheckPerType(
                  Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey.currentContext ??
                              context,
                          listen: false)
                      .notifications,
                  'buzz')
              ? const SizedBox(
                  height: 6,
                  width: 6,
                )
              : Container(
                  height: 6,
                  width: 6,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
          children: [
            InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.h,
              onTap: () {
                onTap("buzz", "entertainment");
                Navigation.instance
                    .navigate('/newsfrom', args: 'entertainment');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Entertainment',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      // color: Colors.red,
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
              radius: 15.h,
              onTap: () {
                onTap("buzz", "featured");
                Navigation.instance.navigate('/newsfrom', args: 'buzz');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Featured',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      // color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ),
    );
  }

  filterToCheckPerType(List<NotificationInDevice> notifications, String s) {
    for (var i in notifications) {
      if (i.type == s) {
        return true;
      }
    }
    return false;
  }
}
