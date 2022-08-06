import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';

class BergerMenuPage extends StatefulWidget {
  const BergerMenuPage({Key? key}) : super(key: key);

  @override
  State<BergerMenuPage> createState() => _BergerMenuPageState();
}

class _BergerMenuPageState extends State<BergerMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(7.w),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill, scale: 2,),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }
}
