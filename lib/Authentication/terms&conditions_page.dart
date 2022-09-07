import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:sizer/sizer.dart';

import '../Components/alert.dart';
import '../Helper/Constance.dart';

class TermsAndConditions extends StatefulWidget {
  final int mobile;


  TermsAndConditions(this.mobile);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(7.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Security Information',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Constance.primaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, //.horizontal
                child: Text(
                  Constance.terms,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontSize: 11.sp,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            // Spacer(),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.w,
                    width: 2.h,
                    child: Checkbox(
                        fillColor:
                            MaterialStateProperty.all(Colors.grey.shade300),
                        checkColor: Colors.black,
                        value: agreed,
                        onChanged: (val) {
                          setState(() {
                            agreed = val!;
                          });
                        }),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    'I accept all the Terms and Conditions',
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          fontSize: 13.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: CustomButton(
                txt: 'continue',
                onTap: () {
                  if (agreed) {
                    Navigation.instance
                        .navigateAndReplace('/personaldetails',args: widget.mobile);
                  } else {
                    showError(
                        'You have to agree to our terms and conditions');
                  }
                },
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
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
