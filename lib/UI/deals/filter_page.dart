import 'package:flutter/material.dart';
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
  final Map<String, bool> _map = {};
  int _count = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchLocality());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
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
                      style: Theme.of(context).textTheme.headline5?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black,
                                    fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Text(
                            '2',
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
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
                          data: ThemeData(unselectedWidgetColor: Colors.grey),
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            checkColor: Colors.black,
                            activeColor: Colors.grey.shade300,
                            // tileColor: Colors.grey,
                            value: _map[current.name ?? ""] ?? false,
                            onChanged: (value) => setState(
                                () => _map[current.name ?? ""] = value!),
                            title: Text(
                              current.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.black),
                            ),
                          ),
                        );
                      }),
                ),
              );
            }),
          ],
        ),
      ),
    );
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
        Padding(
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
