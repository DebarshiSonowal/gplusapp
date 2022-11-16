import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';

import '../Components/alert.dart';
import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/razorpay_key.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';

class PaymentProcessingPage extends StatefulWidget {
  String input;

  PaymentProcessingPage(this.input);

  @override
  State<PaymentProcessingPage> createState() => _PaymentProcessingPageState();
}

class _PaymentProcessingPageState extends State<PaymentProcessingPage> {
  double tempTotal = 0;
  var temp_order_id = "";
  final _razorpay = Razorpay();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    Future.delayed(Duration.zero, () {
      initiateOrder(widget.input.split(',')[0], widget.input.split(',')[1]);
    });
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              height: 12.h,
              width: 25.w,
              child: CircularProgressIndicator(
                strokeWidth: 4.sp,
                color: Storage.instance.isDarkMode
                    ? Colors.white
                    : Constance.primaryColor,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Please wait',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1?.copyWith(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Constance.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Your payment is being processed',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Storage.instance.isDarkMode
                        ? Colors.white70
                        : Constance.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Do not close this page',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Constance.thirdColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 5.h,
            ),
            CustomButton(txt: 'Cancel Payment', onTap: () {}),
          ],
        ),
      ),
    );
  }

  void initiateOrder(id, i) async {
    final response = await ApiProvider.instance.fetchRazorpay();
    if (response.status ?? false) {
      order(id, i, response.razorpay!);
    } else {
      showError(response.message ?? "Something went wrong");
    }
  }

  void order(subscription_id, use_referral_point, razorpay) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance
        .createOrder(subscription_id, use_referral_point);
    // startPayment(response.order?.base_price,response.order?.id,);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      tempTotal = response.order?.base_price ?? 0;
      temp_order_id = response.order?.voucher_no.toString() ?? "";
      startPayment(
          razorpay,
          response.order?.base_price,
          response.order?.voucher_no,
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .profile
              ?.id);
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }

  void startPayment(RazorpayKey razorpay, double? total, id, customer_id) {
    var options = {
      'key': razorpay.api_key,
      'amount': total! * 100,
      // 'order_id': id,
      'name':
          '${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.f_name} ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.l_name}',
      'description': 'Books',
      'prefill': {
        'contact': Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.mobile,
        'email': Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.email
      },
      'note': {
        'customer_id': customer_id,
        'order_id': id,
      },
    };
    debugPrint(jsonEncode(options));
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        'success ${response.paymentId} ${response.orderId} ${response.signature}');
    handleSuccess(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('error ${response.message} ${response.code} ');
    showError(response.message ?? "Something went wrong");
    // Navigation.instance.goBack();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  void handleSuccess(PaymentSuccessResponse response) async {
    final response1 = await ApiProvider.instance
        .verifyPayment(temp_order_id, response.paymentId, tempTotal ?? 1);
    if (response1.success ?? false) {
      fetchProfile();
      Navigation.instance.goBack();
      showDialogBox();
    } else {
      Navigation.instance.goBack();
      Navigation.instance.goBack();
      showError(response1.message ?? "Something went wrong");
    }
  }

  void fetchProfile() async {
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getprofile();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(response.profile!);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyTopicks(response.topicks);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGeoTopicks(response.geoTopicks);
      // Navigation.instance.goBack();
    } else {
      // Navigation.instance.goBack();
    }
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Congratulations',
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Constance.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You are now a member of G Plus community',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Close',
                      onTap: () {
                       Navigation.instance.navigate('/');
                      }),
                ),
              ],
            ),
          ),
        );
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
    );
  }
}