import 'package:flutter/material.dart';
import 'package:gplusapp/Components/storyButtonSection.dart';
import 'package:sizer/sizer.dart';

import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';

class StackedStorySection extends StatelessWidget {
  const StackedStorySection({Key? key, required this.data, required this.index, required this.launchUrl, required this.sendToRoute}) : super(key: key);
  final DataProvider data;
  final int index;
  final Function(String data) launchUrl;
  // final Function onClick;

  final Function(String data1, String data2, String data3) sendToRoute;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.stories[index].title ?? "",
            style: Theme.of(context).textTheme.headline4?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          StoryButtonSection(
            index: index,
            web_url: data.stories[index].web_url ?? "",
            btn_color: data.stories[index].btn_color!,
            btn_text: data.stories[index].btn_text ?? "Click Here",
            onClick: () {
              final uri = Uri.parse(data.stories[index].web_url ??
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
          ),
        ],
      ),
    );
  }
}
