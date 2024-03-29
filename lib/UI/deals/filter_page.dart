import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Model/locality.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final Map<int, bool> _map = {};
  int _count = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      fetchLocality();
      var selected = (await Storage.instance.filters).toString().split(',');
      for (var i in selected) {
        setState(() {
          Map<int, bool> data = {
            int.parse(i): true,
          };
          _map.addAll(data);
        });
      }
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("bigdeal"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Constance.secondaryColor,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter By',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 3.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Locality',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Text(
                                '${_map.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontSize: 2.h,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<DataProvider>(builder: (context, data, _) {
                  return Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: data.locality.length,
                          itemBuilder: (conte, cout) {
                            var current = data.locality[cout];
                            return Theme(
                              data:
                                  ThemeData(unselectedWidgetColor: Colors.grey),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                checkColor: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                activeColor: Storage.instance.isDarkMode
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                // tileColor: Colors.grey,
                                value: _map[current.id] ?? false,
                                onChanged: (value) => setState(() {
                                  _map[current.id!] = value!;
                                }),
                                title: Text(
                                  current.name ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                          color: Storage.instance.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                }),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 2.h,
              ),
              width: 80.w,
              height: 5.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _map.isNotEmpty &&
                            _map.values
                                .toList()
                                .where((element) => element == true)
                                .isNotEmpty
                        ? CustomButton(
                            color: Colors.white,
                            txt: 'Clear',
                            onTap: () {
                              Storage.instance.setFilter("");
                              setState(() {
                                _map.clear();
                              });
                            },
                          )
                        : Container(),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: CustomButton(
                      txt: 'Done',
                      onTap: () {
                        Storage.instance.setFilter(getComaSeparated(
                          _map.keys.toList(),
                          _map.values.toList(),
                        ));
                        logTheFilterAppliedClick(
                            Provider.of<DataProvider>(
                                    Navigation.instance.navigatorKey
                                            .currentContext ??
                                        context,
                                    listen: false)
                                .profile!,
                            _map.isNotEmpty
                                ? getComaSeparatedName(
                                    _map.keys.toList(),
                                    _map.values.toList(),
                                    Provider.of<DataProvider>(context,
                                            listen: false)
                                        .locality)
                                : "clear");
                        Navigator.pop(
                            context,
                            _map.isNotEmpty
                                ? getComaSeparated(
                                    _map.keys.toList(),
                                    _map.values.toList(),
                                  )
                                : "");
                        //  _map.keys.toList()_map.keys.toList()
                        // print(
                        //
                        // );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getComaSeparated(List<dynamic> list, List<dynamic> list2) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (list2[i] == true) {
        if (i == 0) {
          temp = '${list[i]},';
        } else {
          temp += '${list[i]},';
        }
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
  }

  String getComaSeparatedName(
      List<dynamic> list, List<dynamic> list2, List<Locality> list3) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (list2[i] == true) {
        if (i == 0) {
          temp =
              '${list3.firstWhere((element) => element.id == list[i]).name},';
        } else {
          temp +=
              '${list3.firstWhere((element) => element.id == list[i]).name},';
        }
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
  }

  fetchLocality() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getClassifiedCategory();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      debugPrint(response.categories.toString());
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassifiedCategory(response.categories ?? []);

      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLocality(response.localities ?? []);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  void logTheFilterAppliedClick(Profile profile, String filter_applied) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "filter_applied",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "filter_applied": filter_applied.length > 100
            ? filter_applied.substring(0, 100)
            : filter_applied,
        // "cta_click": cta_click,
        "screen_name": "filtered",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
