import 'package:flutter/material.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../Menu/berger_menu_member_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var first_name = TextEditingController();
  var last_name = TextEditingController();
  var email = TextEditingController();
  var date = '';
  int year = 2000;
  int max = 2022;
  int currentY = 2022;
  String dropdownvalue = 'Male';
  var items = [
    'Male',
    'Women',
    'Others',
  ];
  List<String> selGeo = [];
  List<String> selTop = [];

  bool big_deal = true;
  bool guwahati_connect = true;
  bool classified = true;
  bool dark_mode = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        var current = DateTime.now();
        final f = DateFormat('dd-MM-yyyy');
        date = f.format(current);
        final y = DateFormat('yyyy');
        currentY = int.parse(y.format(current));
        year = currentY - 18;
        max = currentY + 18;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    first_name.dispose();
    last_name.dispose();
    email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      // drawer: BergerMenuMemPage(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(6.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Personal Details',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.5.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: first_name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter First Name',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.5.h,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: last_name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter Last Name',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.5.h,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter Email',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.5.h,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 2.5.h,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Icon(
                    Icons.location_on,
                    color: Constance.secondaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              GestureDetector(
                onTap: (){
                  Navigation.instance.navigate('/editSavedAddresses');
                },
                child: Row(
                  children: [
                    Text(
                      'Khanapara, Guwahati',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Constance.primaryColor,
                            // fontSize: 2.h,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Constance.primaryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'Change your News interests',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'Geographical',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                // height: 15.h,
                width: double.infinity,
                child: Wrap(
                  children: [
                    for (int i = 0; i < Constance.geo.length; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!selGeo.contains(Constance.geo[i])) {
                              selGeo.add(Constance.geo[i]);
                            } else {
                              selGeo.remove(Constance.geo[i]);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: selGeo == null
                                ? Colors.white
                                : !selGeo.contains(Constance.geo[i])
                                    ? Colors.white
                                    : Constance.secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: selGeo == null
                                  ? Constance.primaryColor
                                  : !selGeo.contains(Constance.geo[i])
                                      ? Constance.primaryColor
                                      : Constance.secondaryColor,
                              width: 0.5.w,
                              // left: BorderSide(
                              //   color: Colors.green,
                              //   width: 1,
                              // ),
                            ),
                          ),
                          child: Text(
                            Constance.geo[i],
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Constance.primaryColor,
                                      // fontSize: 2.h,
                                      // fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'Topical',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                // height: 15.h,
                width: double.infinity,
                child: Wrap(
                  children: [
                    for (int i = 0; i < Constance.topical.length; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!selTop.contains(Constance.topical[i])) {
                              selTop.add(Constance.topical[i]);
                            } else {
                              selTop.remove(Constance.topical[i]);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: selTop == null
                                ? Colors.white
                                : !selTop.contains(Constance.topical[i])
                                    ? Colors.white
                                    : Constance.secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: selTop == null
                                  ? Constance.primaryColor
                                  : !selTop.contains(Constance.topical[i])
                                      ? Constance.primaryColor
                                      : Constance.secondaryColor,
                              width: 0.5.w,
                              // left: BorderSide(
                              //   color: Colors.green,
                              //   width: 1,
                              // ),
                            ),
                          ),
                          child: Text(
                            Constance.topical[i],
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Constance.primaryColor,
                                      // fontSize: 2.h,
                                      // fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'Notification Permission',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.h,
                      fontWeight: FontWeight.bold,
                    ),
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
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.h,
                      fontWeight: FontWeight.bold,
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
                height: 1.h,
              ),
              SizedBox(
                width: double.infinity,
                height: 5.h,
                child: CustomButton(
                  txt: 'Save & Continue',
                  onTap: () {
                    // Navigation.instance.navigateAndReplace('/enterPreferences');
                  },
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }
}
