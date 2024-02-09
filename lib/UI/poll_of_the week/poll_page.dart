import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Helper/string_extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class PollPage extends StatefulWidget {
  const PollPage({Key? key}) : super(key: key);

  @override
  State<PollPage> createState() => _PollPageState();
}

bool showing = false;

class _PollPageState extends State<PollPage> {
  String? _poll = Constance.pollWeek[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar2("poll"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Poll of the week',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            fontSize: 16.sp,
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      onPressed: () {
                        sharePollOfTheWeek(
                            "poll_of_the_week",
                            data.pollOfTheWeek?.title
                                ?.replaceAll(" ", "_")
                                .toLowerCase(),
                            data.pollOfTheWeek?.id);
                      },
                      icon: Icon(
                        Icons.share,
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              data.pollOfTheWeek != null
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, count) {
                        int current = 0;
                        int random = 0;
                        String _poll = Constance.pollWeek[0];
                        return StatefulBuilder(builder: (context, _) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  data.pollOfTheWeek?.title ??
                                      'Poll of the week',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                        fontSize: 13.sp,
                                        color: Storage.instance.isDarkMode
                                            ? Colors.white70
                                            : Constance.primaryColor,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (cont, count) {
                                    var item = data.pollOfTheWeek;
                                    // var value =
                                    //     Constance.pollValue[count];
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w, vertical: 1.h),
                                          child: LinearPercentIndicator(
                                            barRadius: const Radius.circular(5),
                                            width: 80.w,
                                            lineHeight: 5.h,
                                            percent:
                                                data.pollOfTheWeek?.is_polled ==
                                                        'false'
                                                    ? 0
                                                    : (getOption(count, data) /
                                                        100),
                                            center: const Text(
                                              "",
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                            // trailing: Icon(Icons.mood),
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            backgroundColor: Colors.white,
                                            progressColor:
                                                Constance.secondaryColor,
                                          ),
                                        ),
                                        Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor:
                                                Colors.grey.shade900,
                                            backgroundColor:
                                                Colors.grey.shade200,
                                          ),
                                          child: RadioListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            selected: _poll ==
                                                    getOptionName(count, data)
                                                ? true
                                                : false,
                                            tileColor: Colors.grey.shade300,
                                            selectedTileColor: Colors.black,
                                            value: getOptionName(count, data),
                                            activeColor: Colors.black,
                                            groupValue: _poll,
                                            onChanged: (val) {
                                              setState(() {
                                                _poll = getOptionName(
                                                    count, data);
                                              });
                                              postPollOfTheWeek(
                                                  data.pollOfTheWeek?.id,
                                                  _poll);
                                            },
                                            title: Text(
                                              getOptionName(count, data),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  ?.copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            secondary: Text(
                                              item?.is_polled == 'false'
                                                  ? ''
                                                  : '${getOption(count, data)}%',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      color: Storage.instance
                                                              .isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 1.7.h
                                                      // fontWeight: FontWeight.bold,
                                                      ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (cont, inde) {
                                    return SizedBox(
                                      width: 10.w,
                                    );
                                  },
                                  itemCount: 3),
                              SizedBox(
                                height: 1.h,
                              ),
                            ],
                          );
                        });
                      },
                      separatorBuilder: (context, count) {
                        return SizedBox(
                          height: 2.h,
                        );
                      },
                      itemCount: 1)
                  : Container(),
            ],
          );
        }),
      ),
    );
  }

  getOption(int count, data) {
    switch (count) {
      case 0:
        return data.pollOfTheWeek?.percent1;
      case 1:
        return data.pollOfTheWeek?.percent2;
      case 2:
        return data.pollOfTheWeek?.percent3;
      default:
        return data.pollOfTheWeek?.option1;
    }
  }

  String getOptionName(int count, data) {
    switch (count) {
      case 0:
        return data.pollOfTheWeek?.option1 ?? "";
      case 1:
        return data.pollOfTheWeek?.option2 ?? "";
      case 2:
        return data.pollOfTheWeek?.option3 ?? "";
      default:
        return data.pollOfTheWeek?.option1 ?? "";
    }
  }

  void postPollOfTheWeek(int? id, String poll) async {
    final response = await ApiProvider.instance.postPollOfTheWeek(id, poll);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Posted successfully");
      fetchPoll();
      setState(() {});
    } else {}
  }

  AppBar buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .setCurrent(0);
          Navigation.instance.navigate('/main');
        },
        child: Image.asset(
          Constance.logoIcon,
          fit: BoxFit.fill,
          scale: 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Consumer<DataProvider>(
            builder: (context, data, _) {
              return bd.Badge(
                // badgeColor: Constance.secondaryColor,
                badgeContent: Text(
                  '${data.notifications.length}',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Constance.thirdColor,
                      ),
                ),
                child: const Icon(Icons.notifications),
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search', args: "");
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  void fetchPoll() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getPollOfTheWeek();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setPollOfTheWeek(response.pollOfTheWeek!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  Future<void> sharePollOfTheWeek(title, description, id) async {
    debugPrint("Share $title\n$description");
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "${FlutterConfig.get('domain')}/PollOfTheWeek/$description/$title/$id"),
      uriPrefix: FlutterConfig.get('customHostDeepLink'),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "G Plus Poll of The Week",
        description: description.toString().replaceAll("_", " ").capitalize(),
      ),
      androidParameters: AndroidParameters(
        packageName: FlutterConfig.get("androidPackage"),
      ),
      iosParameters: IOSParameters(
        bundleId: FlutterConfig.get('iosBundleId'),
      ),
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    debugPrint("${dynamicLink.shortUrl}");
    Share.share(dynamicLink.shortUrl.toString());
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _poll = Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .pollOfTheWeek
          ?.is_polled!;
    });
  }
}
