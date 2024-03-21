
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Navigation/Navigate.dart';

class ShowDialogBoxContent extends StatelessWidget {
  const ShowDialogBoxContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
      // height: 50.h,
      width: 80.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are now a member of G Plus community',
            style: Theme.of(context).textTheme.headline5?.copyWith(
              color: Colors.black,
              // fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
                txt: 'Close',
                onTap: () {
                  Navigation.instance.navigate('/');
                }),
          ),
        ],
      ),
    );
  }
}