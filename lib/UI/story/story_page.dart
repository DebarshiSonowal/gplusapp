import 'dart:convert';
import 'dart:math';

import 'package:badges/badges.dart' as bd;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_html/flutter_html.dart';

// import 'package:flutter_html/custom_render.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Model/category_name.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:twitter_oembed_api/twitter_oembed_api.dart';

// import 'package:twitter_cards/twitter_cards.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../Components/alert.dart';
import '../../Components/suggestion_card.dart';
import '../../Components/suggestion_list_view.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class StoryPage extends StatefulWidget {
  final String? slug;

  StoryPage(this.slug);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final twitterApi = TwitterOEmbedApi();
  int random = 0;
  var categories = [
    'international',
    'assam',
    'guwahati',
    'india',
    'northeast',
    'exclusive-news'
  ];
  var dropdownvalue = 'international';

  // WebViewController? _controller;
  bool like = false, dislike = false, isEmpty = false;
  String blockquote = "";
  int skip = 10;
  WebViewController? _controller;
  bool is_bookmark = false;

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchDetails();
      setRead(Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .notifications
          .firstWhere((element) =>
              element.seo_name == widget.slug.toString().split(',')[1])
          .id);
    });
    fetchAds();
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
        } else {
          // print('At the bottom');
          skip = skip * 2;
          fetchMoreContent();
        }
      }
    });
  }

  @override
  void dispose() {
    Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .selectedArticle = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar2("article_detail"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            controller: controller,
            child: data.selectedArticle == null
                ? Lottie.asset(
                    isEmpty ? Constance.noDataLoader : Constance.searchingIcon,
                  )
                : Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 36.h,
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
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                // gradient: LinearGradient(
                                //   begin: Alignment.topCenter,
                                //   end: Alignment.bottomCenter,
                                //   colors: [Colors.transparent,Colors.black45, Colors.black],
                                // ),
                                // color: Colors.black,
                                ),
                            // color: Colors.black.withOpacity(0.5),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.5.h, horizontal: 4.w),
                            // child: Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Text(
                            //       data.selectedArticle?.image_caption ?? '',
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .headline6
                            //           ?.copyWith(
                            //             color: Colors.white,
                            //             // fontSize: 25.sp,
                            //             // fontWeight: FontWeight.bold,
                            //             // fontStyle: FontStyle.italic,
                            //           ),
                            //     ),
                            //     // Text(
                            //     //   "${current.author_name?.trim()}, ${Jiffy(current.publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}",
                            //     //   style: Theme.of(context).textTheme.headline6?.copyWith(
                            //     //         color: Colors.white,
                            //     //       ),
                            //     // ),
                            //   ],
                            // ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 3.w,
                          ),
                          SizedBox(
                            width: 90.w,
                            child: Text(
                              data.selectedArticle?.image_caption ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    // fontSize: 25.sp,
                                    // fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              child: Row(
                                children: [
                                  Image.asset(
                                    Constance.authorIcon,
                                    scale: 30,
                                    color: Constance.secondaryColor,
                                  ),
                                  SizedBox(
                                    width: 0.5.w,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${data.selectedArticle?.author_name==""?
                                                  "G Plus News"
                                                  :data.selectedArticle?.author_name}',
                                          style: Theme.of(Navigation.instance
                                                  .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                color: Storage
                                                        .instance.isDarkMode
                                                    ? Constance.secondaryColor
                                                    : Constance.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' , ${Jiffy(data.selectedArticle?.publish_date?.split(" ")[0], "yyyy-MM-dd").format("dd MMM,yyyy")}',
                                          style: Theme.of(Navigation.instance
                                                  .navigatorKey.currentContext!)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                color:
                                                    Storage.instance.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                // fontSize: 2.2.h,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    postLike(data.selectedArticle?.id, 1);
                                    setState(() {
                                      like = !like;
                                      if (dislike) {
                                        dislike = !like;
                                      }
                                    });
                                  },
                                  splashRadius: 10.0,
                                  splashColor: !like
                                      ? Constance.secondaryColor
                                      : Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Constance.primaryColor,
                                  icon: Icon(
                                    Icons.thumb_up,
                                    // size: 16.sp,
                                    color: like
                                        ? Constance.secondaryColor
                                        : Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Constance.primaryColor,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 0.w,
                                // ),
                                IconButton(
                                  onPressed: () {
                                    postLike(data.selectedArticle?.id, 0);
                                    setState(() {
                                      dislike = !dislike;
                                      if (like) {
                                        like = !dislike;
                                      }
                                    });
                                  },
                                  splashRadius: 10.0,
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
                                // SizedBox(
                                //   width: 2.w,
                                // ),
                                IconButton(
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
                                // SizedBox(
                                //   width: 2.w,
                                // ),
                                IconButton(
                                  onPressed: () {
                                    // Share.share(data.selectedArticle?.web_url ==
                                    //         ""
                                    //     ? 'check out our website https://guwahatiplus.com/'
                                    //     : '${data.selectedArticle?.web_url}');
                                    generateURL(
                                        data.selectedArticle?.first_cat_name
                                            ?.seo_name,
                                        data.selectedArticle?.seo_name,
                                        data.selectedArticle?.description
                                            ?.trim()
                                            .split(".")
                                            .sublist(0, 4)
                                            .join(""),
                                        data.selectedArticle?.image_file_name
                                            ?.toString());
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
                              customRender: {
                                "table": (context, child) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: (context.tree as TableLayoutElement)
                                        .toWidget(context),
                                  );
                                },
                                "iframe": (context, child) {
                                  return YoutubePlayer(
                                    // controller: _controller = YoutubePlayerController(
                                    //   initialVideoId: current.youtube_id!,
                                    //   flags: const YoutubePlayerFlags(
                                    //     autoPlay: false,
                                    //     mute: false,
                                    //   ),
                                    // ),
                                    controller: YoutubePlayerController(
                                      initialVideoId: context
                                          .tree.attributes['src']
                                          .toString()
                                          .split("/")[4]
                                          .toString(),
                                      flags: const YoutubePlayerFlags(
                                        hideControls: false,
                                        // hideThumbnail: true,
                                        autoPlay: false,
                                      ),
                                    ),
                                    showVideoProgressIndicator: true,

                                    thumbnail: Image.network(
                                      getYoutubeThumbnail(context
                                          .tree.attributes['src']
                                          .toString()
                                          .split("/")[4]
                                          .toString()),
                                      fit: BoxFit.fill,
                                    ),
                                    // aspectRatio: 16 / 10,
                                    // videoProgressIndicatorColor: Colors.amber,
                                    progressColors: const ProgressBarColors(
                                      playedColor: Colors.amber,
                                      handleColor: Colors.amberAccent,
                                    ),
                                    onReady: () {
                                      // print('R12345&d');
                                      // _controller
                                      //     .addListener(() {});
                                      // _controller!.play();
                                      // setState(() {
                                      //   controller.play();
                                      // });
                                    },
                                  );
                                  return Text(
                                    context.tree.attributes['src']
                                        .toString()
                                        .split("/")[4]
                                        .toString(),
                                    style: TextStyle(color: Colors.black54),
                                  );
                                },
                                "a": (context, child) {
                                  return GestureDetector(
                                    onTap: () {
                                      print("https://www.gmcpropertytax.com");
                                      if (context.tree.attributes['href']
                                              .toString()
                                              .split("/")[2]
                                              .trim() ==
                                          "www.guwahatiplus.com") {
                                        if (context.tree.attributes['href']
                                                .toString()
                                                .split("/")
                                                .length >=
                                            5) {
                                          Navigation.instance.navigate('/story',
                                              args:
                                                  '${context.tree.attributes['href'].toString().split("/")[3]},${context.tree.attributes['href'].toString().split("/")[4]}');
                                        } else {
                                          Navigation.instance.navigate(
                                              '/newsfrom',
                                              args: context
                                                  .tree.attributes['href']
                                                  .toString()
                                                  .split("/")[3]);
                                        }
                                      } else {
                                        try {
                                          _launchUrl(Uri.parse(
                                              "https://www.gmcpropertytax.com"));
                                        } catch (e) {
                                          print(e);
                                        }
                                      }
                                    },
                                    child: Text(
                                      context.tree.element?.innerHtml
                                              .split("=")[0]
                                              .toString() ??
                                          "",
                                      style: Theme.of(Navigation.instance
                                              .navigatorKey.currentContext!)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            color: Constance.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  );
                                },
                                "blockquote": (context, child) {
                                  return context
                                      .tree.element?.innerHtml
                                      .split("=").length==3?SizedBox(
                                    height: 28.h,
                                    // width: 90.h,
                                    child: GestureDetector(
                                      onTap: () {
                                        _launchUrl(Uri.parse(context
                                                .tree.element?.innerHtml
                                                .split("=")[3]
                                                .split("?")[0]
                                                .substring(1) ??
                                            ""));

                                        // print(context.tree.element?.innerHtml
                                        //     .split("=")[3]
                                        //     .split("?")[0]);
                                      },
                                      child: AbsorbPointer(
                                        child: WebView(
                                          gestureNavigationEnabled: false,
                                          zoomEnabled: true,
                                          initialUrl: Uri.dataFromString(
                                            getHtmlString(context
                                                .tree.element?.innerHtml
                                                .split("=")[3]
                                                .split("?")[0]
                                                .split("/")
                                                .last),
                                            mimeType: 'text/html',
                                            encoding:
                                                Encoding.getByName('utf-8'),
                                          ).toString(),
                                          javascriptMode:
                                              JavascriptMode.unrestricted,
                                        ),
                                      ),
                                    ),
                                  ):Container(

                                  );
                                  // return Container(
                                  //     child: Text(
                                  //   '${context.tree.element?.innerHtml.split("=")[3].split("?")[0].split("/").last}',
                                  //   style: TextStyle(color: Colors.black),
                                  // ));
                                },
                              },
                              onLinkTap: (str, contxt, map, elment) {
                                // print("${str}");
                                // print("${elment?.text}");
                                print(str);
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
                            Wrap(
                              children: [
                                for (var i
                                    in data.selectedArticle!.tags!.split(","))
                                  GestureDetector(
                                    onTap: () {
                                      Navigation.instance
                                          .navigate('/search', args: i);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 1.h),
                                      color: Constance.primaryColor,
                                      child: Text(
                                        i.trim(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            // SizedBox(
                            //   height: 1.5.h,
                            // ),
                            SizedBox(
                              height: 1.h,
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
                                                fontSize: 9.sp,
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
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
                              height: 0.5.h,
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 0.07.h,
                            ),

                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    postLike(data.selectedArticle?.id, 1);
                                    setState(() {
                                      like = !like;
                                      if (dislike) {
                                        dislike = !like;
                                      }
                                    });
                                  },
                                  splashRadius: 10.0,
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
                                // SizedBox(
                                //   width: 2.w,
                                // ),
                                IconButton(
                                  onPressed: () {
                                    postLike(data.selectedArticle?.id, 0);
                                    setState(() {
                                      dislike = !dislike;
                                      if (like) {
                                        like = !dislike;
                                      }
                                    });
                                  },
                                  splashRadius: 10.0,
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
                                // SizedBox(
                                //   width: 2.w,
                                // ),
                                IconButton(
                                  onPressed: () {
                                    addBookmark(
                                        data.selectedArticle?.id, 'news');
                                    setState(() {
                                      is_bookmark = !is_bookmark;
                                    });
                                  },
                                  splashRadius: 10.0,
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
                                // SizedBox(
                                //   width: 2.w,
                                // ),
                                IconButton(
                                  onPressed: () {
                                    // Share.share(data.selectedArticle?.web_url ==
                                    //         ""
                                    //     ? 'check out our website https://guwahatiplus.com/'
                                    //     : '${data.selectedArticle?.web_url}');
                                    generateURL(
                                        data.selectedArticle?.first_cat_name
                                            ?.seo_name,
                                        data.selectedArticle?.seo_name,
                                        data.selectedArticle?.description
                                            ?.trim()
                                            .split(".")
                                            .sublist(0, 4)
                                            .join(""),
                                        data.selectedArticle?.image_file_name
                                            .toString());
                                  },
                                  splashRadius: 10.0,
                                  splashColor: Constance.secondaryColor,
                                  icon: Icon(
                                    Icons.share,
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Constance.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 1.h,
                            // ),
                            Divider(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              thickness: 0.07.h,
                            ),
                            SizedBox(
                              height: 1.h,
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
                              height: 1.h,
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
                                        child: Text(items
                                            .capitalize()
                                            .replaceFirst("-", " ")),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                        skip = 10;
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
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     CustomButton(
                            //         txt: 'Load More',
                            //         onTap: () {
                            //           skip = skip * 2;
                            //           fetchMoreContent();
                            //         }),
                            //   ],
                            // ),
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
              badgeColor: Constance.secondaryColor,
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

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  void setRead(String? id) async {
    final response = await ApiProvider.instance.notificationRead(id);
    if (response.success ?? false) {
      fetchNotification();
    } else {
      showError(response.message ?? "Something went wrong");
    }
  }

  void fetchNotification() async {
    final response = await ApiProvider.instance.getNotifications();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setNotificationInDevice(response.notification);
      // setState(() {
      //   isEmpty = response.notification.isEmpty ? true : false;
      // });
    } else {
      // setState(() {
      //   isEmpty = true;
      // });
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
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getArticleDetails(
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
        if (categories.contains(response.article?.first_cat_name!.seo_name)) {
          dropdownvalue =
              response.article?.first_cat_name?.seo_name ?? "international";
          fetchContent();
        } else {
          fetchContent();
        }
      });
      // Navigation.instance.goBack();
      setState(() {
        isEmpty = false;
      });
    } else {
      setState(() {
        isEmpty = true;
      });
      // Navigation.instance.goBack();
    }
  }

  void fetchContent() async {
    // Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.getMoreArticle(dropdownvalue, 11, 1, skip);
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setSuggestion(response.articles ?? []);
      // _refreshController.refreshCompleted();

    } else {
      // Navigation.instance.goBack();
      // _refreshController.refreshFailed();
    }
  }

  void fetchMoreContent() async {
    // Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.getMoreArticle(dropdownvalue, 11, 1, skip);
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .addSuggestion(response.articles ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // Navigation.instance.goBack();
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
      Fluttertoast.showToast(
          msg: response.message ?? "Bookmark added successfully");
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

  getEmbeded(context) async {
    // fetchIT(id);
    // return blockquote;
    final embeddedTweet = await twitterApi.publishEmbeddedTweet(
      screenName: 'embeded',
      tweetId: context.tree.element?.innerHtml
          .split("=")[3]
          .split("?")[0]
          .split("/")
          .last,
      maxWidth: 850,
      // omitScript: true,
      // align: ContentAlign.center,
    );
    _controller?.loadHtmlString(embeddedTweet.html);
  }

  String getHtmlString(String? tweetId) {
    print("#!)!)!: ${tweetId}");
    return """
      <html>
      
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
        </head>
        <body>
            <div id="container"></div>
                
        </body>
        <script id="twitter-wjs" type="text/javascript" async defer src="https://platform.twitter.com/widgets.js" onload="createMyTweet()"></script>
        <script>
        
       
      function  createMyTweet() {  
         var twtter = window.twttr;
  
         twttr.widgets.createTweet(
          '$tweetId',
          document.getElementById('container'),
          {
          width:250
          }
        )
      }
        </script>
        
      </html>
    """;
  }

  String getYoutubeThumbnail(var id) {
    return 'https://img.youtube.com/vi/${id}/0.jpg';
  }

  void generateURL(
      first_cat_name, String? seo_name, description, image_url) async {
    // final dynamicLinkParams = DynamicLinkParameters(
    //   link: Uri.parse(
    //       "https://guwahatiplus.com/link/story/${seo_name}/${first_cat_name}"),
    //   uriPrefix: "https://guwahatiplus.page.link",
    //   androidParameters:
    //       const AndroidParameters(packageName: "com.appbazooka.gplus"),
    //   iosParameters: const IOSParameters(bundleId: "com.gplus.app.gplusapp"),
    // );
    // final dynamicLink =
    //     await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          "${FlutterConfig.get('domain')}/link/story/${seo_name}/${first_cat_name}"),
      uriPrefix: FlutterConfig.get('customHostDeepLink'),
      androidParameters: AndroidParameters(
        packageName: FlutterConfig.get("androidPackage"),
      ),
      iosParameters: IOSParameters(
        bundleId: FlutterConfig.get('iosBundleId'),
      ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   description: description,
      //   title: seo_name?.replaceAll("-", " "),
      //   imageUrl: Uri.parse(image_url),
      // ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );

    Share.share(dynamicLink.shortUrl.toString());
    // return "https://guwahatiplus.com/link/story/${seo_name}/${first_cat_name}";
  }
}
