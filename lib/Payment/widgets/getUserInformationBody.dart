import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';

class GetUserInformationBody extends StatelessWidget {
  const GetUserInformationBody({
    super.key,
    required this.name,
    required this.email,
    required this.phone, required this.onTap,
  });

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 42.h,
        width: 40.w,
        padding: EdgeInsets.only(
          top: 2.h,
          right: 2.w,
          left: 2.w,
          // bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Fill out your details',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                color: !Storage.instance.isDarkMode
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            SizedBox(height: 3.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 0.1.h, horizontal: 0.1.w),
                decoration: BoxDecoration(
                  color: !Storage.instance.isDarkMode
                      ? Colors.black
                      : Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  controller: name,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Enter your name',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle:
                    Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.grey.shade700,
                      fontSize: 12.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: !Storage.instance.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 0.1.h, horizontal: 0.1.w),
                decoration: BoxDecoration(
                  color: !Storage.instance.isDarkMode
                      ? Colors.black
                      : Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  controller: email,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Enter your email',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle:
                    Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.grey.shade700,
                      fontSize: 12.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: !Storage.instance.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 0.1.h, horizontal: 0.1.w),
                decoration: BoxDecoration(
                  color: !Storage.instance.isDarkMode
                      ? Colors.black
                      : Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  controller: phone,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Enter your phone number',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle:
                    Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.grey.shade700,
                      fontSize: 12.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: !Storage.instance.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Constance.thirdColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: ()=>onTap(),
                  child: Text(
                    'Continue',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}