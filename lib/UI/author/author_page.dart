import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/author_related_opinion.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/alert.dart';
import '../../Components/author_related_news.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class AuthorPage extends StatefulWidget {
  final int id;

  AuthorPage(this.id);

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      // appBar: Constance.buildAppBar("author",true,_scaffoldKey),
      appBar: Constance.buildAppBar2("author"),
      // drawer: const BergerMenuMemPage(screen: "author"),
      body: Consumer<DataProvider>(builder: (context, data, _) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
            // horizontal: 5.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  height: 15.h,
                  width: double.infinity,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          // padding: EdgeInsets.all(2.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constance.primaryColor,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                data.author?.image_file_name ??
                                    "",
                                scale: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          SizedBox(
                            width: 50.w,
                            child: Text(
                              data.author?.name ?? '',
                              style:(data.author?.name ?? '').length>60? Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.primaryColor,
                                    // fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ):Theme.of(Navigation
                                  .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                color: Storage.instance.isDarkMode
                                    ? Colors.white
                                    : Constance.primaryColor,
                                // fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Follow on',
                            style: Theme.of(Navigation
                                    .instance.navigatorKey.currentContext!)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  // fontSize: 11.sp,
                                  // fontWeight: FontWeight.bold,
                                ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _launchUrl(data.author?.fb_link ??
                                      Uri.parse(
                                          "https://www.facebook.com/guwahatiplus/"));
                                },
                                child: Icon(
                                  FontAwesomeIcons.facebookSquare,
                                  color: Storage.instance.isDarkMode
                                      ? Constance.secondaryColor
                                      : Constance.primaryColor,
                                  size: 30,
                                ),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchUrl(Uri.parse(data
                                          .author?.insta_link ??
                                      "https://www.instagram.com/guwahatiplus/"));
                                },
                                child: Icon(
                                  FontAwesomeIcons.instagramSquare,
                                  color: Storage.instance.isDarkMode
                                      ? Constance.secondaryColor
                                      : Constance.primaryColor,
                                  size: 30,
                                ),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchUrl(Uri.parse(
                                      data.author?.insta_link ??
                                          "https://twitter.com/guwahatiplus"));
                                },
                                child: Icon(
                                  FontAwesomeIcons.twitterSquare,
                                  color: Storage.instance.isDarkMode
                                      ? Constance.secondaryColor
                                      : Constance.primaryColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                ),
                (data.author?.description?.isNotEmpty ?? false)
                    ? SizedBox(
                        width: double.infinity,
                        height: 20.h,
                        child: Html(
                          data: data.author?.description ?? "",
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 1.h,
                ),
                AuthorRelatedNews(
                  data,
                  news: data.author?.news ?? [],
                  updateState: () {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 1.h,
                ),
                AuthorRelatedOpinions(
                  opinions: data.author?.opinions ?? [],
                  data: data,
                  updateState: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  fetchAuthorDetails(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getAuthor(id);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setAuthor(response.profile!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError(response.msg ?? "Something went wrong");
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



  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(Uri.parse(_url), mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchAuthorDetails(widget.id));
  }
}
