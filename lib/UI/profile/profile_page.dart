import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import 'package:sizer/sizer.dart';

import '../../Networking/api_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode?Colors.black:Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return data.memberships.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Account',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Storage.instance.isDarkMode?Colors.white:Constance.secondaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    data.profile?.is_plan_active ?? false
                        ? ListView.builder(
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
                                            'Rs ${current.base_price ?? '999'}/',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            current.duration?.split(' ')[1] ??
                                                "month",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.5.h,
                                      ),
                                      Text(
                                        'expires on ${Jiffy(current.plan_expiry_date ?? "", "yyyy-MM-dd").format("dd/MM/yyyy")}',
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
                                        '${Jiffy(current.plan_expiry_date ?? "", "yyyy-MM-dd").fromNow().substring(2)} left',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            ?.copyWith(
                                              color: Colors.white,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: CustomButton(
                                          txt: 'Buy next membership term',
                                          onTap: () {
                                            Navigation.instance
                                                .navigate('/beamember');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Container(
                      height: 40.h,
                      child: Center(
                        child: Text(
                          'Oops! Looks like you are not a member',
                          style: Theme.of(context).textTheme.headline3?.copyWith(
                              color: Constance.primaryColor,
                              // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container();
        }),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () {
      //     Navigation.instance.navigate('/bergerMenuMem');
      //   },
      //   icon: Icon(Icons.menu),
      // ),
      title: GestureDetector(
        onTap: (){
          Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
              .setCurrent(0);
          Navigation.instance.navigate('/main');
        },
        child: Image.asset(
          Constance.logoIcon,
          fit: BoxFit.fill,
          scale: 2,
        ),
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search');
          },
          icon: Icon(Icons.search),
        ),
      ],
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
}
