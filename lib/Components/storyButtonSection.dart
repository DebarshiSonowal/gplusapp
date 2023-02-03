import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';

class StoryButtonSection extends StatelessWidget {
  final int index;
  final String web_url, btn_color, btn_text;

  const StoryButtonSection(
      {Key? key,
      required this.index,
      // required this.launchUrl,
      // required this.sendToRoute,
      required this.web_url,
      required this.btn_color,
      required this.btn_text,
      required this.onClick})
      : super(key: key);

  // final Function(String data) launchUrl;
  final Function onClick;

  // final Function(String data1, String data2, String data3) sendToRoute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: SizedBox(
        // width: 30.w,
        height: 5.h,
        child: OutlinedButton.icon(
          // <-- OutlinedButton
          onPressed: () => onClick(),
          icon: Image.asset(
            Constance.linkIcon,
            fit: BoxFit.contain,
            color: Color(
              int.parse('0xff${btn_color.substring(1)}'),
            ),
            scale: 15,
          ),
          label: Text(
            btn_text ?? "Click here",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Color(
                    int.parse('0xff${btn_color.substring(1)}'),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
