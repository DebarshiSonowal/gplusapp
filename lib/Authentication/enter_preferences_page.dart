import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/topick.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Components/alert.dart';
import '../Components/custom_button.dart';
import '../Components/preferences_item.dart';
import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';

class EnterPreferencesPage extends StatefulWidget {
  const EnterPreferencesPage({Key? key}) : super(key: key);

  @override
  State<EnterPreferencesPage> createState() => _EnterPreferencesPageState();
}

class _EnterPreferencesPageState extends State<EnterPreferencesPage> {
  List<GeoTopick> selGeo = [];
  List<Topick> selTop = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchTopicks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar("preferences",false,_scaffoldKey),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(7.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tell us your preferences',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.5.h,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'Geographical',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 3.h,
              ),
              SizedBox(
                // height: 16.h,
                width: double.infinity,
                child: Wrap(
                  children: [
                    for (int i = 0; i < data.geoTopicks.length; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!selGeo.contains(data.geoTopicks[i])) {
                              selGeo.add(data.geoTopicks[i]);
                            } else {
                              selGeo.remove(data.geoTopicks[i]);
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: selGeo == []
                                ? Colors.white
                                : !selGeo.contains(data.geoTopicks[i])
                                    ? Colors.white
                                    : Constance.secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: selGeo == []
                                  ? Colors.grey.shade600
                                  : !selGeo.contains(data.geoTopicks[i])
                                      ? Colors.grey.shade600
                                      : Constance.secondaryColor,
                              width: 0.5.w,
                              // left: BorderSide(
                              //   color: Colors.green,
                              //   width: 1,
                              // ),
                            ),
                          ),
                          child: Text(
                            data.geoTopicks[i].title ?? "",
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Colors.grey.shade800,
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
                height: 3.h,
              ),
              Text(
                'Topical',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                // height: 15.h,
                width: double.infinity,
                child: Wrap(
                  children: [
                    for (int i = 0; i < data.topicks.length; i++)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          debugPrint(data.topicks[i].title);
                          debugPrint(selTop.toList().toString());
                          setState(() {
                            if (!selTop.contains(data.topicks[i])) {
                              selTop.add(data.topicks[i]);
                            } else {
                              selTop.remove(data.topicks[i]);
                            }
                          });
                        },
                        child: preferencesItem(selTop: selTop, i: i,data: data),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: CustomButton(
                  txt: 'Save & Continue',
                  onTap: () {
                    if (selGeo.isNotEmpty && selTop.isNotEmpty) {
                      signUp();
                      // debugPrint("SELGEO");
                      // for(var i in selGeo) {
                      //   debugPrint("${i.title} ${i.id}");
                      // }
                      // debugPrint("SELTOP");
                      // for(var i in selTop) {
                      //   debugPrint("${i.title} ${i.id}");
                      // }
                    } else {
                      showError("Select at least one of each");
                    }
                  },
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          );
        }),
      ),
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



  void signUp() async {
    final reponse = await ApiProvider.instance.createProfile(
        '0',
        Storage.instance.signUpdata?.mobile,
        Storage.instance.signUpdata?.f_name,
        Storage.instance.signUpdata?.l_name,
        Storage.instance.signUpdata?.email,
        Storage.instance.signUpdata?.dob,
        Storage.instance.signUpdata?.address,
        Storage.instance.signUpdata?.longitude,
        Storage.instance.signUpdata?.latitude,
        getComaSeparated(selTop),
        getComaSeparated(selGeo),
        0,
        0,
        0,
        Storage.instance.signUpdata?.gender,
        Storage.instance.signUpdata?.refer,
        1);
    if (reponse.success ?? false) {
      // setPreferences();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(reponse.profile!);
      Navigation.instance.navigateAndReplace('/main');
    } else {
      // showError(reponse.msg ?? "Something went wrong");
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

  void getProfile() async {
    final reponse = await ApiProvider.instance
        .login(Storage.instance.signUpdata?.mobile.toString());
    if (reponse.status ?? false) {
      Storage.instance.setUser(reponse.access_token ?? "");
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(reponse.profile!);
      // Navigation.instance.goBack();
      Navigation.instance.navigateAndReplace('/main');
    } else {
      // Navigation.instance.navigateAndReplace('/terms&conditions');
      showError("Something went wrong");
    }
  }

  void fetchTopicks() async {
    showLoaderDialog(context);
    final response = await ApiProvider.instance.getTopicks();
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setTopicks(response.topicks);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGeoTopicks(response.geoTopicks);
    } else {
      Navigation.instance.goBack();
      showError("Something went wrong");
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        color: Colors.white,
        child: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(
                "Loading...",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void setPreferences() async {
    final response = await ApiProvider.instance.enterPreferences(
        Storage.instance.signUpdata?.mobile,
        getComaSeparated(selTop),
        getComaSeparated(selGeo));
    if (response.success ?? false) {
      getProfile();
    } else {
      showError("Something went wrong");
    }
  }
}


