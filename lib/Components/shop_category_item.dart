import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/shop_category.dart';
import '../Navigation/Navigate.dart';

class ShopCategoryItem extends StatelessWidget {
  final ShopCategory e;

  const ShopCategoryItem({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // selectedCategory(e.name);
        Navigation.instance.navigate('/fooddealpage', args: e.id!);
      },
      child: Container(
        // height: 10.h,
        width: 10.h,
        margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.h,
              height: 8.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.5.sp,
                  color: Constance.secondaryColor,
                ),
                color: Storage.instance.isDarkMode?Colors.transparent:Constance.secondaryColor,
                // borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network(
                e.image_file_name ?? "",
                color: Storage.instance.isDarkMode
                    ? Constance.secondaryColor
                    : Constance.primaryColor,
              ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
            Text(
              e.name ?? "1",
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Constance.primaryColor,
                    // fontSize: 1.7.h,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 0.5.h,
            ),
          ],
        ),
      ),
    );
  }
}
