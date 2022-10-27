import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class StoryPage extends StatefulWidget {
  final String? slug;

  StoryPage(this.slug);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int random = 0;
  var categories = ['international', 'assam', 'guwahati', 'india'];
  var dropdownvalue = 'international';
  WebViewController? _controller;
  bool like = false, dislike = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchDetails();
      fetchContent();
    });
    fetchAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: data.selectedArticle == null
                ? Container()
                : Column(
                    children: [
                      Container(
                        height: 25.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.all(
                          //   // Radius.circular(10),
                          // ),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                              data.selectedArticle?.image_file_name ??
                                  'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            // Row(
                            //   children: [
                            //     Container(
                            //       color: Constance.primaryColor,
                            //       padding: EdgeInsets.symmetric(
                            //           horizontal: 2.w, vertical: 1.h),
                            //       child: Text(
                            //         'Guwahati',
                            //         style: Theme.of(Navigation.instance
                            //                 .navigatorKey.currentContext!)
                            //             .textTheme
                            //             .headline5
                            //             ?.copyWith(
                            //               color: Colors.white,
                            //               // fontSize: 2.2.h,
                            //               // fontWeight: FontWeight.bold,
                            //             ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              data.selectedArticle?.title ??
                                  'It is a long established fact that a reader will be distracted by the readable content of a',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Constance.primaryColor,
                                    // fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigation.instance.navigate('/authorPage',
                                    args: data.selectedArticle?.author);
                              },
                              child: Text(
                                '${data.selectedArticle?.author_name ?? "GPlus"}, ${Jiffy(data.selectedArticle?.publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}',
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontSize: 2.2.h,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),

                            SizedBox(
                              height: 1.5.h,
                            ),
                            Row(
                              children: [
                                Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                    onPressed: () {
                                      postLike(data.selectedArticle?.id, 0);
                                      setState(() {
                                        like = !like;
                                        if (dislike) {
                                          dislike = !like;
                                        }
                                      });
                                    },
                                    splashRadius: 20.0,
                                    splashColor: !like
                                        ? Constance.secondaryColor
                                        : Constance.primaryColor,
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: like
                                          ? Constance.secondaryColor
                                          : Constance.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                    onPressed: () {
                                      postLike(data.selectedArticle?.id, 1);
                                      setState(() {
                                        dislike = !dislike;
                                        if (like) {
                                          like = !dislike;
                                        }
                                      });
                                    },
                                    splashRadius: 20.0,
                                    splashColor: !dislike
                                        ? Constance.secondaryColor
                                        : Constance.primaryColor,
                                    icon: Icon(
                                      Icons.thumb_down,
                                      color: dislike
                                          ? Constance.secondaryColor
                                          : Constance.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),

                                SizedBox(
                                  width: 2.w,
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                    onPressed: () {
                                      Share.share(data
                                                  .selectedArticle?.web_url ==
                                              ""
                                          ? 'check out our website https://guwahatiplus.com/'
                                          : '${data.selectedArticle?.web_url}');
                                    },
                                    splashRadius: 20.0,
                                    splashColor: Constance.secondaryColor,
                                    icon: const Icon(
                                      Icons.share,
                                      color: Constance.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            // Text(
                            //   data.selectedArticle?.description
                            //           ?.split('</p>')[1]
                            //           .trim() ??
                            //       "",
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .headline5
                            //       ?.copyWith(
                            //         color: Colors.black45,
                            //         // fontWeight: FontWeight.bold,
                            //       ),
                            // ),
                            Html(
                              data: data.selectedArticle?.description?.trim() ??
                                  "",
                              shrinkWrap: true,
                              style: {
                                '#': Style(
                                  // fontSize: FontSize(_counterValue),
                                  // maxLines: 20,
                                  color: Colors.black,
                                  // textOverflow: TextOverflow.ellipsis,
                                ),
                              },
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  color: Constance.secondaryColor,
                                  padding: EdgeInsets.symmetric(vertical: 0.2.h,horizontal: 1.w),
                                  margin:
                                  EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Text(
                                    'Ad',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              // height: 10.h,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  _launchUrl(Uri.parse(
                                      data.ads[random].link.toString()));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        data.ads[random].image_file_name ?? '',
                                    placeholder: (cont, _) {
                                      return Image.asset(
                                        Constance.logoIcon,
                                        // color: Colors.black,
                                      );
                                    },
                                    errorWidget: (cont, _, e) {
                                      return Image.network(
                                        Constance.defaultImage,
                                        fit: BoxFit.fitWidth,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            // Text(
                            //   data.selectedArticle?.description
                            //           ?.split('</p>')[3]
                            //           .trim() ??
                            //       "",
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .headline5
                            //       ?.copyWith(
                            //         color: Colors.black45,
                            //         // fontWeight: FontWeight.bold,
                            //       ),
                            // ),
                            // SizedBox(
                            //   height: 20.h,
                            //   child: WebView(
                            //     initialUrl: 'about:blank',
                            //     onWebViewCreated:
                            //         (WebViewController
                            //     webViewController) {
                            //       _controller = webViewController;
                            //       _controller?.loadHtmlString(data.selectedArticle?.description??"");
                            //     },
                            //   ),
                            // ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 0.07.h,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Row(
                              children: [
                                Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                    onPressed: () {
                                      postLike(data.selectedArticle?.id, 0);
                                      setState(() {
                                        like = !like;
                                        if (dislike) {
                                          dislike = !like;
                                        }
                                      });
                                    },
                                    splashRadius: 20.0,
                                    splashColor: !like
                                        ? Constance.secondaryColor
                                        : Constance.primaryColor,
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: like
                                          ? Constance.secondaryColor
                                          : Constance.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                    onPressed: () {
                                      postLike(data.selectedArticle?.id, 1);
                                      setState(() {
                                        dislike = !dislike;
                                        if (like) {
                                          like = !dislike;
                                        }
                                      });
                                    },
                                    splashRadius: 20.0,
                                    splashColor: !dislike
                                        ? Constance.secondaryColor
                                        : Constance.primaryColor,
                                    icon: Icon(
                                      Icons.thumb_down,
                                      color: dislike
                                          ? Constance.secondaryColor
                                          : Constance.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),

                                SizedBox(
                                  width: 2.w,
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                    onPressed: () {
                                      Share.share(data
                                          .selectedArticle?.web_url ==
                                          ""
                                          ? 'check out our website https://guwahatiplus.com/'
                                          : '${data.selectedArticle?.web_url}');
                                    },
                                    splashRadius: 20.0,
                                    splashColor: Constance.secondaryColor,
                                    icon: const Icon(
                                      Icons.share,
                                      color: Constance.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 0.07.h,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'Related Stories',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                      color: Constance.primaryColor,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Sort by categories',
                                  style: Theme.of(Navigation.instance
                                          .navigatorKey.currentContext!)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                        color: Colors.black,
                                        // fontSize: 2.2.h,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors
                                          .black26, //                   <--- border color
                                      // width: 5.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  child: DropdownButton(
                                    isExpanded: false,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          color: Constance.primaryColor,
                                        ),
                                    underline: SizedBox.shrink(),
                                    // Initial Value
                                    value: dropdownvalue,

                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: categories.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                      });
                                      fetchContent();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (cont, count) {
                                  var item = data.suggestion[count];
                                  if (count != 0) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigation.instance.navigate('/story',
                                            args:
                                                '$dropdownvalue,${item.seo_name}');
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w, vertical: 2.h),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: Colors.white,
                                        ),
                                        height: 20.h,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                7.w,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          item.image_file_name ??
                                                              '',
                                                      fit: BoxFit.fill,
                                                      placeholder: (cont, _) {
                                                        return Image.asset(
                                                          Constance.logoIcon,
                                                        );
                                                      },
                                                      errorWidget:
                                                          (cont, _, e) {
                                                        return Image.network(
                                                          Constance
                                                              .defaultImage,
                                                          fit: BoxFit.fitWidth,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  Text(
                                                    // item.publish_date
                                                    //         ?.split(" ")[0] ??
                                                    //     "",
                                                    Jiffy(
                                                            item.publish_date
                                                                        ?.split(
                                                                            " ")[
                                                                    0] ??
                                                                "",
                                                            "yyyy-MM-dd")
                                                        .format("dd/MM/yyyy"),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.title ?? "",
                                                      maxLines: 3,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color: Constance
                                                                  .primaryColor),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  Text(
                                                    item.author_name ??
                                                        "GPlus News",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                                separatorBuilder: (cont, inde) {
                                  if (inde == 0) {
                                    return Container();
                                  } else {
                                    return SizedBox(
                                      height: 1.h,
                                      child: Divider(
                                        color: Colors.black,
                                        thickness: 0.3.sp,
                                      ),
                                    );
                                  }
                                },
                                itemCount: data.suggestion.length),
                            SizedBox(
                              height: 4.h,
                            ),
                          ],
                        ),
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
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
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
            // showSearch(
            //   context: context,
            //   delegate: SearchPage<Listing>(
            //     items: Constance.listings,
            //     searchLabel: 'Search posts',
            //     suggestion: Center(
            //       child: Text(
            //         'Filter posts by name, descr',
            //         style: Theme.of(context).textTheme.headline5,
            //       ),
            //     ),
            //     failure: const Center(
            //       child: Text('No posts found :('),
            //     ),
            //     filter: (current) => [
            //       current.title,
            //       current.descr,
            //       // person.age.toString(),
            //     ],
            //     builder: (data) => ListTile(
            //       title: Text(
            //         data.title ?? "",
            //         style: Theme.of(context).textTheme.headline5,
            //       ),
            //       subtitle: Text(
            //         data.descr ?? '',
            //         style: Theme.of(context).textTheme.headline6,
            //       ),
            //       // trailing: CachedNetworkImage(
            //       //   imageUrl: data.image??'',
            //       //   height: 20,
            //       //   width: 20,
            //       // ),
            //     ),
            //   ),
            // );
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void fetchAds() async {
    final response = await ApiProvider.instance.getAdvertise();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAds(response.ads ?? []);
      random = Random().nextInt(response.ads?.length ?? 0);
    }
  }

  void fetchDetails() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getArticleDetails(
        widget.slug.toString().split(',')[0],
        widget.slug.toString().split(',')[1]);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setArticleDetails(response.article!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  void fetchContent() async {
    final response = await ApiProvider.instance.getArticle(dropdownvalue);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSuggestion(response.articles ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
    }
  }

  void postLike(id, is_like) async {
    print(id);
    final response = await ApiProvider.instance.postLike(id, is_like, 'news');
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Post Liked");
      // fetchDetails();
    } else {
      showError("Something went wrong");
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
}
