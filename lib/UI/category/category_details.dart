import 'dart:math';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/alert.dart';
import '../../Components/suggestion_card.dart';
import '../../Components/suggestion_list_view.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class CategoryDetails extends StatefulWidget {
  final String? slug;

  const CategoryDetails({super.key, this.slug});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  int random = 0;
  var categories = ['sports', 'politics', 'obituary'];
  var dropdownvalue = 'sports';

  // WebViewController? _controller;
  bool like = false, dislike = false;

  int page = 1;

  bool is_bookmark = false;

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
      appBar: Constance.buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: data.selectedArticle == null
                ? Container()
                : Column(
                    children: [
                      Container(
                        height: 39.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.all(
                          //   // Radius.circular(10),
                          // ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              data.selectedArticle?.image_file_name ??
                                  'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
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
                            GestureDetector(
                              onTap: () {
                                Navigation.instance.navigate('/authorPage',
                                    args: data.selectedArticle?.author);
                              },
                              child: Text(
                                '${data.selectedArticle?.author_name ?? "G Plus"}, ${
                                // Jiffy(data.selectedArticle?.publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()
                                Jiffy(data.selectedArticle?.publish_date?.split(" ")[0], "yyyy-MM-dd").format("dd/MM/yyyy")}',
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
                                      postLike(data.selectedArticle?.id, 1);
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
                                      postLike(data.selectedArticle?.id, 0);
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
                                    onPressed: () {
                                      addBookmark(
                                          data.selectedArticle?.id, 'news');
                                      setState(() {
                                        is_bookmark = !is_bookmark;
                                      });
                                    },
                                    splashRadius: 20.0,
                                    splashColor: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.secondaryColor,
                                    icon: Icon(
                                      Icons.bookmark,
                                      color: is_bookmark
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
                                      Share.share(data
                                                  .selectedArticle?.web_url ==
                                              ""
                                          ? 'check out our website https://guwahatiplus.com/'
                                          : '${data.selectedArticle?.web_url}');
                                    },
                                    splashRadius: 20.0,
                                    splashColor: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.secondaryColor,
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
                            /* SizedBox(
                              height: 1.5.h,
                            ),*/
                            Html(
                              onImageError:
                                  (Object exception, StackTrace? stackTrace) {
                                print(exception);
                              },
                              onLinkTap: (str, contxt, map, elment) {
                                // print("${str}");
                                // print("${elment?.text}");
                                _launchUrl(Uri.parse(str ?? ""));
                              },
                              data: data.selectedArticle?.description?.trim() ??
                                  "",
                              shrinkWrap: true,
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
                            SizedBox(
                              height: 1.5.h,
                            ),
                            data.ads.isNotEmpty
                                ? Row(
                                    children: [
                                      Container(
                                        color: Constance.secondaryColor,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.2.h, horizontal: 1.w),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 2.w),
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
                                  )
                                : Container(),
                            data.ads.isNotEmpty
                                ? SizedBox(
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
                                          imageUrl: data.ads[random]
                                                  .image_file_name ??
                                              '',
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
                                  )
                                : Container(),
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
                                    onPressed: () {
                                      addBookmark(
                                          data.selectedArticle?.id, 'news');
                                      setState(() {
                                        is_bookmark = !is_bookmark;
                                      });
                                    },
                                    splashRadius: 20.0,
                                    splashColor: Constance.secondaryColor,
                                    icon: Icon(
                                      Icons.bookmark,
                                      color: is_bookmark
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
                                      Share.share(data
                                                  .selectedArticle?.web_url ==
                                              ""
                                          ? 'check out our website https://guwahatiplus.com/'
                                          : '${data.selectedArticle?.web_url}');
                                    },
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
                            Divider(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
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
                                          : Constance.primaryColor,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Sort By Categories',
                                  style: Theme.of(Navigation.instance
                                          .navigatorKey.currentContext!)
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
                                  width: 4.w,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white70
                                          : Colors
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
                                    dropdownColor: !Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    isExpanded: false,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          color: !Storage.instance.isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                    underline: SizedBox.shrink(),
                                    // Initial Value
                                    value: dropdownvalue,

                                    // Down Arrow Icon
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    // Array list of items
                                    items: categories.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items.capitalize()),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                        page = 1;
                                      });
                                      fetchContent();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SuggestionListView(
                              data: data,
                              dropdownvalue: dropdownvalue,
                            ),
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
                                      fetchMoreContent();
                                    }),
                              ],
                            ),
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
    final response = await ApiProvider.instance.getCategoryArticleDetails(
        widget.slug.toString().split(',')[0],
        widget.slug.toString().split(',')[1]);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setArticleDetails(response.article!);
      print(response.article?.is_liked);
      setState(() {
        like = is_liked(response.article?.is_liked ?? -1);
        dislike = is_disliked(response.article?.is_liked ?? -1);
        is_bookmark = response.article?.is_bookmark ?? false;
      });
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  void fetchContent() async {
    Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.getCategoryArticle(dropdownvalue, page);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSuggestion(response.articles ?? []);
      // _refreshController.refreshCompleted();

    } else {
      Navigation.instance.goBack();
      // _refreshController.refreshFailed();
    }
  }

  void fetchMoreContent() async {
    Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.getCategoryArticle(dropdownvalue, page);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .addSuggestion(response.articles ?? []);
      // _refreshController.refreshCompleted();
    } else {
      Navigation.instance.goBack();
      // _refreshController.refreshFailed();
    }
  }

  void postLike(id, is_like) async {
    print(id);
    final response = await ApiProvider.instance.postLike(id, is_like, 'news');
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "");
      // fetchDetails();
    } else {
      showError("Something went wrong");
    }
  }

  void addBookmark(bookmark_for_id, type) async {
    Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.addBookmark(bookmark_for_id, type);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Fluttertoast.showToast(msg: "Bookmark added successfully");
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
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

  bool is_liked(int i) {
    if (i == 1) {
      return true;
    }
    return false;
  }

  bool is_disliked(int i) {
    if (i == 0) {
      return true;
    }
    return false;
  }
}
