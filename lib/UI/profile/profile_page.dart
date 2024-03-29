import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Model/membership.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';
import '../Menu/berger_menu_member_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar2("profile"),
      drawer: const BergerMenuMemPage(
        screen: "profile",
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return data.memberships.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Account',
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ((data.profile?.is_plan_active ?? false) &&
                              data.memberships.isNotEmpty)
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.memberships.length,
                              itemBuilder: (cont, count) {
                                var current = data.memberships[count];
                                return Card(
                                  color: Constance.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.5.h, horizontal: 4.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          count == 0
                                              ? 'Present Plan'
                                              : 'Upcoming Plan',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Rs ${current.base_price ?? '999'}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            // Text(
                                            //   current.duration?.split(' ')[1] ??
                                            //       "month",
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .headline4
                                            //       ?.copyWith(
                                            //         color: Colors.white,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            // ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                        Text(
                                          'expires on ${getExpires(current)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          '${getLeft(current)} Days left',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4
                                              ?.copyWith(
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Text(
                                          '*Subscription is for recurring purchases.\nWe renew your subscription automatically.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic
                                                  // fontWeight: FontWeight.bold,
                                                  ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        // SizedBox(
                                        //   width: double.infinity,
                                        //   child: CustomButton(
                                        //     txt: 'Renew Subscription',
                                        //     onTap: () async {
                                        //       final result = await Navigation
                                        //           .instance
                                        //           .navigate('/beamember');
                                        //       if (result == null) {
                                        //         fetch();
                                        //       }
                                        //     },
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : SizedBox(
                              height: 40.h,
                              child: Center(
                                child: Text(
                                  'Oops! Looks like you are not a member',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                        color: Constance.primaryColor,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                )
              : Container();
        }),
      ),
    );
  }

  void fetch() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getActiveMembership();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMembership(response.membership ?? []);
      // _refreshController.refreshCompleted();
      Navigation.instance.goBack();
    } else {
      // Provider.of<DataProvider>(
      //     Navigation.instance.navigatorKey.currentContext ?? context,
      //     listen: false)
      //     .setMembership(response.membership ?? []);
      Navigation.instance.goBack();
      // _refreshController.refreshFailed();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetch());
  }

  getExpires(Membership current) {
    try {
      return Jiffy.parse(current.plan_expiry_date ?? "", pattern: "yyyy-MM-dd")
          .format(pattern: "dd/MM/yyyy");
    } catch (e) {
      print(e);
      return "";
    }
  }

  getLeft(Membership current) {
    return DateTime.parse(current.plan_expiry_date!).difference(DateTime.now()).inDays;

    // try {
    //   return Jiffy(current.plan_expiry_date ?? "", "yyyy-MM-dd")
    //       .format("dd/MM/yyyy");
    // } catch (e) {
    //   print(e);
    //   return "";
    // }
  }
}
