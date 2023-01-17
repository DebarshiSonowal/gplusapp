import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class NewsFromSection extends StatelessWidget {
  const NewsFromSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: EdgeInsets.all(0),
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
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          children: [
            InkWell(
              splashColor: Constance.secondaryColor,
              radius: 15.w,
              onTap: () {
                Navigation.instance
                    .navigate('/newsfrom', args: 'guwahati');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Guwahati',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
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
                    .navigate('/newsfrom', args: 'assam');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Assam',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
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
              radius: 15.w,
              onTap: () {
                Navigation.instance
                    .navigate('/newsfrom', args: 'northeast');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'Northeast',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
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
                    .navigate('/newsfrom', args: 'india');
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    'India',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
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
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
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
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}