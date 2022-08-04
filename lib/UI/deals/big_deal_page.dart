import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Navigation/Navigate.dart';

import '../../Helper/Constance.dart';
import 'package:sizer/sizer.dart';

class BigDealPage extends StatefulWidget {
  const BigDealPage({Key? key}) : super(key: key);

  @override
  State<BigDealPage> createState() => _BigDealPageState();
}

class _BigDealPageState extends State<BigDealPage> {
  String _value = 'Time';

  var current = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(7.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Constance.secondaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      FontAwesomeIcons.spoon,
                      color: Constance.primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    'Food',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Constance.primaryColor,
                          fontSize: 3.h,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              color: Constance.primaryColor,
              height: 5.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showSortByOption();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.sort,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          'Sort by',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                    child: Center(
                      child: Container(
                        height: double.infinity,
                        width: 0.5.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigation.instance.navigate('/filterPage');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.filter,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          'Filter by',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.white,
                                    fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: Constance.discounts.length,
                  itemBuilder: (cont, cout) {
                    var data = Constance.discounts[cout];
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(
                            data.icon,
                            size: 6.h,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              data.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.grey.shade800,
                                    fontSize:
                                        1.5.h, // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        trailing: CustomButton(
                          txt: "View",
                          onTap: () {
                            Navigation.instance.navigate('/main');
                          },
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.fixed,
        currentIndex: current,
        onTap: (val) {
          setState(() {
            current = val;
          });
          switch (val) {
            case 0:
              Navigation.instance.navigate('/main');
              break;
            case 1:
              Navigation.instance.navigate('/bigdealpage');
              break;
            default:
              // Navigation.instance.navigate('/main');
              break;
          }
        },

        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(
            fontSize: 1.5.h,
            color: Constance.secondaryColor,
            overflow: TextOverflow.clip),
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(
            fontSize: 1.2.h, color: Colors.white, overflow: TextOverflow.clip),
        backgroundColor: Constance.primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: current == 0 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Home",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_offer,
              color: current == 1 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Big Deal",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.radio,
              color: current == 2 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Guwahati\nConnect",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mic,
              color: current == 3 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Citizen\nJournalist",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.newspaper,
              color: current == 4 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Classified",
            backgroundColor: Constance.primaryColor,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill, height: 10.h, width: 20.w),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }

  void showSortByOption() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0)),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: 3.h, right: 10.w, left: 10.w, bottom: 3.h),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: const Radius.circular(15.0))),
                child: Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sort by',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Constance.primaryColor,
                            fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        Radio(
                          groupValue: _value,
                          value: 'Time',
                          fillColor: MaterialStateProperty.all(
                            Constance.primaryColor,
                          ),
                          onChanged: (String? value) {
                            _(() {
                              setState(() {
                                _value = value ?? "";
                              });
                            });

                            print(_value);
                          },
                          activeColor: Constance.primaryColor,
                        ),
                        Text(
                          'Time',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          focusColor: Constance.primaryColor,
                          // overlayColor: MaterialStateProperty,
                          groupValue: _value,
                          value: 'Alphabetical',
                          fillColor: MaterialStateProperty.all(
                            Constance.primaryColor,
                          ),
                          onChanged: (String? value) {
                            _(() {
                              setState(() {
                                _value = value ?? "";
                              });
                            });
                          },
                          activeColor: Constance.primaryColor,
                        ),
                        Text(
                          'Alphabetical',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
