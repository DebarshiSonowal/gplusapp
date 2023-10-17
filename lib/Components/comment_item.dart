import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/comment.dart';
import '../Model/profile.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'alert.dart';

class CommentItem extends StatelessWidget {
  final Comment current;
  final BuildContext context;
  final bool liked;
  bool like = false;
  final Function fetchGuwahatiConnect;
  CommentItem(
      {super.key,
      required this.current,
      required this.context,
      required this.liked, required this.fetchGuwahatiConnect}) {
    like = liked;
  }

  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, _) {
      return Consumer<DataProvider>(builder: (context, data, __) {
        return data.profile?.id == current.user_id
            ? FocusedMenuHolder(
                blurSize: 5.0,
                menuItemExtent: 45,
                menuBoxDecoration: BoxDecoration(
                  color:
                      // Storage.instance.isDarkMode ? Colors.black : Colors.grey,
                  Constance.secondaryColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                duration: const Duration(milliseconds: 100),
                animateMenuItems: true,
                blurBackgroundColor: Colors.black54,
                openWithTap: false,
                // Open Focused-Menu on Tap rather than Long Press
                menuOffset: 10.0,
                // Offset value to show menuItem from the selected item
                bottomOffsetHeight: 80.0,
                // Offset hei
                onPressed: () {},
                menuItems: <FocusedMenuItem>[
                  // Add Each FocusedMenuItem  for Menu Options
                  FocusedMenuItem(
                    title: Text(
                      "Edit",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                    ),
                    trailingIcon: Icon(
                      Icons.edit,
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                    onPressed: () {
                      _displayTextInputDialog(
                          context, current.id, current.comment);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenTwo()));
                    },
                  ),
                  FocusedMenuItem(
                    title: Text(
                      "Delete",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                    ),
                    trailingIcon: const Icon(
                      Icons.delete,
                      color: Constance.thirdColor,
                    ),
                    onPressed: () {
                      deleteComment(current.id);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenTwo()));
                    },
                  ),
                ],
                child: body(context, _, data.profile?.id),
              )
            : FocusedMenuHolder(
                blurSize: 5.0,
                menuItemExtent: 45,
                menuBoxDecoration: BoxDecoration(
                  color:
                      Storage.instance.isDarkMode ? Colors.black : Colors.grey,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                duration: const Duration(milliseconds: 100),
                animateMenuItems: true,
                blurBackgroundColor: Colors.black54,
                openWithTap: false,
                // Open Focused-Menu on Tap rather than Long Press
                menuOffset: 10.0,
                // Offset value to show menuItem from the selected item
                bottomOffsetHeight: 80.0,
                // Offset hei

                menuItems: <FocusedMenuItem>[
                  // Add Each FocusedMenuItem  for Menu Options
                  FocusedMenuItem(
                    title: Text(
                      "Block user",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                    ),
                    trailingIcon: Icon(
                      Icons.block,
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                    onPressed: () {
                      blockUser(current.user_id);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenTwo()));
                    },
                  ),
                  FocusedMenuItem(
                    title: Text(
                      "Report this comment",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                    ),
                    trailingIcon: const Icon(
                      Icons.report,
                      color: Constance.thirdColor,
                    ),
                    onPressed: () {
                      _showAlertDialog(context, current.id);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ScreenTwo()));
                    },
                  ),
                ],
                onPressed: (){} ,
                child: body(context, _, data.profile?.id),
              );
      });
    });
  }

  Container body(BuildContext context, StateSetter _, int? id) {
    return Container(
      color: Colors.white,
      // height: 16.h,
      width: 40.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 0.4.h,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  current.name ?? "",
                  // "${id} ,${current.user_id}",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.black
                            : Constance.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                // Icon(
                //   Icons.menu,
                //   color: Colors.black,
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          SizedBox(
            width: 90.w,
            child: Text(
              current.comment ?? "",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          // Text(
          //   "",
          //   style: Theme.of(context)
          //       .textTheme
          //       .headline5
          //       ?.copyWith(
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold,
          //       ),
          // ),
          // SizedBox(
          //   height: 1.h,
          // ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        onPressed: () {
                          _(() {
                            like = !like;
                          });
                          postCommentLike(current.id, like ? 1 : 0, _);
                        },
                        splashRadius: 20.0,
                        splashColor: Constance.secondaryColor,
                        icon: Icon(
                          Icons.thumb_up,
                          color: like
                              ? Constance.secondaryColor
                              : Constance.primaryColor,
                        ),
                      ),
                    ),
                    Text(
                      '${like ? (current.like_count ?? 0 + 1) : current.like_count} likes' ??
                          "",
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SizedBox(
          //   height: 1.h,
          // ),
        ],
      ),
    );
  }
  void blockUser(int? id) async {
    final response =
    await ApiProvider.instance.blockUser(id, 'guwahati-connect');
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: response.message ?? "Something went wrong");
      fetchGuwahatiConnect();
    } else {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: response.message ?? "Something went wrong");
    }
  }

  void logTheBlockUserClick(
      Profile profile,
      String post,
      ) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "block_user",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "post": post.length > 100 ? post.substring(0, 100) : post,
        // "cta_click": cta_click,
        "screen_name": "guwahati",
        "user_login_status":
        Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void showBlockConfirmation(int? user_id, name, context, post) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
          title: Text(
            'Are you sure you want to block ${name} ?',
            style: Theme.of(context).textTheme.headline5?.copyWith(
              color: !Storage.instance.isDarkMode
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.5.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Text(
                  'You will not be able to see ${name}\'s:',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: !Storage.instance.isDarkMode
                        ? Colors.black
                        : Colors.white,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                Html(
                  data: """ 
                <ul> 
                     <li>* Posts </li> <br/>
                     <li>* Comments </li> <br/>
                     <li>* Notifications </li>  <br/>
                <ul>
                """,
                  shrinkWrap: true,
                  style: {
                    '#': Style(
                      fontSize: FontSize(10.sp),

                      // maxLines: 20,
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      // textOverflow: TextOverflow.ellipsis,
                    ),
                  },
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: !Storage.instance.isDarkMode
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirm',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: !Storage.instance.isDarkMode
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              onPressed: () {
                logTheBlockUserClick(
                    Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                        .profile!,
                    post);
                blockUser(user_id);
              },
            ),
            // TextButton(
            //   child: const Text('Yes'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  void postCommentLike(id, is_like, _) async {
    final response = await ApiProvider.instance.postCommentLike(id, is_like);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "");
      _(() {
        like = is_like == 0 ? false : true;
      });
      // fetchGuwahatiConnect();

    } else {
      showError("Something went wrong");
    }
    Future.delayed(const Duration(seconds: 2),(){
      FocusScope.of(context).requestFocus(FocusNode());
    });
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

  Future<void> _displayTextInputDialog(
      BuildContext context, int? id, String? text) async {
    String valueText = "";
    _textFieldController.text = text ?? "";
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor:
                  !Storage.instance.isDarkMode ? Colors.white : Colors.black,
              title: Text(
                'Edit the comment',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
              ),
              content: TextField(
                cursorColor:
                    Storage.instance.isDarkMode ? Colors.white : Colors.black,
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _textFieldController,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                decoration: const InputDecoration(
                  hintText: "Enter a comment",
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    // textColor: Colors.white,
                    textStyle: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.white),
                    fixedSize: const Size.fromWidth(100),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    // textColor: Colors.white,
                    textStyle: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.white),
                    fixedSize: const Size.fromWidth(100),
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    if (text != _textFieldController.text &&
                        _textFieldController.text.isNotEmpty) {
                      setState(() {
                        updateComment(id, _textFieldController.text);
                      });
                    } else {
                      showError("Please enter a different comment");
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  void deleteComment(int? id) async {
    Navigation.instance.navigate('/loadinDialog');
    final response = await ApiProvider.instance.deleteComment(id!);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      // Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
    Future.delayed(const Duration(seconds: 2),(){
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  void updateComment(int? id, String comment) async {
    final response = await ApiProvider.instance.editComment(id, comment);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "");
      Navigation.instance.goBack();
      // Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      // Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
    Future.delayed(const Duration(seconds: 2),(){
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  Future<void> _showAlertDialog(context, id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Storage.instance.isDarkMode ? Colors.black : Colors.white,
          // <-- SEE HERE
          title: Text(
            'Please select a problem',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: !Storage.instance.isDarkMode
                      ? Colors.black
                      : Colors.white,
                ),
          ),
          content: SizedBox(
            height: 27.h,
            width: 40.w,
            child: Column(
              children: [
                Text(
                  "If someone is in immediate danger, get help before reporting to G Plus. Don't wait.",
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: !Storage.instance.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                SizedBox(
                  height: 15.h,
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 0),
                    itemCount: Provider.of<DataProvider>(context, listen: false)
                        .reportCategories
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = Provider.of<DataProvider>(context, listen: false)
                          .reportCategories[index];
                      return GestureDetector(
                        onTap: () {
                          reportPost_Comment(
                              context, id, item.id, "guwahati-connect");
                        },
                        child: Text(
                          item.name ?? "",
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                                color: !Storage.instance.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                              ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.4.h),
                        child: Divider(
                          color: !Storage.instance.isDarkMode
                              ? Colors.black
                              : Colors.white,
                          thickness: 0.01.h,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: !Storage.instance.isDarkMode
                          ? Colors.black
                          : Colors.white,
                    ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // TextButton(
            //   child: const Text('Yes'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  void reportPost_Comment(context, id, report_type, type) async {
    final response =
        await ApiProvider.instance.reportPost_Comment(id, report_type, type);
    if (response.success ?? false) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: response.message ?? "Something went wrong");
    } else {
      Navigator.of(context).pop();
      showError(response.message ?? "Unable to report");
    }
  }
}
