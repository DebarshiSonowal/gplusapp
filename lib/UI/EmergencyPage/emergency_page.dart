import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:sizer/sizer.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key, required this.title});

  final String title;

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: Constance.buildAppBar2("Emergency Page"),
      // backgroundColor: Colors.white,
      backgroundColor: Colors.black87,
      body: Container(
        // color: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 1.h,
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 85.w,
              // height: 25.h,
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: Constance.primaryColor,
                        size: 30.sp,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        "Alert!",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Constance.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black,
                            fontSize: 15.sp,
                          ),
                      maxLines: 10,
                      // textAlign: TextA,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constance.secondaryColor,
                    ),
                    onPressed: () {
                      Navigation.instance.goBack();
                    },
                    child: Text(
                      "DISMISS",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Constance.primaryColor,
                            fontSize: 15.sp,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
