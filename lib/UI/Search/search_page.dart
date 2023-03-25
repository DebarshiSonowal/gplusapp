import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';
import 'Section/search_result.dart';

class SearchPage extends StatefulWidget {
  final String? query;

  const SearchPage({super.key, this.query});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchQueryController = TextEditingController();
  int selected = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if ((widget.query?.isNotEmpty ?? false) && widget.query != "") {
        _searchQueryController.text = widget.query ?? "";
        search(_searchQueryController.text, selected);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar("search", true, _scaffoldKey),
      drawer: const BergerMenuMemPage(
        screen: "profile",
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    5.0,
                  ), //                 <--- border radius here
                ),
                border: Border.all(
                    width: 1, //                   <--- border width here
                    color: Storage.instance.isDarkMode
                        ? Colors.white70
                        : Colors.black26),
              ),
              // color: Colors.black,
              // height: 5.h,
              child: Center(
                child: TextField(
                  toolbarOptions: const ToolbarOptions(
                      copy: false, paste: false, cut: false, selectAll: false
                      //by default all are disabled 'false'
                      ),
                  controller: _searchQueryController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black26),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_searchQueryController.text.isNotEmpty) {
                          search(_searchQueryController.text, selected);
                        } else {
                          showError('Enter something to search');
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                  cursorColor: Storage.instance.isDarkMode
                      ? Colors.white
                      : Constance.primaryColor,
                  onChanged: (query) => {},
                ),
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            SizedBox(
              height: 1.h,
              child: Divider(
                color:
                    Storage.instance.isDarkMode ? Colors.white : Colors.black,
                thickness: 0.4.sp,
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 0;
                      });
                      logTheSearchCategoryClick(
                          Provider.of<DataProvider>(
                                  Navigation.instance.navigatorKey
                                          .currentContext ??
                                      context,
                                  listen: false)
                              .profile!,
                          "news");
                      search(_searchQueryController.text, selected);
                    },
                    child: Container(
                      height: 5.h,
                      color: selected == 0
                          ? Constance.secondaryColor
                          : Colors.black,
                      child: Center(
                        child: Text(
                          'News',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: selected == 0
                                        ? Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Colors.black
                                        : Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 1;
                      });
                      logTheSearchCategoryClick(
                          Provider.of<DataProvider>(
                                  Navigation.instance.navigatorKey
                                          .currentContext ??
                                      context,
                                  listen: false)
                              .profile!,
                          "others");
                      search(_searchQueryController.text, selected);
                    },
                    child: Container(
                      height: 5.h,
                      color: selected == 1
                          ? Constance.secondaryColor
                          : Colors.black,
                      child: Center(
                        child: Text(
                          'Others',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: selected == 1
                                        ? Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Colors.black
                                        : Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1.5.h,
            ),
            SizedBox(
              height: 1.h,
              child: Divider(
                color:
                    Storage.instance.isDarkMode ? Colors.white : Colors.black,
                thickness: 0.4.sp,
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            SearchResultWidget(
              selected: selected,
            ),
          ],
        ),
      ),
    );
  }

  void search(query, type) async {
    Navigation.instance.navigate('/loadingDialog');
    if (type == 0) {
      final response = await ApiProvider.instance.search(query, type);
      if (response.success ?? false) {
        logTheSearchCompletionClick(
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile!,
            query);
        if (response.data?.isNotEmpty ?? false) {
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .setSearchResult(response.data ?? []);
        } else {
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .setSearchResult([]);
        }

        Navigation.instance.goBack();
        try {
          setState(() {});
        } catch (e) {
          print(e);
        }
      } else {
        logTheSearchCompletionClick(
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile!,
            query);
        Navigation.instance.goBack();
      }
    } else {
      final response = await ApiProvider.instance.Otherssearch(query, type);
      if (response.success ?? false) {
        logTheSearchCompletionClick(
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile!,
            query);
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setOtherSearchlist(response.data ?? []);
        Navigation.instance.goBack();
        try {
          setState(() {});
        } catch (e) {
          print(e);
        }
      } else {
        logTheSearchCompletionClick(
            Provider.of<DataProvider>(
                    Navigation.instance.navigatorKey.currentContext ?? context,
                    listen: false)
                .profile!,
            query);
        Navigation.instance.goBack();
      }
    }
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

  void logTheSearchCompletionClick(Profile profile, String search_term) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "search_completion_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "search_term": search_term,
        "screen_name": "search",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  void logTheSearchCategoryClick(Profile profile, String cta_click) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "search_category_click",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "cta_click": cta_click,
        "screen_name": "search",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
