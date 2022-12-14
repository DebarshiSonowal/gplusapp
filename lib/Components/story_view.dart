import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
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
    controller = StoryController();
    Future.delayed(Duration.zero, () {
      storyItems.addAll(Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .stories
          .map(
            (e) => StoryItem.pageImage(
              url: e.image_file_name ?? "",
              controller: controller,
              caption: e.title ?? "",
            ),
          )
          .toList());
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
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        child: storyItems.isNotEmpty
            ? Stack(
                children: [
                  StoryView(
                      storyItems: storyItems,
                      controller: controller,
                      onStoryShow: (s) {
                        current = s;
                        index = storyItems.indexOf(s);
                      },
                      onComplete: () => Navigation.instance.goBack(),
                      onVerticalSwipeComplete: (direction) {
                        Navigation.instance.goBack();
                        // if (current != null) {
                        //   _launchUrl(Uri.parse(Provider.of<DataProvider>(
                        //               Navigation.instance.navigatorKey
                        //                       .currentContext ??
                        //                   context,
                        //               listen: false)
                        //           .stories[storyItems.indexOf(current!)]
                        //           .web_url ??
                        //       "https://guwahatiplus.com/"));
                        // } else {
                        //   _launchUrl(Uri.parse("https://guwahatiplus.com/"));
                        // }
                      }),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .stories[index]
                                .btn_text ==
                            ""
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: SizedBox(
                              // width: 30.w,
                              height: 5.h,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () {},
                                icon: Image.asset(
                                  Constance.linkIcon,
                                  color: Color(
                                    int.parse(
                                        '0xff${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).stories[index].btn_color?.substring(1)}'),
                                  ),
                                  scale: 3,
                                ),
                                label: Text(
                                  Provider.of<DataProvider>(
                                              Navigation.instance.navigatorKey
                                                      .currentContext ??
                                                  context,
                                              listen: false)
                                          .stories[index]
                                          .btn_text ??
                                      "Click here",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                        color: Color(
                                          int.parse(
                                              '0xff${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).stories[index].btn_color?.substring(1)}'),
                                        ),
                                      ),
                                ),
                              ),
                              //  CustomButton(
                              //                                 color: Color(int.parse(
                              //                                     '0xff${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).stories[index].btn_color?.substring(1)}')),
                              //                                 txt: Provider.of<DataProvider>(
                              //                                             Navigation.instance.navigatorKey
                              //                                                     .currentContext ??
                              //                                                 context,
                              //                                             listen: false)
                              //                                         .stories[index]
                              //                                         .btn_text ??
                              //                                     "Click here",
                              //                                 size: 12.sp,
                              //                                 onTap: () {
                              //                                   if (current != null) {
                              //                                     _launchUrl(Uri.parse(
                              //                                         Provider.of<DataProvider>(
                              //                                                     Navigation
                              //                                                             .instance
                              //                                                             .navigatorKey
                              //                                                             .currentContext ??
                              //                                                         context,
                              //                                                     listen: false)
                              //                                                 .stories[storyItems
                              //                                                     .indexOf(current!)]
                              //                                                 .web_url ??
                              //                                             "https://guwahatiplus.com/"));
                              //                                   } else {
                              //                                     _launchUrl(
                              //                                         Uri.parse("https://guwahatiplus.com/"));
                              //                                   }
                              //                                 },
                              //                               )
                            ),
                          ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
