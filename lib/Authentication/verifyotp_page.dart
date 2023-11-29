import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Components/alert.dart';
import '../Components/custom_button.dart';
import '../Navigation/Navigate.dart';

class VerifyOTP extends StatefulWidget {
  final int number;

  VerifyOTP(this.number);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final textEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? timer;

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _verificationId;

  // final SmsAutoFill _autoFill = SmsAutoFill();
  String currentText = '';
  String time = '30';
  bool resend = false, isButtonEnabled = true;

  @override
  void dispose() {
    textEditingController.dispose();
    try {
      timer?.cancel();
    } catch (e) {
      debugPrint(e.toString());
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      phoneSignIn(phoneNumber: widget.number.toString());
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("verify"),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ENTER OTP',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  ' received on',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 15.sp,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'the number ',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 16.sp,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '+91 XXXXXXXX${widget.number.toString().split('')[8]}${widget.number.toString().split('')[9]}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.phone,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  activeColor: Colors.black,
                  fieldHeight: 6.7.h,
                  fieldWidth: 12.w,
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.grey.shade100,
                  selectedColor: Colors.black,
                  inactiveColor: Colors.grey.shade700,
                  inactiveFillColor: Colors.white,
                ),

                textStyle: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                hintCharacter: '0',
                hintStyle: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.grey.shade300,
                      fontSize: 2.h,
                    ),
                animationDuration: const Duration(milliseconds: 300),
                // backgroundColor: Colors.blue.shade50,
                enableActiveFill: true,
                // errorAnimationController: errorController,
                controller: textEditingController,
                onCompleted: (v) {
                  debugPrint("Completed ");
                },
                onChanged: (value) {
                  debugPrint(value);
                  setState(() {
                    currentText = value;
                    if (value.length == 6) {
                      isButtonEnabled = false;
                    } else {
                      isButtonEnabled = true;
                    }
                  });
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  setState(() {});
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                appContext: context,
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Container(
              height: 6.h,
              width: 66.w,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: CustomButton(
                txt: 'Submit',
                onTap: () async {
                  // GetProfile();
                  verifyOtp(widget.number, textEditingController.text);
                  // try {
                  //   PhoneAuthCredential credential =
                  //       PhoneAuthProvider.credential(
                  //           verificationId: _verificationId ?? "",
                  //           smsCode: textEditingController.text);
                  //   await _auth
                  //       .signInWithCredential(credential)
                  //       .then((UserCredential value) {
                  //     getProfile();
                  //   });
                  //   //     .catchError((e) {
                  //   //   debugPrint(_verificationId);
                  //   //   debugPrint("s ${e}");
                  //   //   debugPrint(textEditingController.text);
                  //   //   showError("$e");
                  //   // });
                  // } on FirebaseAuthException catch (_, e) {
                  //   debugPrint(_.code);
                  //   // if(dev)
                  //   Navigation.instance.goBack();
                  //   showError("${_.message}");
                  //   setState(() {
                  //     isButtonEnabled = true;
                  //   });
                  // else
                  //    simple
                  // }
                  // phoneSignIn(phoneNumber: widget.number.toString());
                },
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              'Didn\'t receive OTP?',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                    fontSize: 15.sp,
                    // fontWeight: FontWe ight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                if (time == '0') {
                  phoneSignIn(phoneNumber: widget.number.toString());
                }
              },
              child: Text(
                'Send Again',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              'In $time seconds',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                    fontSize: 15.sp,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    debugPrint('+91$phoneNumber');
    showLoaderDialog(context);
    // await _auth
    //     .verifyPhoneNumber(
    //         phoneNumber: '+91$phoneNumber',
    //         verificationCompleted: _onVerificationCompleted,
    //         verificationFailed: _onVerificationFailed,
    //         codeSent: _onCodeSent,
    //         codeAutoRetrievalTimeout: _onCodeTimeout)
    //     .onError((error, stackTrace) {
    //   debugPrint('error ${error} ${stackTrace}');
    // }).then((value) {
    //   setState(() {
    //     time = '30';
    //     // setTimer();
    //   });
    // });
    final response = await ApiProvider.instance.sendOTP(phoneNumber);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: "OTP sent successfully");
    } else {
      Navigation.instance.goBack();
      Navigation.instance.goBack();
    }
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    // print("verification completed ${authCredential.smsCode}");
    // User? user = FirebaseAuth.instance.currentUser;
    debugPrint('Verification completed ${authCredential..smsCode}');
    setState(() {
      textEditingController.text = authCredential.smsCode!;
    });
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
    setState(() {
      isButtonEnabled = true;
    });
  }

  _onCodeSent(String verification, int? forceResendingToken) {
    _verificationId = verification;
    // debugPrint(forceResendingToken);
    debugPrint(forceResendingToken.toString());
    debugPrint("code sent $_verificationId");
    Fluttertoast.showToast(msg: "OTP sent successfully");
    Navigation.instance.goBack();
    setTimer();
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(
              errorMessage,
              style: Theme.of(context).textTheme.headline4,
            ),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      // setState(() {
      //   isLoading = false;
      // });
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

  void getProfile() async {
    Navigation.instance.navigate("/loadingDialog");
    final reponse = await ApiProvider.instance.getprofile();
    if (reponse.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(reponse.profile!);
      // Navigation.instance.goBack();
      // Navigation.instance.navigateAndReplace('/main');
      if (reponse.profile?.email == null ||
          reponse.profile?.email == "" ||
          reponse.profile?.l_name == "" ||
          reponse.profile?.is_new == 1) {
        // Storage.instance.setToken(reponse.access_token ?? "");
        Navigation.instance.goBack();
        Navigation.instance
            .navigateAndReplace('/terms&conditions', args: widget.number);
      } else {
        fetchToken();
        try {
          timer?.cancel();
        } catch (e) {
          debugPrint(e.toString());
        }
        // Storage.instance.setUser(reponse.access_token ?? "");
        Navigation.instance.navigateAndRemoveUntil('/main');
        // Navigation.instance.navigate('/terms&conditions', args: widget.number);
      }
    } else {
      showError(
          "Your account has been suspended. Please contact with G Plus Admin");
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        color: Colors.white,
        child: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(
                "Loading...",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void setTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == 30) {
        try {
          if (mounted) {
            setState(() {
              timer.cancel();
            });
          } else {
            timer.cancel();
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      if (mounted) {
        debugPrint(timer.tick.toString());
        try {
          setState(() {
            time = (30 - timer.tick).toString();
          });
        } catch (e) {
          debugPrint(e.toString());
          time = (30 - timer.tick).toString();
        }
      } else {
        debugPrint(timer.tick.toString());
        time = (30 - timer.tick).toString();
      }
      // print("Dekhi 5 sec por por kisu hy ni :/");
    });
  }

  void fetchToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    sendToken(fcmToken!);
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.
      sendToken(fcmToken);
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });
  }

  void sendToken(String fcmToken) async {
    final response = await ApiProvider.instance.updateDeviceToken(fcmToken);
    if (response.success ?? false) {
    } else {}
  }

  void verifyOtp(int mobile, String otp) async {
    Navigation.instance.navigate("/loadingDialog");
    final response = await ApiProvider.instance.verifyOTP(mobile, otp);
    if (response.success ?? false) {
      final result =
          await Storage.instance.setToken(response.access_token ?? "");
      Navigation.instance.goBack();
      if (response.is_new == 0) {
        getProfile();
      } else {
        Navigation.instance
            .navigateAndReplace('/terms&conditions', args: widget.number);
      }
    } else {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: response.message ?? "Something went wrong");
    }
  }
}
