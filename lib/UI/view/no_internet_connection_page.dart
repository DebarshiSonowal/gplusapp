import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:open_settings/open_settings.dart';
import 'package:sizer/sizer.dart';

import '../../Components/guwhati_connect_post_card.dart';
import '../../Helper/Constance.dart';

class NoInternetConnectionScreen extends StatefulWidget {
  const NoInternetConnectionScreen({super.key});

  @override
  State<NoInternetConnectionScreen> createState() =>
      _NoInternetConnectionScreenState();
}

class _NoInternetConnectionScreenState
    extends State<NoInternetConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Constance.primaryColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.grey.shade100,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Constance.logoIcon,
                scale: 1,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Oops! You are not connected to Internet',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Constance.thirdColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4.h,
              ),
              SizedBox(
                width: 40.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constance.secondaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.5.w,
                      vertical: 1.5.h,
                    ),
                    // textStyle:
                    //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    final result = await OpenSettings.openWIFISetting();
                  },
                  child: Text(
                    "Open Settings",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: 40.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constance.secondaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.5.w,
                      vertical: 1.5.h,
                    ),
                    // textStyle:
                    //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    var connectivityResult =
                    await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi) {
                      // I am connected to a mobile network.
                      debugPrint("I am connected to a mobile network.");
                      Future.delayed(const Duration(seconds: 2),(){
                        Navigation.instance.goBack();
                      });
                    } else {
                      showError("Please connect to a mobile network");
                    }
                  },
                  child: Text(
                    "Check the internet connectivity",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
