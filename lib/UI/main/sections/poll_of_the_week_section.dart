import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../Helper/Constance.dart';
import '../../../Helper/DataProvider.dart';
import '../../../Helper/Storage.dart';
import '../../../Model/profile.dart';
import '../../../Networking/api_provider.dart';

class PollOfTheWeekSection extends StatelessWidget {
  final DataProvider data;
  final Function showNotaMember, update;
  String poll;

  PollOfTheWeekSection(
      {super.key,
      required this.data,
      required this.showNotaMember,
      required this.update,
      required this.poll});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 35.h,
      width: double.infinity,
      // color: Constance.secondaryColor,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Poll Of The Week',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        fontSize: 16.sp,
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                // IconButton(
                //   onPressed: () {
                //     // Share.share(data
                //     //     .selectedArticle?.web_url ==
                //     //     ""
                //     //     ? 'check out our website https://guwahatiplus.com/'
                //     //     : '${data.selectedArticle?.web_url}');
                //   },
                //   icon: Icon(
                //     Icons.share,
                //     color: Storage.instance.isDarkMode
                //         ? Colors.white
                //         : Constance.primaryColor,
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              data.pollOfTheWeek?.title ?? 'Poll of the week',
              style: Theme.of(context).textTheme.headline3?.copyWith(
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0.5.w),
            child: ListView.separated(
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
                          width: 95.w,
                          lineHeight: 5.h,
                          percent: data.pollOfTheWeek?.is_polled == 'false'
                              ? 0
                              : (getOption(count, data) / 100),
                          center: const Text(
                            "",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          // trailing: Icon(Icons.mood),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: Colors.white,
                          progressColor: Constance.secondaryColor,
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.grey.shade900,
                          backgroundColor: Colors.grey.shade200,
                        ),
                        child: RadioListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          selected:
                              poll == getOptionName(count, data) ? true : false,
                          tileColor: Colors.grey.shade300,
                          selectedTileColor: Colors.black,
                          value: getOptionName(count, data),
                          activeColor: Colors.black,
                          groupValue: poll,
                          onChanged: (val) {
                            if ((data.profile?.is_plan_active ?? false)) {
                              if ((poll == ""||poll!=getOptionName(count, data))&&(checkIfExists(data,poll))) {
                                poll = getOptionName(count, data);
                                debugPrint(
                                    "Title ${poll.toLowerCase().replaceAll(" ", "_")}");
                                // update();

                                postPollOfTheWeek(data.pollOfTheWeek?.id, poll);
                              } else {
                                debugPrint("Who $poll");
                                Fluttertoast.showToast(msg: "Poll already answered");
                              }
                            } else {
                              showNotaMember();
                            }
                          },
                          title: Text(
                            getOptionName(count, data),
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          secondary: SizedBox(
                            height: 7.h,
                            width: 25.w,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  item?.is_polled == 'false'
                                      ? ''
                                      : '${getOption(count, data)}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                          color: Colors.black, fontSize: 1.7.h
                                          // fontWeight: FontWeight.bold,
                                          ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                )
                              ],
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
          ),
          // SizedBox(
          //   height: 1.h,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigation.instance.navigate('/pollPage');
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 5.w),
          //     child: Text(
          //       'View All',
          //       style: Theme.of(context).textTheme.headline5?.copyWith(
          //             color: Storage.instance.isDarkMode
          //                 ? Colors.white
          //                 : Constance.primaryColor,
          //             fontWeight: FontWeight.bold,
          //           ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }

  getOption(int count, DataProvider data) {
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
  bool checkIfExists(data,poll){
    if(poll==(data.pollOfTheWeek?.option1 ?? "")||poll==(data.pollOfTheWeek?.option2 ?? "")||poll==(data.pollOfTheWeek?.option3 ?? "")){
      return false;
    }
    return true;
  }

  void postPollOfTheWeek(int? id, String poll) async {
    final response = await ApiProvider.instance.postPollOfTheWeek(id, poll);
    if (response.success ?? false) {
      logThePollSelectedClick(
        data.profile!,
        data.pollOfTheWeek!.title!,
        poll.toLowerCase().replaceAll(" ", "_"),
        data.pollOfTheWeek!.id!,
      );
      Fluttertoast.showToast(msg: response.message ?? "Posted successfully");
      update();
    } else {}
  }

  void logThePollSelectedClick(
    Profile profile,
    String heading,
    String answer,
    int thisId,
  ) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "poll_of_the_week_selection",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "heading_name":
            heading.length > 100 ? heading.substring(0, 100) : heading,
        "article_id": thisId,
        "screen_name": "home",
        "poll_selected": getAnswer(answer),
        "title": "poll_of_the_week",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  getAnswer(String answer) {
    return answer;
  }
}
