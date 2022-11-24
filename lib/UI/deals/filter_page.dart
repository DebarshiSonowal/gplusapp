import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
            _map.isNotEmpty &&
                    _map.values
                        .toList()
                        .where((element) => element == true)
                        .isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    width: 80.w,
                    height: 5.h,
                    child: CustomButton(
                      txt: 'Done',
                      onTap: () {
                        Storage.instance.setFilter(getComaSeparated(
                          _map.keys.toList(),
                          _map.values.toList(),
                        ));
                        Navigator.pop(
                            context,
                            getComaSeparated(
                              _map.keys.toList(),
                              _map.values.toList(),
                            ));
                        //  _map.keys.toList()_map.keys.toList()
                        // print(
                        //
                        // );
                      },
                    ),
                  )
                : Container(),
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

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Back',
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white),
      ),
      centerTitle: false,
      backgroundColor: Constance.primaryColor,
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {
              _map.clear();
              Storage.instance.setFilter('');
            });
            Navigator.pop(context, '');
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Center(
              child: Text(
                'Clear Filters',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  fetchLocality() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getClassifiedCategory();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      print(response.categories);
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
}
