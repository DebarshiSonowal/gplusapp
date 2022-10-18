import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GuwahatiConnectPage extends StatefulWidget {
  const GuwahatiConnectPage({Key? key}) : super(key: key);

  @override
  State<GuwahatiConnectPage> createState() => _GuwahatiConnectPageState();
}

class _GuwahatiConnectPageState extends State<GuwahatiConnectPage> {
  int current = 2;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var _searchQueryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchGuwahatiConnect();
      if (!Storage.instance.isGuwahatiConnect) {
        showDialogBox();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      key: scaffoldKey,
      drawer: BergerMenuMemPage(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          checkIt();

          // showDialogBox();
        },
        icon: Icon(Icons.add),
        label: Text(
          "Ask a question",
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
              ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            FontAwesomeIcons.radio,
                            color: Colors.black,
                            size: 6.h,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        'Guwahati Connect',
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                            color: Constance.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Divider(
                  thickness: 0.07.h,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Consumer<DataProvider>(builder: (context, current, _) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: current.guwahatiConnect.length,
                    itemBuilder: (context, count) {
                      var data = current.guwahatiConnect[count];
                      bool like = false, dislike = false;
                      return StatefulBuilder(builder: (context, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 3,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 1.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data.user?.name ??
                                                    "GPlus Author",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    ?.copyWith(
                                                      color: Constance
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              SizedBox(
                                                height: 0.7.h,
                                              ),
                                              Text(
                                                Jiffy(data.updated_at,
                                                            "yyyy-MM-dd")
                                                        .fromNow() ??
                                                    '${15} mins ago' ??
                                                    "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                      color: Colors.black45,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const Icon(
                                            Icons.menu,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    data.attachment?.isEmpty ?? false
                                        ? Container()
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: SizedBox(
                                              height: 25.h,
                                              width: double.infinity,
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Navigation.instance.goBack();
                                                  (data.attachment?.length ??
                                                              1) >
                                                          1
                                                      ? showAllImages(data)
                                                      : showThisImage(data
                                                              .attachment![0]
                                                              .file_name ??
                                                          Constance
                                                              .defaultImage);
                                                },
                                                child: (data.attachment
                                                                ?.length ??
                                                            1) >
                                                        1
                                                    ? StaggeredGrid.count(
                                                        crossAxisCount: 4,
                                                        mainAxisSpacing: 4,
                                                        crossAxisSpacing: 4,
                                                        children: [
                                                          for (int i = 0;
                                                              i <
                                                                  (data.attachment
                                                                          ?.length ??
                                                                      1);
                                                              i++)
                                                            StaggeredGridTile
                                                                .count(
                                                              crossAxisCellCount:
                                                                  (data.attachment?.length ??
                                                                              1) >=
                                                                          3
                                                                      ? 1
                                                                      : 2,
                                                              mainAxisCellCount:
                                                                  (data.attachment?.length ??
                                                                              1) >=
                                                                          4
                                                                      ? 1
                                                                      : 2,
                                                              child:
                                                                  CachedNetworkImage(
                                                                placeholder:
                                                                    (cont, _) {
                                                                  return Image
                                                                      .asset(
                                                                    Constance
                                                                        .logoIcon,
                                                                    // color: Colors.black,
                                                                  );
                                                                },
                                                                imageUrl: (data
                                                                        .attachment![
                                                                            i]
                                                                        .file_name) ??
                                                                    "",
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                errorWidget:
                                                                    (cont, _,
                                                                        e) {
                                                                  return Image
                                                                      .network(
                                                                    Constance
                                                                        .defaultImage,
                                                                    fit: BoxFit
                                                                        .fitWidth,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                        ],
                                                      )
                                                    : CachedNetworkImage(
                                                        placeholder: (cont, _) {
                                                          return Image.asset(
                                                            Constance.logoIcon,
                                                            // color: Colors.black,
                                                          );
                                                        },
                                                        imageUrl: data
                                                                .attachment![0]
                                                                .file_name ??
                                                            "",
                                                        fit: BoxFit.fitHeight,
                                                        errorWidget:
                                                            (cont, _, e) {
                                                          return Image.network(
                                                            Constance
                                                                .defaultImage,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Text(
                                      data.question ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            color: Colors.black,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    // Text(
                                    //   "",
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .headline5
                                    //       ?.copyWith(
                                    //         color: Colors.black,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    // ),
                                    SizedBox(
                                      height: 2.h,
                                      child: Center(
                                        child: Divider(
                                          thickness: 0.05.h,
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${data.total_liked} likes' ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            '${data.total_disliked} dislikes' ??
                                                "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            '${data.total_comment} comments' ??
                                                "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                      child: Center(
                                        child: Divider(
                                          thickness: 0.05.h,
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Material(
                                                type: MaterialType.transparency,
                                                child: IconButton(
                                                  onPressed: () {
                                                    postLike(data.id, 1);
                                                    _(() {
                                                      like = !like;
                                                      if (dislike) {
                                                        dislike = !like;
                                                      }
                                                    });
                                                    debugPrint('${like}');
                                                  },
                                                  splashRadius: 20.0,
                                                  splashColor: !like
                                                      ? Constance.secondaryColor
                                                      : Constance.primaryColor,
                                                  icon: Icon(
                                                    Icons.thumb_up,
                                                    color: like
                                                        ? Constance
                                                            .secondaryColor
                                                        : Constance
                                                            .primaryColor,
                                                  ),
                                                ),
                                              ),
                                              Material(
                                                type: MaterialType.transparency,
                                                child: IconButton(
                                                  onPressed: () {
                                                    postLike(data.id, 0);
                                                    _(() {
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
                                                        ? Constance
                                                            .secondaryColor
                                                        : Constance
                                                            .primaryColor,
                                                  ),
                                                ),
                                              ),
                                              Material(
                                                type: MaterialType.transparency,
                                                child: IconButton(
                                                  onPressed: () {
                                                    // setState(() {
                                                    //   if (expand) {
                                                    //     expand = false;
                                                    //   } else {
                                                    //     expand = true;
                                                    //   }
                                                    // });
                                                    // print(expand);
                                                    showComments(data);
                                                  },
                                                  splashRadius: 20.0,
                                                  splashColor:
                                                      Constance.secondaryColor,
                                                  icon: const Icon(
                                                    Icons.comment,
                                                    color:
                                                        Constance.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Padding(
                            //   padding: EdgeInsets.only(left: 15.w, right: 5.w),
                            //   child: ListView.builder(
                            //       physics: NeverScrollableScrollPhysics(),
                            //       shrinkWrap: true,
                            //       itemCount: data.comments.isNotEmpty
                            //           ? 1
                            //           : data.comments.length,
                            //       itemBuilder: (cont, ind) {
                            //         var current = data.comments[ind];
                            //         bool like = false, dislike = false;
                            //         return StatefulBuilder(
                            //             builder: (context, _) {
                            //           return Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.end,
                            //             children: [
                            //               SizedBox(
                            //                 width: double.infinity,
                            //                 child: Row(
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment
                            //                           .spaceBetween,
                            //                   children: [
                            //                     Text(
                            //                       current.name ?? "",
                            //                       style: Theme.of(context)
                            //                           .textTheme
                            //                           .headline5
                            //                           ?.copyWith(
                            //                             color: Constance
                            //                                 .primaryColor,
                            //                             fontWeight:
                            //                                 FontWeight.bold,
                            //                           ),
                            //                     ),
                            //                     // Icon(
                            //                     //   Icons.menu,
                            //                     //   color: Colors.black,
                            //                     // ),
                            //                   ],
                            //                 ),
                            //               ),
                            //               SizedBox(
                            //                 height: 1.h,
                            //               ),
                            //               Row(
                            //                 children: [
                            //                   Text(
                            //                     current.comment ?? "",
                            //                     style: Theme.of(context)
                            //                         .textTheme
                            //                         .headline6
                            //                         ?.copyWith(
                            //                           color: Colors.black,
                            //                           // fontWeight: FontWeight.bold,
                            //                         ),
                            //                   ),
                            //                 ],
                            //               ),
                            //               SizedBox(
                            //                 height: 1.h,
                            //               ),
                            //               // Text(
                            //               //   "",
                            //               //   style: Theme.of(context)
                            //               //       .textTheme
                            //               //       .headline5
                            //               //       ?.copyWith(
                            //               //         color: Colors.black,
                            //               //         fontWeight: FontWeight.bold,
                            //               //       ),
                            //               // ),
                            //               // SizedBox(
                            //               //   height: 1.h,
                            //               // ),
                            //               SizedBox(
                            //                 width: double.infinity,
                            //                 child: Row(
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment
                            //                           .spaceBetween,
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.center,
                            //                   children: [
                            //                     Row(
                            //                       children: [
                            //                         Material(
                            //                           type: MaterialType
                            //                               .transparency,
                            //                           child: IconButton(
                            //                             onPressed: () {
                            //                               postLike(
                            //                                   current.id, 1);
                            //                               _(() {
                            //                                 like = !like;
                            //                                 // if(dislike){
                            //                                 //   dislike = !like;
                            //                                 // }
                            //                               });
                            //                             },
                            //                             splashRadius: 20.0,
                            //                             splashColor: !like
                            //                                 ? Constance
                            //                                     .secondaryColor
                            //                                 : Constance
                            //                                     .primaryColor,
                            //                             icon: Icon(
                            //                               Icons.thumb_up,
                            //                               color: like
                            //                                   ? Constance
                            //                                       .secondaryColor
                            //                                   : Constance
                            //                                       .primaryColor,
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         Material(
                            //                           type: MaterialType
                            //                               .transparency,
                            //                           child: IconButton(
                            //                             onPressed: () {
                            //                               // postLike(current.id, 0);
                            //                             },
                            //                             splashRadius: 20.0,
                            //                             splashColor: Constance
                            //                                 .secondaryColor,
                            //                             icon: const Icon(
                            //                               Icons.comment,
                            //                               color: Constance
                            //                                   .primaryColor,
                            //                             ),
                            //                           ),
                            //                         ),
                            //                         // Material(
                            //                         //   type: MaterialType.transparency,
                            //                         //   child: IconButton(
                            //                         //     onPressed: () {},
                            //                         //     splashRadius:20.0,
                            //                         //     splashColor:
                            //                         //     Constance.secondaryColor,
                            //                         //     icon: const Icon(
                            //                         //       Icons.comment,
                            //                         //       color:
                            //                         //       Constance.primaryColor,
                            //                         //     ),
                            //                         //   ),
                            //                         // ),
                            //                       ],
                            //                     ),
                            //                     // Text(
                            //                     //   '${15} mins ago' ?? "",
                            //                     //   style: Theme.of(context)
                            //                     //       .textTheme
                            //                     //       .headline5
                            //                     //       ?.copyWith(
                            //                     //     color: Colors.black,
                            //                     //     fontWeight: FontWeight.bold,
                            //                     //   ),
                            //                     // ),
                            //                   ],
                            //                 ),
                            //               ),
                            //               SizedBox(
                            //                 width: double.infinity,
                            //                 child: Row(
                            //                   // mainAxisAlignment:
                            //                   //     MainAxisAlignment.spaceBetween,
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.center,
                            //                   children: [
                            //                     Text(
                            //                       '${current.like_count} likes' ??
                            //                           "",
                            //                       style: Theme.of(context)
                            //                           .textTheme
                            //                           .headline6
                            //                           ?.copyWith(
                            //                             color: Colors.black,
                            //                             fontWeight:
                            //                                 FontWeight.bold,
                            //                           ),
                            //                     ),
                            //                     SizedBox(
                            //                       width: 2.w,
                            //                     ),
                            //                     // Text(
                            //                     //   '${current.dislike_count} dislike' ??
                            //                     //       "",
                            //                     //   style: Theme.of(context)
                            //                     //       .textTheme
                            //                     //       .headline6
                            //                     //       ?.copyWith(
                            //                     //         color: Colors.black,
                            //                     //         fontWeight: FontWeight.bold,
                            //                     //       ),
                            //                     // ),
                            //                   ],
                            //                 ),
                            //               ),
                            //               // SizedBox(
                            //               //   height: 1.h,
                            //               // ),
                            //
                            //               SizedBox(
                            //                 height: 1.h,
                            //               ),
                            //             ],
                            //           );
                            //         });
                            //       }),
                            //   // child: Column(
                            //   //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   //   children: [],
                            //   // ),
                            // ),
                            // data.comments.length <= 1
                            //     ? Container()
                            //     : ExpansionTile(
                            //         title: Padding(
                            //           padding: EdgeInsets.only(left: 15.w),
                            //           child: Text(
                            //             "View ${data.comments.length - 1} Comments",
                            //             style: Theme.of(context)
                            //                 .textTheme
                            //                 .headline5
                            //                 ?.copyWith(
                            //                   color: Colors.black,
                            //                   fontWeight: FontWeight.bold,
                            //                 ),
                            //           ),
                            //         ),
                            //         iconColor: Colors.white,
                            //         collapsedIconColor: Colors.white,
                            //         children: [
                            //           Padding(
                            //             padding: EdgeInsets.only(left: 15.w),
                            //             child: ListView.builder(
                            //                 physics:
                            //                     NeverScrollableScrollPhysics(),
                            //                 shrinkWrap: true,
                            //                 itemCount: data.comments.length,
                            //                 itemBuilder: (cont, ind) {
                            //                   var current = data.comments[ind];
                            //                   return ind == 0
                            //                       ? Container()
                            //                       : SizedBox(
                            //                           width: 40.w,
                            //                           child: Column(
                            //                             crossAxisAlignment:
                            //                                 CrossAxisAlignment
                            //                                     .end,
                            //                             children: [
                            //                               SizedBox(
                            //                                 width:
                            //                                     double.infinity,
                            //                                 child: Row(
                            //                                   mainAxisAlignment:
                            //                                       MainAxisAlignment
                            //                                           .spaceBetween,
                            //                                   children: [
                            //                                     Text(
                            //                                       current.name ??
                            //                                           "",
                            //                                       style: Theme.of(
                            //                                               context)
                            //                                           .textTheme
                            //                                           .headline5
                            //                                           ?.copyWith(
                            //                                             color: Constance
                            //                                                 .primaryColor,
                            //                                             fontWeight:
                            //                                                 FontWeight.bold,
                            //                                           ),
                            //                                     ),
                            //                                     // Icon(
                            //                                     //   Icons.menu,
                            //                                     //   color: Colors.black,
                            //                                     // ),
                            //                                   ],
                            //                                 ),
                            //                               ),
                            //                               SizedBox(
                            //                                 height: 1.h,
                            //                               ),
                            //                               Row(
                            //                                 children: [
                            //                                   Text(
                            //                                     current.comment ??
                            //                                         "",
                            //                                     style: Theme.of(
                            //                                             context)
                            //                                         .textTheme
                            //                                         .headline6
                            //                                         ?.copyWith(
                            //                                           color: Colors
                            //                                               .black,
                            //                                           // fontWeight: FontWeight.bold,
                            //                                         ),
                            //                                   ),
                            //                                 ],
                            //                               ),
                            //                               SizedBox(
                            //                                 height: 1.h,
                            //                               ),
                            //                               // Text(
                            //                               //   "",
                            //                               //   style: Theme.of(context)
                            //                               //       .textTheme
                            //                               //       .headline5
                            //                               //       ?.copyWith(
                            //                               //         color: Colors.black,
                            //                               //         fontWeight: FontWeight.bold,
                            //                               //       ),
                            //                               // ),
                            //                               // SizedBox(
                            //                               //   height: 1.h,
                            //                               // ),
                            //                               SizedBox(
                            //                                 width:
                            //                                     double.infinity,
                            //                                 child: Row(
                            //                                   mainAxisAlignment:
                            //                                       MainAxisAlignment
                            //                                           .spaceBetween,
                            //                                   crossAxisAlignment:
                            //                                       CrossAxisAlignment
                            //                                           .center,
                            //                                   children: [
                            //                                     Row(
                            //                                       children: [
                            //                                         Material(
                            //                                           type: MaterialType
                            //                                               .transparency,
                            //                                           child:
                            //                                               IconButton(
                            //                                             onPressed:
                            //                                                 () {
                            //                                               postCommentLike(
                            //                                                   current.id,
                            //                                                   1);
                            //                                             },
                            //                                             splashRadius:
                            //                                                 20.0,
                            //                                             splashColor:
                            //                                                 Constance.secondaryColor,
                            //                                             icon:
                            //                                                 const Icon(
                            //                                               Icons
                            //                                                   .thumb_up,
                            //                                               color:
                            //                                                   Constance.primaryColor,
                            //                                             ),
                            //                                           ),
                            //                                         ),
                            //                                         Material(
                            //                                           type: MaterialType
                            //                                               .transparency,
                            //                                           child:
                            //                                               IconButton(
                            //                                             onPressed:
                            //                                                 () {
                            //                                               // postLike(current.id, 0);
                            //                                             },
                            //                                             splashRadius:
                            //                                                 20.0,
                            //                                             splashColor:
                            //                                                 Constance.secondaryColor,
                            //                                             icon:
                            //                                                 const Icon(
                            //                                               Icons
                            //                                                   .comment,
                            //                                               color:
                            //                                                   Constance.primaryColor,
                            //                                             ),
                            //                                           ),
                            //                                         ),
                            //                                         // Material(
                            //                                         //   type: MaterialType.transparency,
                            //                                         //   child: IconButton(
                            //                                         //     onPressed: () {},
                            //                                         //     splashRadius:20.0,
                            //                                         //     splashColor:
                            //                                         //     Constance.secondaryColor,
                            //                                         //     icon: const Icon(
                            //                                         //       Icons.comment,
                            //                                         //       color:
                            //                                         //       Constance.primaryColor,
                            //                                         //     ),
                            //                                         //   ),
                            //                                         // ),
                            //                                       ],
                            //                                     ),
                            //                                     // Text(
                            //                                     //   '${15} mins ago' ?? "",
                            //                                     //   style: Theme.of(context)
                            //                                     //       .textTheme
                            //                                     //       .headline5
                            //                                     //       ?.copyWith(
                            //                                     //     color: Colors.black,
                            //                                     //     fontWeight: FontWeight.bold,
                            //                                     //   ),
                            //                                     // ),
                            //                                   ],
                            //                                 ),
                            //                               ),
                            //                               SizedBox(
                            //                                 width:
                            //                                     double.infinity,
                            //                                 child: Row(
                            //                                   // mainAxisAlignment:
                            //                                   //     MainAxisAlignment.spaceBetween,
                            //                                   crossAxisAlignment:
                            //                                       CrossAxisAlignment
                            //                                           .center,
                            //                                   children: [
                            //                                     Text(
                            //                                       '${current.like_count} likes' ??
                            //                                           "",
                            //                                       style: Theme.of(
                            //                                               context)
                            //                                           .textTheme
                            //                                           .headline6
                            //                                           ?.copyWith(
                            //                                             color: Colors
                            //                                                 .black,
                            //                                             fontWeight:
                            //                                                 FontWeight.bold,
                            //                                           ),
                            //                                     ),
                            //                                     // SizedBox(
                            //                                     //   width: 2.w,
                            //                                     // ),
                            //                                     // Text(
                            //                                     //   '${current.dislike_count} dislike' ??
                            //                                     //       "",
                            //                                     //   style: Theme.of(context)
                            //                                     //       .textTheme
                            //                                     //       .headline6
                            //                                     //       ?.copyWith(
                            //                                     //     color: Colors.black,
                            //                                     //     fontWeight: FontWeight.bold,
                            //                                     //   ),
                            //                                     // ),
                            //                                   ],
                            //                                 ),
                            //                               ),
                            //                               // SizedBox(
                            //                               //   height: 1.h,
                            //                               // ),
                            //
                            //                               // Padding(
                            //                               //   padding: EdgeInsets.symmetric(
                            //                               //       horizontal: 2.w),
                            //                               //   child: GestureDetector(
                            //                               //     onTap: () {},
                            //                               //     child: Card(
                            //                               //       color: Colors.white,
                            //                               //       child: Padding(
                            //                               //         padding: EdgeInsets.symmetric(
                            //                               //             horizontal: 5.w,
                            //                               //             vertical: 1.h),
                            //                               //         child: Row(
                            //                               //           mainAxisAlignment:
                            //                               //               MainAxisAlignment
                            //                               //                   .spaceBetween,
                            //                               //           crossAxisAlignment:
                            //                               //               CrossAxisAlignment.center,
                            //                               //           children: [
                            //                               //             Text(
                            //                               //               'Write a comment',
                            //                               //               style: Theme.of(context)
                            //                               //                   .textTheme
                            //                               //                   .bodyText2
                            //                               //                   ?.copyWith(
                            //                               //                     color: Colors.black,
                            //                               //                   ),
                            //                               //             ),
                            //                               //             const Icon(
                            //                               //               Icons.link,
                            //                               //               color: Colors.black,
                            //                               //             ),
                            //                               //           ],
                            //                               //         ),
                            //                               //       ),
                            //                               //     ),
                            //                               //   ),
                            //                               // ),
                            //                               SizedBox(
                            //                                 height: 1.h,
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         );
                            //                 }),
                            //           )
                            //         ],
                            //       ),
                            // SizedBox(
                            //   height: 1.h,
                            // ),
                          ],
                        );
                      });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        child: Divider(
                          thickness: 0.07.h,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void showDialogBox() {
    Storage.instance.setGuwahatiConnect();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Guwahati Connect',
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Constance.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.radio,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Hello ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.name}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                  ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                  ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                  ' remaining essentially unchanged',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchGuwahatiConnect() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
    } else {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
    }
  }

  void postLike(id, is_like) async {
    final response =
        await ApiProvider.instance.postLike(id, is_like, 'guwahati-connect');
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: response.message ?? "Post Liked");
      // fetchGuwahatiConnect();
    } else {
      showError("Something went wrong");
    }
  }

  void postCommentLike(id, is_like) async {
    final response = await ApiProvider.instance.postCommentLike(id, is_like);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Post Liked");
      fetchGuwahatiConnect();
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

  void postComment(int? id, String s, String text) async {
    final response = await ApiProvider.instance.postComment(id, s, text);
    if (response.success ?? false) {
      fetchGuwahatiConnect();
      _searchQueryController.text = '';
    } else {}
  }

  void checkIt() async {
    if (Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .profile
            ?.is_plan_active ??
        false) {
      Navigation.instance.navigate('/askAQuestion');
    } else {
      scaffoldKey.currentState?.showBottomSheet(
        (context) {
          return Consumer<DataProvider>(builder: (context, data, _) {
            return StatefulBuilder(builder: (context, _) {
              return Container(
                padding: EdgeInsets.only(
                    top: 1.h, right: 5.w, left: 5.w, bottom: 1.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                width: double.infinity,
                // height: 50.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigation.instance.goBack();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Text(
                      'Oops!',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: Constance.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 34.sp,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      'Sorry ${data.profile?.name}',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      '''Projected to be a smart city by 2025, Guwahati is a
major port on the banks of Brahmaputra, the capital
of Assam and the urban hub of the North East. This
metropolitan city is growing leaps and bounds, and 
for its unparalleled pace of growth, comes the need
for an unparalleled publication, that people call their''',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Do you want to be a member?',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: CustomButton(
                            txt: 'Yes, take me there',
                            onTap: () {
                              Navigation.instance.navigate('/beamember');
                            },
                            size: 12.sp,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Flexible(
                          child: CustomButton(
                            txt: '''No, I don't want it''',
                            onTap: () {
                              Navigation.instance.goBack();
                            },
                            color: Colors.black,
                            size: 12.sp,
                            fcolor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
          });
        },
        // context: context,
        backgroundColor: Colors.grey.shade100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
      );
    }
  }

  showAllImages(data) {
    scaffoldKey.currentState?.showBottomSheet((context) {
      return Card(
        elevation: 3,
        color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 2.h),
          height: 70.h,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: data.attachment?.length ?? 1,
            itemBuilder: (context, count) {
              var current = data.attachment![count];
              return GestureDetector(
                onTap: () {
                  Navigation.instance.navigate('/viewImage',
                      args: current.file_name ?? Constance.defaultImage);
                },
                child: CachedNetworkImage(
                  placeholder: (cont, _) {
                    return Image.asset(
                      Constance.logoIcon,
                      // color: Colors.black,
                    );
                  },
                  imageUrl: current.file_name ?? Constance.defaultImage,
                  fit: BoxFit.fitHeight,
                  errorWidget: (cont, _, e) {
                    return Image.network(
                      Constance.defaultImage,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 2.h,
              );
            },
          ),
        ),
      );
    }, enableDrag: true);
  }

  showThisImage(String s) {
    Navigation.instance.navigate('/viewImage', args: s);
  }

  void showComments(data) {
    scaffoldKey.currentState?.showBottomSheet((context) {
      return Card(
        elevation: 3,
        color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          // side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 3.h),
          height: 70.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Comments",
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        ?.copyWith(
                      color: Constance
                          .primaryColor,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 55.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.comments.length,
                      itemBuilder: (cont, ind) {
                        var current = data.comments[ind];
                        return SizedBox(
                          height: 16.h,
                          width: 40.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      current.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            color: Constance.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    // Icon(
                                    //   Icons.menu,
                                    //   color: Colors.black,
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                    current.comment ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              // Text(
                              //   "",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .headline5
                              //       ?.copyWith(
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              // ),
                              // SizedBox(
                              //   height: 1.h,
                              // ),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Material(
                                          type: MaterialType.transparency,
                                          child: IconButton(
                                            onPressed: () {
                                              postCommentLike(current.id, 1);
                                            },
                                            splashRadius: 20.0,
                                            splashColor: Constance.secondaryColor,
                                            icon: const Icon(
                                              Icons.thumb_up,
                                              color: Constance.primaryColor,
                                            ),
                                          ),
                                        ),
                                        Material(
                                          type: MaterialType.transparency,
                                          child: IconButton(
                                            onPressed: () {
                                              // postLike(current.id, 0);
                                            },
                                            splashRadius: 20.0,
                                            splashColor: Constance.secondaryColor,
                                            icon: const Icon(
                                              Icons.comment,
                                              color: Constance.primaryColor,
                                            ),
                                          ),
                                        ),
                                        // Material(
                                        //   type: MaterialType.transparency,
                                        //   child: IconButton(
                                        //     onPressed: () {},
                                        //     splashRadius:20.0,
                                        //     splashColor:
                                        //     Constance.secondaryColor,
                                        //     icon: const Icon(
                                        //       Icons.comment,
                                        //       color:
                                        //       Constance.primaryColor,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    // Text(
                                    //   '${15} mins ago' ?? "",
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .headline5
                                    //       ?.copyWith(
                                    //     color: Colors.black,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${current.like_count} likes' ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    // SizedBox(
                                    //   width: 2.w,
                                    // ),
                                    // Text(
                                    //   '${current.dislike_count} dislike' ??
                                    //       "",
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .headline6
                                    //       ?.copyWith(
                                    //     color: Colors.black,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 1.h,
                              // ),

                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 2.w),
                              //   child: GestureDetector(
                              //     onTap: () {},
                              //     child: Card(
                              //       color: Colors.white,
                              //       child: Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: 5.w,
                              //             vertical: 1.h),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment
                              //                   .spaceBetween,
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.center,
                              //           children: [
                              //             Text(
                              //               'Write a comment',
                              //               style: Theme.of(context)
                              //                   .textTheme
                              //                   .bodyText2
                              //                   ?.copyWith(
                              //                     color: Colors.black,
                              //                   ),
                              //             ),
                              //             const Icon(
                              //               Icons.link,
                              //               color: Colors.black,
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 1.h,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 0.5.h),
                      child: TextField(
                        controller: _searchQueryController,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: "Write a comment",
                          border: InputBorder.none,
                          hintStyle: const TextStyle(color: Colors.black26),
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (_searchQueryController.text.isNotEmpty) {
                                // search(_searchQueryController.text);
                                postComment(data.id, 'guwahati-connect',
                                    _searchQueryController.text);
                              } else {
                                showError('Enter something to search');
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.black),
                        onChanged: (query) => {},
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
