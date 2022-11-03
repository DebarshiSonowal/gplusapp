import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
// import 'package:sms_autofill/sms_autofill.dart';

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
  var textEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? timer;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _verificationId;

  // final SmsAutoFill _autoFill = SmsAutoFill();
  String currentText = '';
  String time = '30';
  bool resend = false;

  @override
  void dispose() {
    textEditingController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);

      // showSnackbar("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
    };
    Future.delayed(Duration.zero, () {
      phoneSignIn(phoneNumber: widget.number.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
                  ' received in',
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
                animationDuration: Duration(milliseconds: 300),
                // backgroundColor: Colors.blue.shade50,
                enableActiveFill: true,
                // errorAnimationController: errorController,
                controller: textEditingController,
                onCompleted: (v) {
                  print("Completed");
                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
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
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: CustomButton(
                  txt: 'Submit',
                  onTap: () async {
                    // GetProfile();
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: _verificationId!,
                              smsCode: textEditingController.text);
                      await _auth
                          .signInWithCredential(credential)
                          .then((value) {
                        getProfile();
                      }).catchError((e){
                        print( _verificationId);
                        print( _verificationId);
                        print(textEditingController.text);
                        showError(e??"Something went wrong");
                      });
                    } catch (e) {
                      print(e);
                      showError("Something went wrong");
                    }
                    // phoneSignIn(phoneNumber: widget.number.toString());
                  }),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              'Didn\'t receive OTP?',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                    fontSize: 15.sp,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                if (time == '0') {
                  phoneSignIn(phoneNumber: widget.number.toString());
                } else {}
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
              'In ${time} seconds',
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

  AppBar buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: (){
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
    );
  }

  void GetProfile() async {
    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      // showSnackbar('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    debugPrint('+91$phoneNumber');
    showLoaderDialog(context);
    await _auth
        .verifyPhoneNumber(
            phoneNumber: '+91$phoneNumber',
            verificationCompleted: _onVerificationCompleted,
            verificationFailed: _onVerificationFailed,
            codeSent: _onCodeSent,
            codeAutoRetrievalTimeout: _onCodeTimeout)
        .onError((error, stackTrace) {
      print(error);
    });
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      textEditingController.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      // try {
      //   UserCredential credential =
      //       await user!.linkWithCredential(authCredential);

      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'provider-already-linked') {
      UserCredential _authResult =
          await _auth.signInWithCredential(authCredential);

      if (_authResult.additionalUserInfo?.isNewUser ?? false) {
        Navigation.instance
            .navigateAndReplace('/terms&conditions', args: widget.number);
      } else {
        getProfile();
      }

      //   }
      // }

      // setState(() {
      //   isLoading = false;
      // });
      // Navigator.pushNamedAndRemoveUntil(
      //     context, Constants.homeNavigate, (route) => false);
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verification, int? forceResendingToken) {
    _verificationId = verification;
    print(forceResendingToken);
    print(forceResendingToken);
    print("code sent ${_verificationId}");
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
    final reponse = await ApiProvider.instance.login(widget.number.toString());
    if (reponse.status ?? false) {
      setState(() {
        Storage.instance.setUser(reponse.access_token ?? "");
      });
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(reponse.profile!);
      // Navigation.instance.goBack();
      // Navigation.instance.navigateAndReplace('/main');
      if (reponse.profile?.email == null ||
          reponse.profile?.email == "" ||
          reponse.profile?.is_new == 1) {
        Navigation.instance.navigate('/terms&conditions', args: widget.number);
      } else {
        Navigation.instance.navigateAndReplace('/main');
        // Navigation.instance.navigate('/terms&conditions', args: widget.number);
      }
    } else {
      Navigation.instance.navigate('/terms&conditions', args: widget.number);
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
        if (mounted) {
          setState(() {
            timer.cancel();
          });
        } else {
          timer.cancel();
        }
      }
      if (mounted) {
        print(timer.tick);
        try {
          setState(() {
            time = (30 - timer.tick).toString();
          });
        } catch (e) {
          print(e);
          time = (30 - timer.tick).toString();
        }
      } else {
        print(timer.tick);
        time = (30 - timer.tick).toString();
      }
      print("Dekhi 5 sec por por kisu hy ni :/");
    });
  }
}
