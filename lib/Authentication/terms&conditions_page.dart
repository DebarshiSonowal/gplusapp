import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Components/alert.dart';
import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';

class TermsAndConditions extends StatefulWidget {
  final int mobile;

  TermsAndConditions(this.mobile);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool agreed = false;

  String terms = Constance.terms;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchTermsandCondition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar(),
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
            SizedBox(
              height: 62.h,
              child: SingleChildScrollView(
                child: Html(data: terms,
                    // overflow: TextOverflow.clip,
                    style: {
                      '#': Style(
                        // fontSize: FontSize(_counterValue),
                        // maxLines: 20,
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        // textOverflow: TextOverflow.ellipsis,
                      ),
                    }),
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
                txt: 'Continue',
                onTap: () {
                  if (agreed) {
                    Navigation.instance.navigateAndReplace('/personaldetails',
                        args: widget.mobile);
                  } else {
                    showError('You have to agree to our terms and conditions');
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



  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Error",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }

  void fetchTermsandCondition() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getTerms();
    if (response.success ?? false) {
      Navigation.instance.goBack();
      setState(() {
        terms = response.desc ?? "";
      });
    } else {
      Navigation.instance.goBack();
    }
  }
}
