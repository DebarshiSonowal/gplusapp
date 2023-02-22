import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/profile.dart';
import 'package:gplusapp/Model/topick.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Networking/api_provider.dart';

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
  String dropdownvalue = 'Male', address = '', id = '0';
  var items = [
    'Male',
    'Women',
    'Others',
  ];
  List<GeoTopick> selGeo = [];
  List<Topick> selTop = [];

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
      fetchTopicks();
      fetchProfile();
      fetchAddress();
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
      appBar: Constance.buildAppBar("profile",true),
      // drawer: BergerMenuMemPage(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.all(6.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Personal Details',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        // fontSize: 2.5.h,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  padding: !Storage.instance.isDarkMode
                      ? EdgeInsets.all(0)
                      : EdgeInsets.symmetric(vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
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
                      labelStyle:
                          Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.black,
                                // fontSize: 1.5.h,
                              ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  padding: !Storage.instance.isDarkMode
                      ? EdgeInsets.all(0)
                      : EdgeInsets.symmetric(vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
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
                      labelStyle:
                          Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.black,
                                // fontSize: 1.5.h,
                              ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  padding: !Storage.instance.isDarkMode
                      ? EdgeInsets.all(0)
                      : EdgeInsets.symmetric(vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
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
                      labelStyle:
                          Theme.of(context).textTheme.headline6?.copyWith(
                                color: Colors.black,
                                // fontSize: 1.5.h,
                              ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
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
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
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
                  onTap: () async {
                    final response = await Navigation.instance
                        .navigate('/editSavedAddresses', args: 0);
                    if (response != null) {
                      setState(() {
                        address = Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .addresses!
                                    // .firstWhere((element) => element.id == response)
                                    [0]
                                .address ??
                            "";
                        id = response.toString();
                      });
                    } else {}
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          address,
                          overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.primaryColor,
                                    // fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Storage.instance.isDarkMode
                            ? Constance.secondaryColor
                            : Constance.primaryColor,
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
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
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
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
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
                      for (int i = 0; i < data.geoTopicks.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!check(selGeo, data.geoTopicks[i])) {
                                selGeo.add(data.geoTopicks[i]);
                              } else {
                                // selGeo.remove(data.geoTopicks[i]);
                                selGeo.removeWhere((element) =>
                                    element.id == data.geoTopicks[i].id);
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
                                  : !check(selGeo, data.geoTopicks[i])
                                      ? Colors.white
                                      : Constance.secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: selGeo == null
                                    ? Constance.primaryColor
                                    : !check(selGeo, data.geoTopicks[i])
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
                              data.geoTopicks[i].title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
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
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
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
                      for (int i = 0; i < data.topicks.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!check(selTop, data.topicks[i])) {
                                print('add ${data.topicks[i].title}');
                                selTop.add(data.topicks[i]);
                              } else {
                                // print(
                                //     'rmv ${}');
                                // selTop.remove(data.topicks[i]);
                                selTop.removeWhere((element) =>
                                    element.id == data.topicks[i].id);
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
                                  : !check(selTop, data.topicks[i])
                                      ? Colors.white
                                      : Constance.secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: selTop == null
                                    ? Constance.primaryColor
                                    : !check(selTop, data.topicks[i])
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
                              data.topicks[i].title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
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
                // Text(
                //   'Notification Permission',
                //   style: Theme.of(context).textTheme.headline4?.copyWith(
                //         color: Constance.primaryColor,
                //         // fontSize: 2.h,
                //         fontWeight: FontWeight.bold,
                //       ),
                // ),
                // SizedBox(
                //   height: 0.5.h,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Big Deal',
                //       style: Theme.of(context).textTheme.headline5?.copyWith(
                //             color: Colors.black,
                //             // fontSize: 2.h,
                //             // fontWeight: FontWeight.bold,
                //           ),
                //     ),
                //     Switch(
                //       activeColor: Constance.secondaryColor,
                //       onChanged: (bool value) {
                //         setState(() {
                //           big_deal = value;
                //         });
                //       },
                //       value: big_deal,
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 0.2.h,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Guwahati Connect',
                //       style: Theme.of(context).textTheme.headline5?.copyWith(
                //             color: Colors.black,
                //             // fontSize: 2.h,
                //             // fontWeight: FontWeight.bold,
                //           ),
                //     ),
                //     Switch(
                //       activeColor: Constance.secondaryColor,
                //       onChanged: (bool value) {
                //         setState(() {
                //           guwahati_connect = value;
                //         });
                //       },
                //       value: guwahati_connect,
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 0.2.h,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Classified',
                //       style: Theme.of(context).textTheme.headline5?.copyWith(
                //             color: Colors.black,
                //             // fontSize: 2.h,
                //             // fontWeight: FontWeight.bold,
                //           ),
                //     ),
                //     Switch(
                //       activeColor: Constance.secondaryColor,
                //       onChanged: (bool value) {
                //         setState(() {
                //           classified = value;
                //         });
                //       },
                //       value: classified,
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 0.2.h,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Dark Mode',
                //       style: Theme.of(context).textTheme.headline4?.copyWith(
                //             color: Constance.primaryColor,
                //             // fontSize: 2.h,
                //             fontWeight: FontWeight.bold,
                //           ),
                //     ),
                //     Switch(
                //       activeColor: Constance.secondaryColor,
                //       onChanged: (bool value) {
                //         setState(() {
                //           dark_mode = value;
                //         });
                //       },
                //       value: dark_mode,
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 5.h,
                  child: CustomButton(
                    txt: 'Save & Continue',
                    onTap: () {
                      saveDetails();

                      // Navigation.instance.navigateAndReplace('/enterPreferences');
                    },
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void fetchProfile() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getprofile();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(response.profile!);
      // Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext ?? context,
      //         listen: false)
      //     .setMyTopicks(response.topicks);
      // Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext ?? context,
      //         listen: false)
      //     .setMyGeoTopicks(response.geoTopicks);
      initalizeTheList();
      Navigation.instance.goBack();
      setData(response.profile!);
      selGeo = response.geoTopicks;
      selTop = response.topicks;
    } else {
      Navigation.instance.goBack();
    }
  }



  void setData(Profile prof) {
    if (prof.f_name != '') {
      first_name.text = prof.f_name ?? "";
    }
    if (prof.l_name != '') {
      last_name.text = prof.l_name ?? "";
    }
    if (prof.email != '') {
      email.text = prof.email ?? "";
    }
    big_deal = prof.has_deal_notify_perm ?? false;
    guwahati_connect = prof.has_ghy_connect_notify_perm ?? false;
    classified = prof.has_classified_notify_perm ?? false;
    try {
      address = prof.addresses[0].address ?? "";
    } catch (e) {
      print(e);
    }
    try {
      id = prof.addresses
          .firstWhere((element) => element.is_primary == 1)
          .toString();
    } catch (e) {
      print(e);
    }
  }

  void saveDetails() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.createProfile(
        id.toString(),
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.mobile,
        first_name.text,
        last_name.text,
        email.text,
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.dob,
        address,
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .addresses!
            // .firstWhere((element) => element.id.toString().trim() == id)
            .firstWhere((element) => element.is_primary == 1)
            .longitude,
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .addresses!
            .firstWhere((element) => element.is_primary == 1)
            .latitude,
        getComaSeparated(selTop),
        getComaSeparated(selGeo),
        big_deal,
        guwahati_connect,
        classified,
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.gender,
        '',
        0);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: "Profile Updated");
      fetchProfile();
    } else {
      Navigation.instance.goBack();
      showError(response.msg ?? "Something went wrong");
    }
  }

  String getComaSeparated(List<dynamic> list) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (i == 0) {
        temp = '${list[i].id.toString()},';
      } else {
        temp += '${list[i].id.toString()},';
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
  }

  void fetchAddress() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getAddress();
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAddressess(response.addresses);
      if (mounted) {
        setState(() {
          id = response.addresses
              .firstWhere((element) => element.is_primary == 1)
              .id
              .toString();
        });
      } else {
        id = response.addresses
            .firstWhere((element) => element.is_primary == 1)
            .id
            .toString();
      }
      print(id);
    } else {
      Navigation.instance.goBack();
    }
  }

  void fetchTopicks() async {
    // showLoaderDialog(context);
    final response = await ApiProvider.instance.getTopicks();
    if (response.success ?? false) {
      setState(() {
        selTop = Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .mytopicks;
      });
      // Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setTopicks(response.topicks);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGeoTopicks(response.geoTopicks);

      // for (var i in response.geoTopicks) {
      //   print(i.id);
      //   for (var j in Provider.of<DataProvider>(
      //           Navigation.instance.navigatorKey.currentContext ?? context,
      //           listen: false)
      //       .mygeoTopicks) {
      //     if (i.id == j.id) {
      //       selGeo.add(j);
      //     }
      //   }
      // }
      // for (var i in Provider.of<DataProvider>(
      //         Navigation.instance.navigatorKey.currentContext ?? context,
      //         listen: false)
      //     .mytopicks) {
      //   for (var j in response.topicks) {
      //     if (i.id == j.id) {
      //       selTop.add(j);
      //     }
      //   }
      // }
    } else {
      // Navigation.instance.goBack();
      showError("Something went wrong");
    }
  }

  bool check(List<dynamic> list1, dynamic list2) {
    for (var i in list1) {
      if (i.id == list2.id) {
        return true;
      }
    }
    return false;
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

  void initalizeTheList() {
    setState(() {
      selTop = Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .mytopicks;
      selGeo = Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .mygeoTopicks;
      print(Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .mytopicks
          .length);
      print(Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .mygeoTopicks
          .length);
    });
  }
}
