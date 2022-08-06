import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../Components/custom_button.dart';
import '../Navigation/Navigate.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  var textEditingController = TextEditingController();

  String currentText = '';

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
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
                        fontSize: 2.h,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  ' received in',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 2.h,
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
                        fontSize: 2.h,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '+91 XXXXXXXXXX',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 2.h,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  activeColor: Colors.black,
                  fieldHeight: 50,
                  fieldWidth: 40,
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
              height: 5.h,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomButton(
                  txt: 'Submit',
                  onTap: () {
                    Navigation.instance.navigateAndReplace('/terms&conditions');
                  }),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              'Didn\'t receive OTP?',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.black,
                    fontSize: 2.h,
                    // fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Send Again',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      fontSize: 2.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Text(
              'In 30 seconds',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                color: Colors.black,
                fontSize: 2.h,
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
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill, scale: 2,),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }
}
