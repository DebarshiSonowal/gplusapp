import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar2("about"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Constance.secondaryColor,
                      size: 3.5.h,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      'About Us',
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                SizedBox(
                  height: 1.h,
                  child: Divider(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    thickness: 0.4.sp,
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                // Center(
                //   child: Text(
                //     Constance.about,
                //     style: Theme.of(context).textTheme.headline6?.copyWith(
                //           color: Colors.black45,
                //           // fontWeight: FontWeight.bold,
                //         ),
                //   ),
                // ),
                SizedBox(
                  height: 1.5.h,
                ),
                Html(
                  data: data.aboutUs?.content?.trim() ?? "",

                  // tagsList: Html.tags..addAll(["bird", "flutter"]),
                  shrinkWrap: true,

                  extensions: [

                  ],
                  // customRender: {
                  //   "a": (context, child) {
                  //     return GestureDetector(
                  //       onTap: () {
                  //         debugPrint("${context.tree.attributes}");
                  //         _launchUrl(Uri.parse(context.tree.attributes['href']??"https://guwahatiplus.com/"));
                  //       },
                  //       child: Text(
                  //         context.tree.element?.innerHtml
                  //             .split("=")[0]
                  //             .toString() ??
                  //             "",
                  //         style: Theme.of(Navigation.instance
                  //             .navigatorKey.currentContext!)
                  //             .textTheme
                  //             .headline5
                  //             ?.copyWith(
                  //           color: Constance.primaryColor,
                  //           fontWeight: FontWeight.bold,
                  //           decoration:
                  //           TextDecoration.underline,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // },
                  style: {
                    '#': Style(
                      // fontSize: FontSize(_counterValue),
                      // maxLines: 20,
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      // textOverflow: TextOverflow.ellipsis,
                    ),
                  },
                ),
              ],
            ),
          );
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
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return bd.Badge(
              // badgeColor: Constance.secondaryColor,
              badgeContent: Text(
                '${data.notifications.length}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Constance.thirdColor,
                    ),
              ),
              child: const Icon(Icons.notifications),
            );
          }),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search', args: "");
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchAboutUs();
    });
  }

  void fetchAboutUs() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getAboutUs();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAboutUs(response.aboutUs!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }
  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url,mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }
}
