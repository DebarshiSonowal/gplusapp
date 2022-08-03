import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: Constance.listPagesViewModel,
        onDone: () {
          Navigation.instance.navigate('/login');
        },
        showBackButton: false,
        showSkipButton: true,
        overrideNext: Container(
          color: Colors.grey,
        ),
        skip: const Text("Skip"),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Storage.instance.setOnBoarding();

  }
}
