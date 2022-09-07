import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Navigation/Navigate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constance.primaryColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Constance.logoIcon,
              scale: 1,
            ),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      print('LOGGEDIN');
      if (Storage.instance.isLoggedIn) {
        Navigation.instance.navigateAndRemoveUntil('/main');
      } else if (Storage.instance.isOnBoarding) {
        Navigation.instance.navigateAndRemoveUntil('/login');
      } else {
        Navigation.instance.navigateAndRemoveUntil('/login');
        // Navigation.instance.navigateAndRemoveUntil('/onboarding');
      }
    });
  }
}
