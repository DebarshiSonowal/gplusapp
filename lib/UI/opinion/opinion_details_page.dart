import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class OpinionDetailsPage extends StatefulWidget {
  final String? slug;

  OpinionDetailsPage(this.slug);

  @override
  State<OpinionDetailsPage> createState() => _OpinionDetailsPageState();
}

class _OpinionDetailsPageState extends State<OpinionDetailsPage> {
  int random = 0;
  var categories = ['international', 'assam', 'guwahati', 'india'];
  var dropdownvalue = 'international';
  // WebViewController? _controller;
  bool like = false, dislike = false;
  int page=1;
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
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: data.opinion == null
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
                              data.opinion?.image_file_name ??
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
                            // SizedBox(
                            //   height: 2.h,
                            // ),
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
                              data.opinion?.title ??
                                  'It is a long established fact that a reader will be distracted by the readable content of a',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.primaryColor,
                                    // fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              '${data.opinion?.author_name ?? "GPlus"}, ${Jiffy(data.opinion?.publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}',
                              style: Theme.of(Navigation
                                      .instance.navigatorKey.currentContext!)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    // fontSize: 2.2.h,
                                    // fontWeight: FontWeight.bold,
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
                                      postLike(data.opinion?.id, 0);
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
                                        : Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Constance.primaryColor,
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: like
                                          ? Constance.secondaryColor
                                          : Storage.instance.isDarkMode
                                              ? Colors.white
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
                                      postLike(data.opinion?.id, 1);
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
                                        : Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Constance.primaryColor,
                                    icon: Icon(
                                      Icons.thumb_down,
                                      color: dislike
                                          ? Constance.secondaryColor
                                          : Storage.instance.isDarkMode
                                              ? Colors.white
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
                                    onPressed: () {},
                                    splashRadius: 20.0,
                                    splashColor: Constance.secondaryColor,
                                    icon: Icon(
                                      Icons.share,
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Constance.primaryColor,
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
                              data: data.opinion?.description?.trim() ?? "",
                              shrinkWrap: true,
                              style: {
                                '#': Style(
                                  // fontSize: FontSize(_counterValue),
                                  // maxLines: 20,
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      :Colors.black,
                                  // textOverflow: TextOverflow.ellipsis,
                                ),
                              },
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            data.ads.isNotEmpty?Row(
                              children: [
                                Container(
                                  color: Constance.secondaryColor,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.2.h, horizontal: 1.w),
                                  margin: EdgeInsets.symmetric(horizontal: 2.w),
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
                            ):Container(),
                            data.ads.isNotEmpty?SizedBox(
                              // height: 10.h,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  _launchUrl(Uri.parse(
                                      data.ads[random].link.toString()));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                  ),
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
                            ):Container(),
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
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  :Colors.black,
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
                                      postLike(data.opinion?.id, 0);
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
                                        : Storage.instance.isDarkMode
                                        ? Colors.white
                                        :Constance.primaryColor,
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: like
                                          ? Constance.secondaryColor
                                          : Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Constance.primaryColor,
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
                                      postLike(data.opinion?.id, 1);
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
                                        : Storage.instance.isDarkMode
                                        ? Colors.white
                                        :Constance.primaryColor,
                                    icon: Icon(
                                      Icons.thumb_down,
                                      color: dislike
                                          ? Constance.secondaryColor
                                          : Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Constance.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                    onPressed: () {},
                                    splashRadius: 20.0,
                                    splashColor: Constance.secondaryColor,
                                    icon:  Icon(
                                      Icons.share,
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Constance.primaryColor,
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
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Constance.primaryColor,
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
                                        color: Storage.instance.isDarkMode
                                            ? Colors.white
                                            :Colors.black,
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
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Colors
                                          .black26, //                   <--- border color
                                      // width: 5.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            5.0) //                 <--- border radius here
                                        ),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.5.w),
                                  child: DropdownButton(
                                    isExpanded: false,
                                    dropdownColor: !Storage.instance.isDarkMode
                                        ? Colors.white
                                        :Colors.black,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          color: Storage.instance.isDarkMode
                                              ? Colors.white
                                              :Constance.primaryColor,
                                        ),
                                    underline: SizedBox.shrink(),
                                    // Initial Value
                                    value: dropdownvalue,

                                    // Down Arrow Icon
                                    icon: Icon(Icons.keyboard_arrow_down,color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        :Colors.black,),

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
                                        page=1;
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
                                  var item = data.opinions[count];
                                  if (count != 0) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigation.instance.navigate('/story',
                                        //     args:
                                        //         '$dropdownvalue,${item.seo_name}');
                                        Navigation.instance.navigate(
                                            '/opinionDetails',
                                            args: item.seo_name?.trim());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w, vertical: 1.h),
                                        decoration:  BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: Storage.instance.isDarkMode
                                              ? Colors.black
                                              :Colors.white,
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
                                                  CachedNetworkImage(
                                                    height: 15.h,
                                                    width: 45.w,
                                                    imageUrl:
                                                        item.image_file_name ??
                                                            '',
                                                    fit: BoxFit.fill,
                                                    placeholder: (cont, _) {
                                                      return Image.asset(
                                                        Constance.logoIcon,
                                                        // color: Colors.black,
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
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  Text(
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
                                                            Storage.instance.isDarkMode
                                                                ? Colors.white
                                                                :Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Expanded(
                                              flex: 1,
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
                                                              color: Storage.instance.isDarkMode
                                                                  ? Colors.white
                                                                  :Constance
                                                                  .primaryColor),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  Text(
                                                    item.author_name ??
                                                        "G Plus News",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                            color:
                                                            Storage.instance.isDarkMode
                                                                ? Colors.white
                                                                : Colors.black),
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
                                        color:Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        thickness: 0.3.sp,
                                      ),
                                    );
                                  }
                                },
                                itemCount: data.opinions.length),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                    txt: 'Load More',
                                    onTap: () {
                                      page++;
                                      fetchContent();
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
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
    final response = await ApiProvider.instance.getOpinionDetails(widget.slug);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setOpinionDetails(response.opinion!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  void fetchContent() async {
    final response = await ApiProvider.instance.getOpinion(5, page);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setOpinions(response.opinion ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
    }
  }

  void postLike(id, is_like) async {
    final response =
        await ApiProvider.instance.postLike(id, is_like, 'opinion');
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
