import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _mobile = TextEditingController();

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
                  padding: const EdgeInsets.all(0.1),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          fontSize: 9.sp,
                        ),
                    controller: _mobile,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Enter mobile number',
                      labelStyle:
                          Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.grey.shade700,
                                fontSize: 10.sp,
                              ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 6.h,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: CustomButton(
                    txt: 'continue',
                    onTap: () {
                      Navigation.instance.navigate('/verifyOtp');
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
