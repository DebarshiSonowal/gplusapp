import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool big_deal = true;
  bool guwahati_connect = true;
  bool classified = true;
  bool dark_mode = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade100,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Constance.secondaryColor,
                    size: 3.5.h,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Constance.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color: Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Text(
                    'Notification Permission',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 2.h,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Big Deal',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                          // fontSize: 2.h,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Switch(
                    activeColor: Constance.secondaryColor,
                    onChanged: (bool value) {
                      setState(() {
                        big_deal = value;
                      });
                    },
                    value: big_deal,
                  ),
                ],
              ),
              SizedBox(
                height: 0.2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Guwahati Connect',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                          // fontSize: 2.h,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Switch(
                    activeColor: Constance.secondaryColor,
                    onChanged: (bool value) {
                      setState(() {
                        guwahati_connect = value;
                      });
                    },
                    value: guwahati_connect,
                  ),
                ],
              ),
              SizedBox(
                height: 0.2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Classified',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                          // fontSize: 2.h,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Switch(
                    activeColor: Constance.secondaryColor,
                    onChanged: (bool value) {
                      setState(() {
                        classified = value;
                      });
                    },
                    value: classified,
                  ),
                ],
              ),
              SizedBox(
                height: 0.2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 2.h,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Switch(
                    activeColor: Constance.secondaryColor,
                    onChanged: (bool value) {
                      setState(() {
                        dark_mode = value;
                      });
                    },
                    value: dark_mode,
                  ),
                ],
              ),
              SizedBox(
                height: 0.2.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color: Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rate Us',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 2.h,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  RatingBar.builder(
                    unratedColor: Colors.grey.shade300,
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 24.sp,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.5.w),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color: Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Text(
                    'Feedback',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 2.h,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter the Feedback',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black54,
                        // fontSize: 1.5.h,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(txt: 'Submit', onTap: () {}),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color: Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Constance.secondaryColor),
                  ),
                  onPressed: () async{
                    final FirebaseAuth _auth = FirebaseAuth.instance;
                    await _auth.signOut();
                    Storage.instance.logout();
                    Navigation.instance.navigateAndRemoveUntil('/login');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        "Sign Out",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                              fontSize: 14.5.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                height: 4.5.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide(
                      width: 0.2.h,
                      color: Constance.secondaryColor,
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Constance.secondaryColor,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        "Delete Account",
                        style:
                            Theme.of(context).textTheme.headline5?.copyWith(
                                  color: Constance.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search');
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
