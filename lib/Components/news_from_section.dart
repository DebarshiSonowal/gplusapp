import 'package:flutter/material.dart';
import 'package:gplusapp/Model/notification_in_device.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';

class NewsFromSection extends StatelessWidget {
  const NewsFromSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        child: ExpansionTile(
          title: Row(
            children: [
              const Icon(
                Icons.backpack,
                color: Constance.secondaryColor,
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                'News from',
                style: Theme.of(context).textTheme.headline4?.copyWith(
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
          trailing: !filterToCheck(Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .notifications)
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
              radius: 15.w,
              onTap: () {
                Navigation.instance.navigate('/newsfrom', args: 'guwahati');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Guwahati',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(child: Container()),
                  !filterToCheckPerCategory(
                          Provider.of<DataProvider>(
                                  Navigation.instance.navigatorKey
                                          .currentContext ??
                                      context,
                                  listen: false)
                              .notifications,
                          'guwahati')
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
                Navigation.instance.navigate('/newsfrom', args: 'assam');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Assam',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(child: Container()),
                  filterToCheckPerCategory(
                      Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey
                              .currentContext ??
                              context,
                          listen: false)
                          .notifications,
                      'assam')
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
                Navigation.instance.navigate('/newsfrom', args: 'northeast');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Northeast',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(child: Container()),
                  !filterToCheckPerCategory(
                      Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey
                              .currentContext ??
                              context,
                          listen: false)
                          .notifications,
                      'northeast')
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
                Navigation.instance.navigate('/newsfrom', args: 'india');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'India',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(child: Container()),
                  !filterToCheckPerCategory(
                      Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey
                              .currentContext ??
                              context,
                          listen: false)
                          .notifications,
                      'india')
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
                Navigation.instance
                    .navigate('/newsfrom', args: 'international');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'International',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(child: Container()),
                  !filterToCheckPerCategory(
                      Provider.of<DataProvider>(
                          Navigation.instance.navigatorKey
                              .currentContext ??
                              context,
                          listen: false)
                          .notifications,
                      'international')
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

  filterToCheck(List<NotificationInDevice> notifications) {
    for (var i in notifications) {
      if (i.category_name?.toLowerCase().trim() == "guwahati" ||
          i.category_name?.toLowerCase().trim() == "international" ||
          i.category_name?.toLowerCase().trim() == "assam" ||
          i.category_name?.toLowerCase().trim() == "india" ||
          i.category_name?.toLowerCase().trim() == "exclusive-news" ||
          i.category_name?.toLowerCase().trim() == "northeast") {
        return true;
      }
    }
    return false;
  }

  filterToCheckPerCategory(List<NotificationInDevice> notifications, String s) {

    for (var i in notifications) {
      // debugPrint("filterToCheckPerCategory ${i.category_name} ${s}");
      if (i.category_name?.toLowerCase().trim() == s) {
        // debugPrint("CHECK PER Category ${i.seo_name} ${i.category_name}");
        return true;
      }
    }
    return false;
  }
}
