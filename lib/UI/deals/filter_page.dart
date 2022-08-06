import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final Map<String, bool> _map = {};
  int _count = 0;

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
                          style: Theme.of(context).textTheme.headline5?.copyWith(
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
                            style: Theme.of(context).textTheme.headline5?.copyWith(
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
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    itemCount: Constance.locationList.length,
                    itemBuilder: (conte, cout) {
                      var data = Constance.locationList[cout];
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.grey),
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: Colors.black,
                          activeColor: Colors.grey.shade300,
                          // tileColor: Colors.grey,
                          value: _map[data] ?? false,
                          onChanged: (value) =>
                              setState(() => _map[data] = value!),
                          title: Text(
                            data,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                      );
                    }),
              ),
            ),
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
}
