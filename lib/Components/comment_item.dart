import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Model/comment.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';
import 'alert.dart';

class CommentItem extends StatelessWidget {
  final Comment current;
  final BuildContext context;
  final bool liked;
  bool like = false;

  CommentItem(
      {super.key,
      required this.current,
      required this.context,
      required this.liked}) {
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
            : body(context, _, data.profile?.id);
      });
    });
  }

  SizedBox body(BuildContext context, StateSetter _,int? id) {
    return SizedBox(
      height: 16.h,
      width: 40.w,
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
          Row(
            children: [
              Text(
                current.comment ?? "",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                    ),
              ),
            ],
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

          SizedBox(
            height: 1.h,
          ),
        ],
      ),
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
    _textFieldController.text = text??"";
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
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  void updateComment(int? id, String comment) async {
    final response = await ApiProvider.instance.editComment(id, comment);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "");
      Navigation.instance.goBack();
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }
}
