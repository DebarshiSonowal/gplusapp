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
      return BottomNavigationBar(
        enableFeedback: true,
        // type: BottomNavigationBarType.fixed,
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
        selectedLabelStyle: TextStyle(
            fontSize: 8.sp,
            color: Constance.secondaryColor,
            overflow: TextOverflow.clip),
        // showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(
            fontSize: 8.sp, color: Colors.white),
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
            label: "Guwahati Connect",
            backgroundColor: Constance.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mic,
              color: current == 3 ? Constance.secondaryColor : Colors.white,
            ),
            label: "Citizen Journalist",
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
      );
    });
  }
}
