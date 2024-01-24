import 'dart:convert';
import 'dart:math';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:badges/badges.dart' as bd;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_html_video/flutter_html_video.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import 'package:flutter_html_all/flutter_html_all.dart';
import '../../Components/alert.dart';
import '../../Components/embeded_link_extenion.dart';
import '../../Components/opinion_details_item.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';
import '../Menu/berger_menu_member_page.dart';
import '../view/blockquote_extention.dart';

class OpinionDetailsPage extends StatefulWidget {
  final String? slug;

  // final String? opinionType;

  OpinionDetailsPage(this.slug);

  @override
  State<OpinionDetailsPage> createState() => _OpinionDetailsPageState();
}

class _OpinionDetailsPageState extends State<OpinionDetailsPage> {
  int random = 0;
  var categories = ['international', 'assam', 'guwahati', 'india'];
  var dropdownvalue = 'international';
  final ScrollController controller = ScrollController();

  // WebViewController? _controller;
  bool like = false, dislike = false;
  int page = 1;

  bool isEmpty = false;

  @override
  void dispose() {
    Provider.of<DataProvider>(
        Navigation.instance.navigatorKey.currentContext ?? context,
        listen: false)
        .clearOpinionDetails();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchDetails();
      fetchMoreContent();
    });
    fetchAds();
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
        } else {
          // print('At the bottom');
          // skip = skip * 2;
          page++;
          fetchMoreContent();
        }
      }
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: Constance.buildAppBar("opinion",true,_scaffoldKey),
      appBar: Constance.buildAppBar2("opinion"),
      // drawer: const BergerMenuMemPage(screen: "opinion",),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            controller: controller,
            child: data.opinion == null
                ? (isEmpty
                    ? Image.asset(
                        "assets/images/no_data.png",
                        // fit: BoxFit.fitWidth,
                        // width: 35.w,
                        scale: 4,
                      )
                    : Lottie.asset(
                        Constance.searchingIcon,
                      ))
                : Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 40.h,
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
                                vertical: 1.h, horizontal: 4.w),
                            // child: Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Text(
                            //       data.opinion?.image_caption ?? '',
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .headline6
                            //           ?.copyWith(
                            //             color: Colors.grey.shade200,
                            //             // fontSize: 25.sp,
                            //             fontWeight: FontWeight.bold,
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
                              data.opinion?.image_caption ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontStyle: FontStyle.italic,
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
                              height: 1.h,
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
                            GestureDetector(
                              onTap: () {
                                Navigation.instance.navigate(
                                  '/authorPage',
                                  args: data.opinion?.user_id,
                                );
                                // args: "${data.opinion?.user_id},${data.opinion?.}");
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
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                data.opinion?.user?.name ?? "G Plus",
                                            style: Theme.of(Navigation
                                                    .instance
                                                    .navigatorKey
                                                    .currentContext!)
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
                                                ' , ${Jiffy.parse(data.opinion?.publish_date!.split(" ")[0] ?? "", pattern: "yyyy-MM-dd").format(pattern: "dd MMM, yyyy")}',
                                            style: Theme.of(Navigation
                                                    .instance
                                                    .navigatorKey
                                                    .currentContext!)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(
                                                  color: Storage
                                                          .instance.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  // fontSize: 2.2.h,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 1.h,
                            // ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    postLike(data.opinion?.id, 1);
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
                                    postLike(data.opinion?.id, 0);
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
                                Material(
                                  type: MaterialType.transparency,
                                  child: IconButton(
                                    onPressed: () {
                                      // Share.share(data.opinion?.web_url == ""
                                      //     ? 'check out our website https://guwahatiplus.com/'
                                      //     : '${data.opinion?.web_url}');
                                      generateURL(
                                          data.opinion?.category_gallery!
                                              .seo_name!,
                                          data.opinion?.seo_name,
                                          extractLinesWithoutHtml(
                                              (data.opinion?.description??"").substring(0,200)
                                          ),
                                          data.opinion?.image_file_name,
                                          data.opinion?.title);
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
                                ),
                              ],
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
                              // customRender: {
                              //   // "img": (contextRender, child) {
                              //   //   return Text(
                              //   //       "${contextRender.tree.attributes['src']}",
                              //   //       style: Theme.of(context)
                              //   //           .textTheme
                              //   //           .headline5
                              //   //           ?.copyWith(
                              //   //             color: Colors.black,
                              //   //           ));
                              //   // },
                              //   "table": (context, child) {
                              //     return SingleChildScrollView(
                              //       scrollDirection: Axis.horizontal,
                              //       child: (context.tree as TableLayoutElement)
                              //           .toWidget(context),
                              //     );
                              //   },
                              //   "iframe": (context, child) {
                              //     return YoutubePlayer(
                              //       // controller: _controller = YoutubePlayerController(
                              //       //   initialVideoId: current.youtube_id!,
                              //       //   flags: const YoutubePlayerFlags(
                              //       //     autoPlay: false,
                              //       //     mute: false,
                              //       //   ),
                              //       // ),
                              //       controller: YoutubePlayerController(
                              //         initialVideoId: context
                              //             .tree.attributes['src']
                              //             .toString()
                              //             .split("/")[4]
                              //             .toString(),
                              //         flags: const YoutubePlayerFlags(
                              //           hideControls: false,
                              //           // hideThumbnail: true,
                              //           autoPlay: false,
                              //         ),
                              //       ),
                              //       showVideoProgressIndicator: true,
                              //
                              //       thumbnail: Image.network(
                              //         getYoutubeThumbnail(context
                              //             .tree.attributes['src']
                              //             .toString()
                              //             .split("/")[4]
                              //             .toString()),
                              //         fit: BoxFit.fill,
                              //       ),
                              //       // aspectRatio: 16 / 10,
                              //       // videoProgressIndicatorColor: Colors.amber,
                              //       progressColors: const ProgressBarColors(
                              //         playedColor: Colors.amber,
                              //         handleColor: Colors.amberAccent,
                              //       ),
                              //       onReady: () {
                              //         // print('R12345&d');
                              //         // _controller
                              //         //     .addListener(() {});
                              //         // _controller!.play();
                              //         // setState(() {
                              //         //   controller.play();
                              //         // });
                              //       },
                              //     );
                              //     return Text(
                              //       context.tree.attributes['src']
                              //           .toString()
                              //           .split("/")[4]
                              //           .toString(),
                              //       style: TextStyle(color: Colors.black54),
                              //     );
                              //   },
                              //   "a": (context, child) {
                              //     return ((context.tree.element?.innerHtml
                              //         .toString()
                              //         .contains("ad_managers") ??
                              //         false))
                              //         ? GestureDetector(
                              //       onTap: () {
                              //         // print();
                              //         _launchUrl(Uri.parse(
                              //           context.tree.element?.outerHtml
                              //               .split("href=")[1]
                              //               .substring(
                              //               1,
                              //               (context.tree.element
                              //                   ?.outerHtml
                              //                   .split(
                              //                   "href=")[1]
                              //                   .length ??
                              //                   6) -
                              //                   6) ??
                              //               "",
                              //         ));
                              //       },
                              //       child: Padding(
                              //         padding: EdgeInsets.symmetric(
                              //           horizontal: 2.w,
                              //         ),
                              //         child: CachedNetworkImage(
                              //           fit: BoxFit.fill,
                              //           imageUrl: context
                              //               .tree.element?.innerHtml
                              //               .split("=")[1]
                              //               .toString()
                              //               .substring(
                              //               1,
                              //               (context.tree.element
                              //                   ?.innerHtml
                              //                   .split(
                              //                   "=")[1]
                              //                   .toString()
                              //                   .length ??
                              //                   0) -
                              //                   2) ??
                              //               "",
                              //           placeholder: (cont, _) {
                              //             return Image.asset(
                              //               Constance.logoIcon,
                              //               // color: Colors.black,
                              //             );
                              //           },
                              //           errorWidget: (cont, _, e) {
                              //             return Image.network(
                              //               Constance.defaultImage,
                              //               fit: BoxFit.fitWidth,
                              //             );
                              //           },
                              //         ),
                              //       ),
                              //     )
                              //         : GestureDetector(
                              //       onTap: () {
                              //         if ((context.tree.attributes['href']
                              //             .toString()
                              //             .split("/")[2]
                              //             .trim() ==
                              //             "www.guwahatiplus.com")||(context.tree.attributes['href']
                              //             .toString()
                              //             .split("/")[2]
                              //             .trim() ==
                              //             "guwahatiplus.com")) {
                              //           if (context
                              //               .tree.attributes['href']
                              //               .toString()
                              //               .split("/")
                              //               .length >=
                              //               5) {
                              //             Navigation.instance.navigate(
                              //                 '/story',
                              //                 args:
                              //                 '${context.tree.attributes['href'].toString().split("/")[3]},${context.tree.attributes['href'].toString().split("/")[4]},story_page');
                              //           } else {
                              //             Navigation.instance.navigate(
                              //                 '/newsfrom',
                              //                 args: context
                              //                     .tree.attributes['href']
                              //                     .toString()
                              //                     .split("/")[3]);
                              //           }
                              //         } else {
                              //           try {
                              //             _launchUrl(Uri.parse(context
                              //                 .tree
                              //                 .attributes['href'] ??
                              //                 "https://guwahatiplus.com/"));
                              //           } catch (e) {
                              //             debugPrint(e.toString());
                              //           }
                              //         }
                              //       },
                              //       child: Text(
                              //         // context.tree.element?.innerHtml.toString().contains("ad_managers").toString()??"",
                              //         context.tree.element?.innerHtml
                              //             .split("=")[0]
                              //             .toString() ??
                              //             "",
                              //         style: Theme.of(Navigation
                              //             .instance
                              //             .navigatorKey
                              //             .currentContext!)
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
                              //   // "img": (context, child) {
                              //   //   return Container(
                              //   //     child: Text("${context.tree.element?.outerHtml.split("src=").toList()
                              //   //         .toString()}",style: const TextStyle(color: Colors.black54),),
                              //   //   );
                              //   // },
                              //   "blockquote": (context, child) {
                              //     return context.tree.element?.innerHtml
                              //         .split("=")
                              //         .length ==
                              //         3
                              //         ? SizedBox(
                              //       height: 28.h,
                              //       // width: 90.h,
                              //       child: GestureDetector(
                              //         onTap: () {
                              //           _launchUrl(Uri.parse(context
                              //               .tree.element?.innerHtml
                              //               .split("=")[3]
                              //               .split("?")[0]
                              //               .substring(1) ??
                              //               ""));
                              //
                              //           // print(context.tree.element?.innerHtml
                              //           //     .split("=")[3]
                              //           //     .split("?")[0]);
                              //         },
                              //         child: AbsorbPointer(
                              //           child: WebView(
                              //             gestureNavigationEnabled: false,
                              //             zoomEnabled: true,
                              //             initialUrl: Uri.dataFromString(
                              //               getHtmlString(context
                              //                   .tree.element?.innerHtml
                              //                   .split("=")[3]
                              //                   .split("?")[0]
                              //                   .split("/")
                              //                   .last),
                              //               mimeType: 'text/html',
                              //               encoding: Encoding.getByName(
                              //                   'utf-8'),
                              //             ).toString(),
                              //             javascriptMode:
                              //             JavascriptMode.unrestricted,
                              //           ),
                              //         ),
                              //       ),
                              //     )
                              //         : Container();
                              //     // return Container(
                              //     //     child: Text(
                              //     //   '${context.tree.element?.innerHtml.split("=")[3].split("?")[0].split("/").last}',
                              //     //   style: TextStyle(color: Colors.black),
                              //     // ));
                              //   },
                              // },
                              extensions: const [
                                IframeHtmlExtension(),
                                TableHtmlExtension(),
                                VideoHtmlExtension(),
                                EmbeddedLinkExtension(2),
                                BlockquoteExtension(),
                              ],
                              onLinkTap: (str, map, elment) {
                                // print("${str}");
                                // print("${elment?.text}");
                                debugPrint(str);
                              },
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
                              height: 1.h,
                            ),
                            Divider(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              thickness: 0.07.h,
                            ),

                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    postLike(data.opinion?.id, 1);
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
                                    postLike(data.opinion?.id, 0);
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
                                    // Share.share(data.opinion?.web_url == ""
                                    //     ? 'check out our website https://guwahatiplus.com/'
                                    //     : '${data.opinion?.web_url}');
                                    generateURL(
                                      data.opinion?.category_gallery!
                                          .seo_name!,
                                      data.opinion?.seo_name,
                                      extractLinesWithoutHtml( (data.opinion?.description??"").substring(0,200) ),
                                      data.opinion?.image_file_name,
                                      data.opinion?.title,
                                    );
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

                            Divider(
                              color: Colors.black,
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
                              height: 2.h,
                            ),

                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (cont, count) {
                                  var item = data.suggestedOpinions[count];
                                  if (count != 0) {
                                    return OpinionDetailsItem(item: item);
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
                                        color: Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        thickness: 0.3.sp,
                                      ),
                                    );
                                  }
                                },
                                itemCount: data.suggestedOpinions.length),
                            SizedBox(
                              height: 2.h,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     CustomButton(
                            //         txt: 'Load More',
                            //         onTap: () {
                            //           page++;
                            //           fetchMoreContent();
                            //         }),
                            //   ],
                            // ),
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
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getOpinionDetails(widget.slug);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setOpinionDetails(response.opinion!);
      setState(() {
        isEmpty = (response.opinion == null) ? true : false;
      });
      // Navigation.instance.goBack();
      if ((response.opinion?.has_permission ?? false)) {
      } else {
        Navigation.instance.navigate("/showMembership",
            args:
            "${Provider.of<DataProvider>(context, listen: false).profile?.name}");
      }
    } else {
      setState(() {
        isEmpty = true;
      });
      // Navigation.instance.goBack();
      // Navigation.instance.goBack();
    }
  }

  void fetchContent() async {
    final response = await ApiProvider.instance.getOpinionRecomended(
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .opinion
            ?.category_gallery
            ?.seo_name,
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .opinion
            ?.seo_name,
        5,
        page);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setSuggestedOpinions(response.opinion ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
    }
  }

  void fetchMoreContent() async {
    final response = await ApiProvider.instance.getOpinionRecomended(
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .opinion
            ?.category_gallery
            ?.seo_name,
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext!,
                listen: false)
            .opinion
            ?.seo_name,
        5,
        page);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setMoreSuggestedOpinions(response.opinion ?? []);
      // _refreshController.refreshCompleted();
    } else {
      // _refreshController.refreshFailed();
    }
  }

  void postLike(id, is_like) async {
    final response =
        await ApiProvider.instance.postLike(id, is_like, 'opinion');
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "Post Liked");
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

String getHtmlString(String? tweetId) {
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

void generateURL(String? seo_name, String? first_cat_name, String? description,
    String? image_url, String? title) async {
  debugPrint(
      "generating URL \n$first_cat_name \n ${title} \n $description \n $image_url");
  final dynamicLinkParams = DynamicLinkParameters(
    link: Uri.parse(
        // "${FlutterConfig.get('domain')}/link/opinion/${first_cat_name}/${seo_name}"),
        "${FlutterConfig.get('domain')}/opinion/$seo_name/$first_cat_name"),
    uriPrefix: FlutterConfig.get('customHostDeepLink'),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: title,
      description: description,
      imageUrl: Uri.tryParse(image_url ?? ""),
    ),
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
      shortLinkType: ShortDynamicLinkType.unguessable);

  debugPrint(
      "${FlutterConfig.get('domain')}/opinion/${seo_name}/${first_cat_name}");
  debugPrint(
      "${FlutterConfig.get('domain')}/opinion/${first_cat_name}/${seo_name}");
  Share.share(dynamicLink.shortUrl.toString());
  // return "https://guwahatiplus.com/link/story/${seo_name}/${first_cat_name}";
}

String extractLinesWithoutHtml(String inputText) {
  // Remove HTML tags
  String textWithoutHtml = removeAllHtmlTags(inputText);

  // Split the text into lines
  List<String> lines = textWithoutHtml.split('\n');

  // Filter out empty lines and trim leading spaces from the first letter
  List<String> filteredLines = lines
      .where((line) => line.trim().isNotEmpty)
      .map((line) => line.replaceFirst(RegExp(r'^\s*'), ''))
      .toList();

  // Join the lines back into a single string
  String result = filteredLines.join('\n');

  return result;
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
    r"<[^>]*>",
    multiLine: true,
    caseSensitive: true,
  );

  return htmlText.replaceAll(exp, '');
}

