import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class CustomNavigationBar extends StatefulWidget {
  int current;

  CustomNavigationBar(this.current);

  @override
  State<CustomNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      var current = data.currentIndex;
      return Theme(
        data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
                  headline5: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: 'Archivo',
                  ),
                )),
        child: BottomNavigationBar(
          // enableFeedback: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: current,
          onTap: (val) {
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .setCurrent(val);
            switch (val) {
              case 1:
                Navigation.instance.navigate('/bigdealpage');
                break;
              case 2:
                Navigation.instance.navigate('/guwahatiConnects');
                break;
              case 3:
                Navigation.instance.navigate('/citizenJournalist');
                break;
              case 4:
                Navigation.instance.navigate('/classified');
                break;
              default:
                Navigation.instance.navigate('/main');
                break;
            }
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Constance.secondaryColor,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(
            fontSize: 7.sp,
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            overflow: TextOverflow.clip,
          ),
          // showUnselectedLabels: true,
          unselectedLabelStyle: TextStyle(
              fontSize: 7.sp, color: Colors.black, overflow: TextOverflow.clip),
          backgroundColor: Constance.primaryColor,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                Constance.homeIcon,
                height: 5.h,
                width: 6.w,
                color: current == 0 ? Constance.secondaryColor : Colors.white,
              ),
              label: " Home\n ",
              backgroundColor: Constance.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Constance.bigDealIcon,
                height: 5.h,
                width: 6.w,
                color: current == 1 ? Constance.secondaryColor : Colors.white,
              ),
              label: " Big Deal\n ",
              backgroundColor: Constance.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Constance.connectIcon,
                height: 5.h,
                width: 6.w,
                color: current == 2 ? Constance.secondaryColor : Colors.white,
              ),
              label: " Guwahati\n  Connect",
              backgroundColor: Constance.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Constance.citizenIcon,
                height: 5.h,
                width: 6.w,
                color: current == 3 ? Constance.secondaryColor : Colors.white,
              ),
              label: "   Citizen\nJournalist",
              backgroundColor: Constance.primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                Constance.classifiedIcon,
                height: 5.h,
                width: 6.w,
                color: current == 4 ? Constance.secondaryColor : Colors.white,
              ),
              label: " Classified\n ",
              backgroundColor: Constance.primaryColor,
            ),
          ],
        ),
      );
    });
  }
}
