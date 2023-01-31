import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';

class StoryButtonSection extends StatelessWidget {
  final int index;

  const StoryButtonSection(
      {Key? key,
      required this.index,
      required this.launchUrl,
      required this.sendToRoute})
      : super(key: key);
  final Function(String data) launchUrl;
  final Function(String data1,String data2,String data3) sendToRoute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: SizedBox(
        // width: 30.w,
        height: 5.h,
        child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            //  /^(?:https?:\/\/)?(?:[^@\n]+@)?(?:www\.)?([^:\/\n?]+)/img
            debugPrint(Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .stories[index]
                    .web_url ??
                "");
            final uri = Uri.parse(Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .stories[index]
                    .web_url ??
                "https://www.guwahatiplus.com/");
            if (uri.path.contains("guwahatiplus.com")) {
              debugPrint(uri.path.split("/").toString());
              Navigation.instance.goBack();
              sendToRoute(uri.path.split("/")[1], uri.path.split("/")[3],
                  uri.path.split("/")[2]);
            } else {
              launchUrl("https://${uri}");
            }
          },
          icon: Image.asset(
            Constance.linkIcon,
            fit: BoxFit.contain,
            color: Color(
              int.parse(
                  '0xff${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).stories[index].btn_color?.substring(1)}'),
            ),
            scale: 15,
          ),
          label: Text(
            Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .stories[index]
                    .btn_text ??
                "Click here",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Color(
                    int.parse(
                        '0xff${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).stories[index].btn_color?.substring(1)}'),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
