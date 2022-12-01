import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:provider/provider.dart';

import '../Helper/DataProvider.dart';
import '../Networking/api_provider.dart';

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
    // secureScreen();
    Future.delayed(Duration.zero, () {
      fetchDealMsg();
    });
    Future.delayed(const Duration(seconds: 1), () {
      print('LOGGEDIN');
      if (Storage.instance.isLoggedIn) {
        fetchSwitchStatus();

        // } else if (Storage.instance.isOnBoarding) {
        //   Navigation.instance.navigateAndRemoveUntil('/login');
      } else {
        Navigation.instance.navigateAndRemoveUntil('/login');
        // Navigation.instance.navigateAndRemoveUntil('/onboarding');
      }
    });
  }

  void fetchSwitchStatus() async {
    final response = await ApiProvider.instance.getSwitchStatus();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSwitch(response.status);
      setState(() {
        Storage.instance.setDarkMode(response.status?.dark ?? false);
      });
      fetchProfile();
    } else {}
  }

  void fetchProfile() async {
    print('object profile');
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getprofile();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      print('object profile');
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
      if (response.profile?.email == null ||
          response.profile?.email == "" ||
          response.profile?.is_new == 0) {
        fetchToken();
        Navigation.instance.navigateAndRemoveUntil('/main');
      } else {
        Navigation.instance.navigateAndRemoveUntil('/login');
      }
    } else {
      // Navigation.instance.goBack();
      Navigation.instance.navigateAndRemoveUntil('/login');
    }
  }

  void fetchDealMsg() async {
    final response = await ApiProvider.instance.fetchMessages();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setDealText(response.deal ?? "");
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassifiedText(response.classified ?? "");
    }
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
}
