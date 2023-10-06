import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';

class OptionsBar extends StatelessWidget {
  const OptionsBar({super.key, required this.selected, required this.updateSelected, required this.fetchClassified, required this.logTheMyListClick});
  final int selected;
  final Function(int) updateSelected;
  final Function(dynamic) fetchClassified;
  final Function(Profile?) logTheMyListClick;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Constance.forthColor,
      height: 5.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // showSortByOption();
              updateSelected(1);

            },
            child: Container(
              width: 48.w,
              padding: EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 5.w,
              ),
              color: selected == 1
                  ? Constance.secondaryColor
                  : Constance.forthColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.list,
                    color: selected == 1
                        ? Colors.black
                        : Storage.instance.isDarkMode
                        ? Constance.secondaryColor
                        : Colors.white,
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text(
                    'Filter by',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
                      color: selected == 1
                          ? Colors.black
                          : Storage.instance.isDarkMode
                          ? Colors.black
                          : Colors.white,
                      fontSize: 2.h,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 2.w,
            child: Center(
              child: Container(
                height: double.infinity,
                width: 0.5.w,
                color: Storage.instance.isDarkMode
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              // setState(() {
              //   selected = 3;
              // });
              // fetchClassified(result);
              logTheMyListClick(Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey
                      .currentContext ??
                      context,
                  listen: false)
                  .profile!);
              var result = await Navigation.instance.navigate(
                '/classifiedMyListDetails',
              );
              if (result == null) {
                fetchClassified(result);
              }
            },
            child: Container(
              width: 48.w,
              padding: EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 5.w,
              ),
              color: selected == 3
                  ? Constance.secondaryColor
                  : Storage.instance.isDarkMode
                  ? Colors.white
                  : Constance.forthColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.person,
                    color: selected == 3
                        ? Colors.black
                        : Storage.instance.isDarkMode
                        ? Constance.secondaryColor
                        : Colors.white,
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text(
                    'My List',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
                      color: selected == 3
                          ? Colors.black
                          : Storage.instance.isDarkMode
                          ? Colors.black
                          : Colors.white,
                      fontSize: 2.h,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
