import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:sizer/sizer.dart';

import '../Components/alert.dart';
import '../Helper/Constance.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool agreed=false;

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
                // fontSize: 2.5.h,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              Constance.terms,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.black,
                // fontSize: 1.6.h,
                // fontWeight: FontWeight.bold,
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
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.all(Colors.grey.shade300),
                      checkColor: Colors.black,
                      value: agreed, onChanged:(val){
                    setState((){
                      agreed = val!;
                    });
                  }),
                  Text(
                    'I accept all the Terms and Conditions',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.7.h,
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
              height: 5.h,
              child: CustomButton(
                txt: 'continue',
                onTap: (){
                    if (agreed) {
                      Navigation.instance.navigateAndReplace('/personaldetails');
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

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill,scale: 2,),
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
