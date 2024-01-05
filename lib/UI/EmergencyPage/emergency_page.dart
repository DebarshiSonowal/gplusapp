import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
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
      appBar: Constance.buildAppBar2("Emergency Page"),
      backgroundColor: Colors.white,
      body: Container(
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
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Constance.thirdColor,
                fontSize: 20.sp
              ),
            ),
          ],
        ),
      ),
    );
  }
}
