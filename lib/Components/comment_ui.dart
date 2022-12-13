import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'alert.dart';
import 'comment_item.dart';

class CommentUI extends StatelessWidget {
  final int count;
  final ScrollController controller;
  final TextEditingController searchQueryController;
  final Function fetchGuwahatiConnect;

  const CommentUI(
      {Key? key,
      required this.count,
      required this.controller,
      required this.searchQueryController,
      required this.fetchGuwahatiConnect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: StatefulBuilder(builder: (context, _) {
        return Consumer<DataProvider>(builder: (context, data, __) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                // bottomRight: Radius.circular(40.0),
                topLeft: Radius.circular(25.0),
                // bottomLeft: Radius.circular(40.0),
              ),
            ),
            width: double.infinity,
            padding: EdgeInsets.only(top: 1.h),
            height: 70.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigation.instance.goBack();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Storage.instance.isDarkMode
                              ? Colors.black
                              : Constance.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Comments",
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.black
                                  : Constance.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // height: 35.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        controller: controller,
                        itemCount: data.guwahatiConnect[count].comments.length,
                        itemBuilder: (cont, ind) {
                          var current =
                              data.guwahatiConnect[count].comments[ind];
                          return CommentItem(
                              current: current,
                              context: context,
                              liked: current.is_liked);
                        }),
                  ),
                ),
                Container(
                  height: 8.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 0.5.h),
                        child: TextField(
                          controller: searchQueryController,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: "Write a comment",
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black26),
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (searchQueryController.text.isNotEmpty) {
                                  // search(_searchQueryController.text);

                                  if (Provider.of<DataProvider>(
                                              Navigation.instance.navigatorKey
                                                      .currentContext ??
                                                  context,
                                              listen: false)
                                          .profile
                                          ?.is_plan_active ??
                                      false) {
                                    // Navigation.instance.navigate('/exclusivePage');
                                    _(() {
                                      postComment(
                                          data.guwahatiConnect[count].id,
                                          'guwahati-connect',
                                          searchQueryController.text);
                                    });
                                  } else {
                                    Constance.showMembershipPrompt(
                                        context, () {});
                                  }
                                } else {
                                  showError('Enter something to search');
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(color: Colors.black),
                          onChanged: (query) => {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }

  void postComment(int? id, String s, String text) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.postComment(id, s, text);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      fetchGuwahatiConnect();
      searchQueryController.text = '';
    } else {
      Navigation.instance.goBack();
    }
  }
}
