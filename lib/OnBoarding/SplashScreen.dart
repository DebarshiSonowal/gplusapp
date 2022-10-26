import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
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
    Future.delayed(const Duration(seconds: 3), () {
      print('LOGGEDIN');
      if (Storage.instance.isLoggedIn) {
        fetchProfile();

      // } else if (Storage.instance.isOnBoarding) {
      //   Navigation.instance.navigateAndRemoveUntil('/login');
      } else {
        Navigation.instance.navigateAndRemoveUntil('/login');
        // Navigation.instance.navigateAndRemoveUntil('/onboarding');
      }
    });
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
        Navigation.instance.navigateAndRemoveUntil('/main');
      }else{
        Navigation.instance.navigateAndRemoveUntil('/login');
      }
    } else {
      // Navigation.instance.goBack();
      Navigation.instance.navigateAndRemoveUntil('/login');
    }
  }
}
