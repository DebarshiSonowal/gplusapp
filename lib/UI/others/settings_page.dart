
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool big_deal = true;
  bool guwahati_connect = true;
  bool classified = true;
  bool dark_mode = false;
  final TextEditingController _controller = TextEditingController();
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchSwitchStatus();
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: Constance.buildAppBar("settings", true, _scaffoldKey),
      appBar: Constance.buildAppBar2("settings"),
      // drawer: const BergerMenuMemPage(
      //   screen: "settings",
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color:
            Storage.instance.isDarkMode ? Colors.black : Colors.grey.shade100,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Constance.secondaryColor,
                      size: 3.5.h,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                SizedBox(
                  height: 1.h,
                  child: Divider(
                    color: Colors.black,
                    thickness: 0.4.sp,
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  children: [
                    Text(
                      'Notification Permission',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
                            // fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Big Deal',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            // fontSize: 2.h,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    Switch(
                      activeColor: Constance.secondaryColor,
                      inactiveTrackColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.grey.shade300,
                      onChanged: (bool value) {
                        setState(() {
                          big_deal = value;
                        });
                        updateSwitch(value ? 1 : 0, 'deal');
                      },
                      value: big_deal,
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Guwahati Connect',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            // fontSize: 2.h,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    Switch(
                      activeColor: Constance.secondaryColor,
                      inactiveTrackColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.grey.shade300,
                      onChanged: (bool value) {
                        setState(() {
                          guwahati_connect = value;
                        });
                        updateSwitch(value ? 1 : 0, 'connect');
                      },
                      value: guwahati_connect,
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Classified',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            // fontSize: 2.h,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    Switch(
                      activeColor: Constance.secondaryColor,
                      inactiveTrackColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.grey.shade300,
                      onChanged: (bool value) {
                        setState(() {
                          classified = value;
                        });
                        updateSwitch(value ? 1 : 0, 'classified');
                      },
                      value: classified,
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
                            // fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Switch(
                      activeColor: Constance.secondaryColor,
                      inactiveTrackColor: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.grey.shade300,
                      onChanged: (bool value) {
                        setState(() {
                          dark_mode = value;
                        });
                        updateSwitch(value ? 1 : 0, 'dark');
                      },
                      value: dark_mode,
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.2.h,
                ),
                SizedBox(
                  height: 1.h,
                  child: Divider(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    thickness: 0.4.sp,
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                GestureDetector(
                  onTap: () async {
                    debugPrint("onTap");
                    Navigation.instance.navigate("/loadingDialog");
                    if (await inAppReview.isAvailable()) {
                      debugPrint("onTap1");
                      Navigation.instance.goBack();
                      // await inAppReview.requestReview();
                      await inAppReview.openStoreListing(appStoreId: '6444875975');
                    } else if(Platform.isAndroid) {
                      debugPrint("onTap2");
                      Navigation.instance.goBack();
                      _launchURL("https://play.google.com/store/apps/details?id=com.appbazooka.gplus");
                    }else{
                      debugPrint("onTap3");
                      Navigation.instance.goBack();
                      _launchURL("https://apps.apple.com/us/app/keynote/id6444875975");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rate Us',
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Constance.primaryColor,
                              // fontSize: 2.h,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      RatingBar.builder(
                        unratedColor: Colors.grey.shade300,
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 24.sp,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.5.w),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                SizedBox(
                  height: 1.h,
                  child: Divider(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    thickness: 0.4.sp,
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  children: [
                    Text(
                      'Feedback',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
                            // fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                TextFormField(
                  autofocus: false,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.go,
                  minLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Enter the Feedback',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black54,
                          // fontSize: 1.5.h,
                        ),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Submit',
                      onTap: () {
                        if (_controller.text.isNotEmpty) {
                          postFeedBack(_controller.text);
                          _controller.text = "";
                          FocusScope.of(context).unfocus();
                        } else {
                          showError("Enter something");
                        }
                      }),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  height: 1.h,
                  child: Divider(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    thickness: 0.4.sp,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Constance.secondaryColor),
                    ),
                    onPressed: () async {
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      await _auth.signOut();
                      logTheLogoutClick(data.profile!);
                      Future.delayed(const Duration(seconds: 1), () {
                        Storage.instance.logout();
                        Navigation.instance.navigateAndRemoveUntil('/login');
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "Sign Out",
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black,
                                    fontSize: 14.5.sp,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                SizedBox(
                  height: 4.5.h,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                        width: 0.2.h,
                        color: Constance.secondaryColor,
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      deactivateAccount();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete,
                          color: Constance.secondaryColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "Delete Account",
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Constance.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  updateSwitch(val, type) async {
    final response = await ApiProvider.instance.setSwitch(val, type);
    if (response.success ?? false) {
      fetchSwitchStatusAfter(type);
    } else {
      showError(response.message ?? "Something went wrong");
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

  void fetchSwitchStatus() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getSwitchStatus();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSwitch(response.status);
      setState(() {
        big_deal = response.status?.deal ?? false;
        classified = response.status?.classified ?? false;
        guwahati_connect = response.status?.connect ?? false;
        dark_mode = response.status?.dark ?? false;
        // dark_mode = true;
        Storage.instance.setDarkMode(dark_mode);
      });
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError(response.msg ?? "Something went wrong");
    }
  }

  void fetchSwitchStatusAfter(type) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getSwitchStatus();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSwitch(response.status);
      big_deal = response.status?.deal ?? false;
      classified = response.status?.classified ?? false;
      guwahati_connect = response.status?.connect ?? false;
      dark_mode = response.status?.dark ?? false;
      // dark_mode = true;
      Storage.instance.setDarkMode(dark_mode);
      Navigation.instance.goBack();
      if (type == "dark") {
        // fetchSwitchStatus();
        try {
          setState(() {});
        } catch (e) {
          print(e);
        }
        Navigation.instance.navigateAndRemoveUntil('/main');
      }
    } else {
      Navigation.instance.goBack();
      showError(response.msg ?? "Something went wrong");
    }
  }

  void postFeedBack(String text) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.postFeedback(text);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: "Feedback posted successfully");
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }

  void deactivateAccount() async {
    final response = await ApiProvider.instance.deactiveAccount();
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: "Account deactivation request is received");
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }

  void logTheLogoutClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "log_out_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "screen_name": "logout",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
