import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';
import 'custom_button.dart';

class ClassifiedPopUp extends StatelessWidget {
  const ClassifiedPopUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return StatefulBuilder(builder: (context, _) {
        return Container(
          padding: EdgeInsets.only(
              top: 1.h, right: 5.w, left: 5.w, bottom: 1.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          width: double.infinity,
          // height: 50.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigation.instance.goBack();
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.black,
                  ),
                ],
              ),
              Text(
                'Oops!',
                style:
                Theme.of(context).textTheme.headline1?.copyWith(
                  color: Constance.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 34.sp,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'Sorry ${data.profile?.name}',
                style:
                Theme.of(context).textTheme.headline4?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                '''Projected to be a smart city by 2025, Guwahati is a
major port on the banks of Brahmaputra, the capital
of Assam and the urban hub of the North East. This
metropolitan city is growing leaps and bounds, and 
for its unparalleled pace of growth, comes the need
for an unparalleled publication, that people call their''',
                style:
                Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Do you want to be a member?',
                style:
                Theme.of(context).textTheme.headline4?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                children: [
                  Flexible(
                    child: CustomButton(
                      txt: 'Yes, take me there',
                      onTap: () {
                        Navigation.instance.navigate('/beamember');
                      },
                      size: 12.sp,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Flexible(
                    child: CustomButton(
                      txt: '''No, I don't want it''',
                      onTap: () {
                        Navigation.instance.goBack();
                      },
                      color: Colors.black,
                      size: 12.sp,
                      fcolor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    });
  }
}