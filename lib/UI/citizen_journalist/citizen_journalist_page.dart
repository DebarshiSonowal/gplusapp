import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class CitizenJournalistPage extends StatefulWidget {
  const CitizenJournalistPage({Key? key}) : super(key: key);

  @override
  State<CitizenJournalistPage> createState() => _CitizenJournalistPageState();
}

class _CitizenJournalistPageState extends State<CitizenJournalistPage> {
  int current = 1;
  String txt =
      'Worried about the security in your area, a garbage dump in your locality,'
      ' increasing traffic on the roads, potholes, lack of access to water, and several'
      ' other issues which fails to reflect in mainstream media? Do you want the authorities'
      ' to take notice but you\’re not being heard?'
      ' We want to change that. We are passing the baton to you, the citizen. Be active and'
      ' vigilant through G Plus ‘Citizen Journalist’ programme – an empowering platform for '
      'citizens to raise their voice.';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchText());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      appBar: buildAppBar(),
      drawer: BergerMenuMemPage(),
      bottomNavigationBar: CustomNavigationBar(current),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Be a Journalist',
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: Constance.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Image.asset(
                Constance.citizenIcon,
                height: 12.h,
                width: 28.w,
                fit: BoxFit.fill,
                color: Constance.secondaryColor,
                // size: 15.h,
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Hello ${Provider.of<DataProvider>(context).profile?.name ?? ""}',
                style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 1.h),
              Consumer<DataProvider>(builder: (context, data, _) {
                return Text(
                  data.citizenJournalist,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white70
                            : Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                );
              }),
              // Spacer(),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                height: 5.h,
                width: double.infinity,
                child: CustomButton(
                    txt: 'Submit a Story',
                    onTap: () {
                      if (Provider.of<DataProvider>(
                                  Navigation.instance.navigatorKey
                                          .currentContext ??
                                      context,
                                  listen: false)
                              .profile
                              ?.is_plan_active ??
                          false) {
                        // Navigation.instance.navigate('/exclusivePage');
                        Navigation.instance.navigate('/submitStory');
                      } else {
                        Constance.showMembershipPrompt(context, () {});
                      }
                    }),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: 5.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Constance.primaryColor),
                  ),
                  onPressed: () {
                    Navigation.instance.navigate('/draftStory');
                  },
                  child: Text(
                    'Drafts',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontSize: 14.5.sp,
                        ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: 5.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Navigation.instance.goBack();
                    Navigation.instance.navigate('/submitedStory');
                  },
                  child: Text(
                    'Stories submitted',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                          fontSize: 14.5.sp,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
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

  fetchText() async {
    if (Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .citizenJournalist ==
        "") {
      Navigation.instance.navigate('/loadingDialog');
      final response = await ApiProvider.instance.getCitizenText();
      if (response.success ?? false) {
        // setState(() {
        //   txt = response.desc!;
        // });
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setCitizenJournalistText(response.desc!);
        Navigation.instance.goBack();
      } else {
        Navigation.instance.goBack();
      }
    }
  }
}
