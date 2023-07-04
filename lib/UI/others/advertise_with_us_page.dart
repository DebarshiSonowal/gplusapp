import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class AdvertiseWithUsPage extends StatefulWidget {
  const AdvertiseWithUsPage({Key? key}) : super(key: key);

  @override
  State<AdvertiseWithUsPage> createState() => _AdvertiseWithUsPageState();
}

class _AdvertiseWithUsPageState extends State<AdvertiseWithUsPage> {
  final _first_name = TextEditingController();
  final _last_name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _feedback = TextEditingController();
  String selected = "Print";

  @override
  void dispose() {
    super.dispose();
    _first_name.dispose();
    _last_name.dispose();
    _email.dispose();
    _mobile.dispose();
    _feedback.dispose();
  }

  final advertiseType = [
    'Print',
    'Website Banners',
    'Social Media',
    'Branded Content'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar2("advertise"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please fill out all the details below'
                  ' so that we can understand your requirements'
                  ' and get in touch with you at the earliest.',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                      ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                    border: Border.all(
                        width: 1,
                        //                   <--- border width here
                        color: Storage.instance.isDarkMode
                            ? Colors.white70
                            : Colors.black26),
                  ),
                  // color: Colors.black,
                  // height: 5.h,
                  child: Center(
                    child: TextField(
                      controller: _first_name,
                      autofocus: true,
                      cursorColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      decoration: InputDecoration(
                        hintText: "Please Enter First Name",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Storage.instance.isDarkMode
                                ? Colors.white70
                                : Colors.black26),
                      ),
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      onChanged: (query) => {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                    border: Border.all(
                        width: 1,
                        //                   <--- border width here
                        color: Storage.instance.isDarkMode
                            ? Colors.white70
                            : Colors.black26),
                  ),
                  // color: Colors.black,
                  // height: 5.h,
                  child: Center(
                    child: TextField(
                      controller: _last_name,
                      autofocus: true,
                      cursorColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      decoration: InputDecoration(
                        hintText: "Please Enter Last Name",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Storage.instance.isDarkMode
                                ? Colors.white70
                                : Colors.black26),
                      ),
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      onChanged: (query) => {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                    border: Border.all(
                        width: 1,
                        //                   <--- border width here
                        color: Storage.instance.isDarkMode
                            ? Colors.white70
                            : Colors.black26),
                  ),
                  // color: Colors.black,
                  // height: 5.h,
                  child: Center(
                    child: TextField(
                      controller: _email,
                      autofocus: true,
                      cursorColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      decoration: InputDecoration(
                        hintText: "Please Enter Email",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Storage.instance.isDarkMode
                                ? Colors.white70
                                : Colors.black26),
                      ),
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      onChanged: (query) => {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                    border: Border.all(
                        width: 1,
                        //                   <--- border width here
                        color: Storage.instance.isDarkMode
                            ? Colors.white70
                            : Colors.black26),
                  ),
                  // color: Colors.black,
                  // height: 5.h,
                  child: Center(
                    child: TextField(
                      controller: _mobile,
                      autofocus: true,
                      cursorColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      decoration: InputDecoration(
                        hintText: "Please Enter Mobile No.",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Storage.instance.isDarkMode
                                ? Colors.white70
                                : Colors.black26),
                      ),
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      onChanged: (query) => {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                    border: Border.all(
                        width: 1,
                        //                   <--- border width here
                        color: Storage.instance.isDarkMode
                            ? Colors.white70
                            : Colors.black26),
                  ),
                  // color: Colors.black,
                  // height: 5.h,
                  child: Center(
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: Storage.instance.isDarkMode
                          ? Colors.black
                          : Colors.white,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      // Initial Value
                      value: selected,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: advertiseType.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          selected = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.7.h,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                    border: Border.all(
                        width: 1,
                        //                   <--- border width here
                        color: Storage.instance.isDarkMode
                            ? Colors.white70
                            : Colors.black26),
                  ),
                  // color: Colors.black,
                  // height: 5.h,
                  child: Center(
                    child: TextField(
                      controller: _feedback,
                      autofocus: true,
                      cursorColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      decoration: InputDecoration(
                        hintText: "Text your feedback here",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Storage.instance.isDarkMode
                                ? Colors.white70
                                : Colors.black26),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      onChanged: (query) => {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    txt: 'Submit',
                    onTap: () {
                      if (_first_name.text.isNotEmpty &&
                          _last_name.text.isNotEmpty &&
                          _email.text.isNotEmpty &&
                          _mobile.text.isNotEmpty &&
                          _feedback.text.isNotEmpty) {
                        if (isValidEmail(_email.text)) {
                          if (_mobile.text.length == 10) {
                            submit(
                                _first_name.text,
                                _last_name.text,
                                _email.text,
                                _mobile.text,
                                selected,
                                _feedback.text);
                          } else {
                            showError("Enter a valid mobile number");
                          }
                        } else {
                          showError("Enter a valid email");
                        }
                      } else {
                        showError("Enter all the details");
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  bool isValidEmail(email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
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
          icon: Consumer<DataProvider>(builder: (context, data, _) {
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
          }),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search', args: "");
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void submit(String text, String text2, String text3, String text4,
      String selected, String text5) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance
        .advertiseWithUs(text, text2, text3, text4, selected, text5);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: response.message ?? "Successfully posted");
      _first_name.clear();
      _last_name.clear();
      _feedback.clear();
      _email.clear();
      _mobile.clear();
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }
}
