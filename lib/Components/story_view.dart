import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../Helper/Storage.dart';
import '../Navigation/Navigate.dart';

class StoryViewPage extends StatefulWidget {
  final int count;

  StoryViewPage(this.count);

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return StoryView(
            storyItems: data.stories
                .map((e) => StoryItem.pageImage(
                      url: e.image_file_name ?? "",
                      controller: StoryController(),
                      caption: e.title ?? "",
                    ))
                .toList(),
            controller: StoryController(),
            onComplete: () => Navigation.instance.goBack(),
          );
        }),
      ),
    );
  }
}
