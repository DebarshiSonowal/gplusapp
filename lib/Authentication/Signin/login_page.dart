import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobile = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _mobile.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constance.primaryColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 25.h,
                width: 70.w,
                child: Image.asset(
                  Constance.logoIcon,
                  scale: 1,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'LOGIN',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              // SizedBox(
              //   height: 3.h,
              // ),
              // Text(
              //   'Enter Your Registered Mobile Number',
              //   style: Theme.of(context)
              //       .textTheme
              //       .headline6
              //       ?.copyWith(color: Colors.white),
              // ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.1.h, horizontal: 1.w),
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                    controller: _mobile,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Enter mobile number',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle:
                          Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.grey.shade700,
                                fontSize: 12.sp,
                              ),
                      border: const OutlineInputBorder(),
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 6.h,
                width: 55.w,
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: CustomButton(
                    txt: 'Continue',
                    onTap: () {

                      // sendOTP(_mobile.text);
                      // Navigation.instance.navigate('/verifyOtp',args: int.parse('8638372157'));
                      if (_mobile.text.isNotEmpty &&
                          _mobile.text.length == 10) {
                        // sendOTP(_mobile.text);
                        logTheSignupInitiateClick();
                        // logTheSignupInitiateClick(Profile profile);
                        Navigation.instance.navigate('/verifyOtp',
                            args: int.parse(_mobile.text));
                      } else {
                        showError("Enter correct mobile number");
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void sendOTP(String text) async {
  //   final response = await ApiProvider.instance.login(text);
  //   if (response.status ?? false) {
  //     Fluttertoast.showToast(
  //       msg: 'OTP sent successfully',
  //       // fontSize: th
  //     );
  //     Navigation.instance.navigate('/verifyOtp', args: int.parse(text));
  //   } else {
  //     showError(response.message ?? "Something went wrong");
  //   }
  // }
  void logTheSignupInitiateClick() async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "sign_up_initiate",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": "NA",
        "screen_name": "register",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": "NA",
      },
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
}
