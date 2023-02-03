import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Components/storyButtonSection.dart';
import 'package:gplusapp/Components/story_stacked_section.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Helper/Storage.dart';
import '../Navigation/Navigate.dart';

class StoryViewPage extends StatefulWidget {
  final int count;

  StoryViewPage(this.count);

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  var controller = StoryController();
  StoryItem? current;
  int index = 0;
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    // controller = StoryController();
    Future.delayed(Duration.zero, () {
      // storyItems.addAll(Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext ?? context,
      //         listen: false)
      //     .stories
      //     .map(
      //       (e) => StoryItem.pageImage(
      //         url: e.image_file_name ?? "",
      //         controller: controller,
      //         caption: e.title ?? "",
      //       ),
      //     )
      //     .toList());
      setState(() {});
      print("${widget.count} ${index}");
      // Future.delayed(Duration(seconds: 1),(){
      //   while(widget.count>=index){
      //     try {
      //       controller.next();
      //     } catch (e) {
      //       print(e);
      //     }
      //   }
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Consumer<DataProvider>(builder: (context, data, w) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: data.stories.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Story(
                          onFlashForward: Navigator.of(context).pop,
                          onFlashBack: Navigator.of(context).pop,
                          momentCount: data.stories.length,
                          momentDurationGetter: (idx) =>
                              const Duration(seconds: 10),
                          momentBuilder: (context, idx) {
                            updateIndex(idx);
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: CachedNetworkImage(
                                    height: 90.h,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitHeight,
                                    imageUrl: data
                                            .stories[idx].image_file_name ??
                                        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: data.stories[index].btn_text == ""
                              ? Container()
                              : StackedStorySection(
                                  data: data,
                                  index: index,
                                  launchUrl: (String data) =>
                                      launchUrl(Uri.parse(data)),
                                  sendToRoute: (String data1, String data2,
                                          String data3) =>
                                      sendToRoute(data1, data2, data3),
                                ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          );
        }),
      ),
    );
  }

  void sendToRoute(String route, data, String? category) async {
    // debugPrint("link 1 our route ${route}");
    switch (route) {
      case "story":
        // Navigation.instance.navigate('/main');

        Navigation.instance.navigate('/story', args: '${category},${data}');
        break;
      case "opinion":
        // Navigation.instance.navigate('/main');

        Navigation.instance
            .navigate('/opinionDetails', args: '${data},${category}');
        break;
      default:
        Navigation.instance.navigate('/main', args: "");
        break;
    }
  }

  void updateIndex(int idx) {
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        index = idx;
      });
    });
  }
}
