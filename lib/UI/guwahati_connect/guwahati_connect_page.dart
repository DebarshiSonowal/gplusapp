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

class GuwahatiConnectPage extends StatefulWidget {
  const GuwahatiConnectPage({Key? key}) : super(key: key);

  @override
  State<GuwahatiConnectPage> createState() => _GuwahatiConnectPageState();
}

class _GuwahatiConnectPageState extends State<GuwahatiConnectPage> {
  int current = 2;

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
      drawer: BergerMenuMemPage(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigation.instance.navigate('/askAQuestion');
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
                                              child: CachedNetworkImage(
                                                placeholder: (cont, _) {
                                                  return Image.asset(
                                                    Constance.logoIcon,
                                                    // color: Colors.black,
                                                  );
                                                },
                                                imageUrl: data.attachment![0]
                                                        .file_name ??
                                                    "",
                                                fit: BoxFit.fill,
                                                errorWidget: (cont, _, e) {
                                                  return Image.network(
                                                    Constance.defaultImage,
                                                    fit: BoxFit.fitWidth,
                                                  );
                                                },
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
                                                     if(dislike){
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
                                                      if(like){
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
                                        hintStyle: const TextStyle(
                                            color: Colors.black26),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            if (_searchQueryController
                                                .text.isNotEmpty) {
                                              // search(_searchQueryController.text);
                                              postComment(
                                                  data.id,
                                                  'guwahati-connect',
                                                  _searchQueryController.text);
                                            } else {
                                              showError(
                                                  'Enter something to search');
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
                            SizedBox(
                              height: 1.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, right: 5.w),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.comments.isNotEmpty
                                      ? 1
                                      : data.comments.length,
                                  itemBuilder: (cont, ind) {
                                    var current = data.comments[ind];
                                    bool like = false, dislike = false;
                                    return StatefulBuilder(
                                      builder: (context,_) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
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
                                                          color: Constance
                                                              .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            postLike(current.id, 1);
                                                            _((){
                                                              like = !like;
                                                              // if(dislike){
                                                              //   dislike = !like;
                                                              // }
                                                            });
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
                                                        type: MaterialType
                                                            .transparency,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            // postLike(current.id, 0);

                                                          },
                                                          splashRadius: 20.0,
                                                          splashColor: Constance
                                                              .secondaryColor,
                                                          icon: const Icon(
                                                            Icons.comment,
                                                            color: Constance
                                                                .primaryColor,
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${current.like_count} likes' ??
                                                        "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  // Text(
                                                  //   '${current.dislike_count} dislike' ??
                                                  //       "",
                                                  //   style: Theme.of(context)
                                                  //       .textTheme
                                                  //       .headline6
                                                  //       ?.copyWith(
                                                  //         color: Colors.black,
                                                  //         fontWeight: FontWeight.bold,
                                                  //       ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 1.h,
                                            // ),

                                            SizedBox(
                                              height: 1.h,
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  }),
                              // child: Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [],
                              // ),
                            ),
                            data.comments.length <= 1
                                ? Container()
                                : ExpansionTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(left: 15.w),
                                      child: Text(
                                        "View ${data.comments.length - 1} Comments",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    iconColor: Colors.white,
                                    collapsedIconColor: Colors.white,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.w),
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: data.comments.length,
                                            itemBuilder: (cont, ind) {
                                              var current = data.comments[ind];
                                              return ind == 0
                                                  ? Container()
                                                  : SizedBox(
                                                      width: 40.w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  current.name ??
                                                                      "",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline5
                                                                      ?.copyWith(
                                                                        color: Constance
                                                                            .primaryColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                                                current.comment ??
                                                                    "",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6
                                                                    ?.copyWith(
                                                                      color: Colors
                                                                          .black,
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
                                                            width:
                                                                double.infinity,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Material(
                                                                      type: MaterialType
                                                                          .transparency,
                                                                      child:
                                                                          IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          postCommentLike(
                                                                              current.id,
                                                                              1);
                                                                        },
                                                                        splashRadius:
                                                                            20.0,
                                                                        splashColor:
                                                                            Constance.secondaryColor,
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .thumb_up,
                                                                          color:
                                                                              Constance.primaryColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Material(
                                                                      type: MaterialType
                                                                          .transparency,
                                                                      child:
                                                                          IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          // postLike(current.id, 0);
                                                                        },
                                                                        splashRadius:
                                                                            20.0,
                                                                        splashColor:
                                                                            Constance.secondaryColor,
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .comment,
                                                                          color:
                                                                              Constance.primaryColor,
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
                                                            width:
                                                                double.infinity,
                                                            child: Row(
                                                              // mainAxisAlignment:
                                                              //     MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  '${current.like_count} likes' ??
                                                                      "",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6
                                                                      ?.copyWith(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
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
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: 1.h,
                            ),
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
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
      Navigation.instance.goBack();
    } else {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
      Navigation.instance.goBack();
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
}
