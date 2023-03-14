import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/classified_post_image.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class ClassifiedDetails extends StatefulWidget {
  final int id;

  ClassifiedDetails(this.id);

  @override
  State<ClassifiedDetails> createState() => _ClassifiedDetailsState();
}

class _ClassifiedDetailsState extends State<ClassifiedDetails> {
  var current = 4;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool like = false;
  var f = NumberFormat("###,###", "en_US");

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchDetails());
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar("classified", true, _scaffoldKey),
      drawer: const BergerMenuMemPage(screen: "classified"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 95.h,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        // height: .h,
                        width: MediaQuery.of(context).size.width,
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: [
                          ClassifiedPostImageWidget(
                            data: data,
                            controller: _controller,
                            updatePage: (index) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      logTheAddToFavouritesClick(
                                        Provider.of<DataProvider>(
                                                Navigation.instance.navigatorKey
                                                        .currentContext ??
                                                    context,
                                                listen: false)
                                            .profile!,
                                        data.selectedClassified!.title!,
                                        data.selectedClassified!.description!,
                                        data.selectedClassified!.locality!.name!
                                            .toLowerCase(),
                                        data.selectedClassified!.total_views!,
                                      );
                                      setAsFavourite(
                                          data.selectedClassified?.id,
                                          'classified');
                                      setState(() {
                                        like = !like;
                                      });
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.solidHeart,
                                      color: like
                                          ? Constance.secondaryColor
                                          : Colors.grey.shade400,
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: data
                                      .selectedClassified!.attach_files!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                (Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.white)
                                                    .withOpacity(
                                                        _current == entry.key
                                                            ? 0.8
                                                            : 0.4)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                (data.selectedClassified?.is_post_by_me ??
                                        false)
                                    ? PopupMenuButton<int>(
                                        color: Constance.secondaryColor,
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuItem<int>>[
                                          PopupMenuItem<int>(
                                            value: 1,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.edit,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  'Edit',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 2,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.delete,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  'Delete',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onSelected: (int value) {
                                          if (value == 1) {
                                            updateClassified(widget.id);
                                          } else {
                                            deleteClassified(widget.id);
                                          }
                                        },
                                        // color: Colors.white,
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          data.selectedClassified?.title ?? '2BHK for Rent',
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(
                                  color: Storage.instance.isDarkMode
                                      ? Colors.white
                                      : Constance.primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          'Posted by ${data.selectedClassified?.user?.name ?? "Anonymous"}',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          'Rs: ${f.format(data.selectedClassified?.price?.toInt())}',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Constance.thirdColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Storage.instance.isDarkMode
                                  ? Constance.secondaryColor
                                  : Colors.black54,
                              size: 15.sp,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              data.selectedClassified?.locality?.name ??
                                  'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                              // overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 1.h,
                      // ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              color: Storage.instance.isDarkMode
                                  ? Constance.secondaryColor
                                  : Colors.black54,
                              size: 15.sp,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              '${data.selectedClassified?.total_views} views',
                              // overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monitor,
                              color: Storage.instance.isDarkMode
                                  ? Constance.secondaryColor
                                  : Colors.black54,
                              size: 15.sp,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              getStatusText(
                                  data.selectedClassified?.status ?? 0),
                              // overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: getStatusColour(
                                        data.selectedClassified?.status ?? 0),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ReadMoreText(
                          data.selectedClassified?.description ??
                              'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                                  ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                                  ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                                  ' remaining essentially unchanged',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                  ),
                          trimLines: 5,
                          colorClickableText: Constance.secondaryColor,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Show more',
                          trimExpandedText: 'Show less',
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),

                      // SizedBox(
                      //   height: 1.5.h,
                      // ),
                    ],
                  ),
                ),
              ),
              (data.selectedClassified?.user == null ||
                      data.selectedClassified?.user_id == data.profile!.id)
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                            size:
                                ((data.selectedClassified?.user?.name!.length ??
                                            0) <
                                        25)
                                    ? 13.sp
                                    : 11.sp,
                            txt: 'Contact',
                            onTap: () {
                              if (data.profile?.is_plan_active ?? false) {
                                showDisclaimer(
                                  data.selectedClassified?.disclaimer ?? "",
                                  data.selectedClassified?.user?.mobile,
                                );
                              } else {
                                Constance.showMembershipPrompt(context, () {});
                              }
                              // showDialogBox();
                            }),
                      ),
                    ),
            ],
          );
        }),
      ),
      bottomNavigationBar: CustomNavigationBar(current, "classified"),
    );
  }

  showDisclaimer(String msg, number) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: SizedBox(
              // height: 15.h,
              // width: 5.w,
              child: Image.asset(
                Constance.disclaimerIcon,
                fit: BoxFit.contain,
                scale: 8,
              ),
            ),
            contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 8),
            actionsPadding: const EdgeInsets.only(left: 16, right: 16),
            content: Text(
              msg,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.black,
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigation.instance.goBack();
                },
                child: Text(
                  "Go Back",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigation.instance.goBack();
                  _launchUrl(Uri.parse('tel:$number'));
                },
                child: Text(
                  "I accept",
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Constance.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     // leading: IconButton(
  //     //   onPressed: () {
  //     //     Navigation.instance.navigate('/bergerMenuMem');
  //     //   },
  //     //   icon: Icon(Icons.menu),
  //     // ),
  //     title: GestureDetector(
  //       onTap: () {
  //         Provider.of<DataProvider>(
  //                 Navigation.instance.navigatorKey.currentContext ?? context,
  //                 listen: false)
  //             .setCurrent(0);
  //         Navigation.instance.navigate('/main');
  //       },
  //       child: Image.asset(
  //         Constance.logoIcon,
  //         fit: BoxFit.fill,
  //         scale: 2,
  //       ),
  //     ),
  //     centerTitle: true,
  //     backgroundColor: Constance.primaryColor,
  //     actions: [
  //       IconButton(
  //         onPressed: () {
  //           Navigation.instance.navigate('/notification');
  //         },
  //         icon: Consumer<DataProvider>(builder: (context, data, _) {
  //           return Badge(
  //             badgeColor: Constance.secondaryColor,
  //             badgeContent: Text(
  //               '${data.notifications.length}',
  //               style: Theme.of(context).textTheme.headline5?.copyWith(
  //                     color: Constance.thirdColor,
  //                   ),
  //             ),
  //             child: const Icon(Icons.notifications),
  //           );
  //         }),
  //       ),
  //       IconButton(
  //         onPressed: () {},
  //         icon: Icon(Icons.search),
  //       ),
  //     ],
  //   );
  // }

  void showDialogBox() {
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
            'Post your listing',
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
                  FontAwesomeIcons.newspaper,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Hello Jonathan!',
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  fetchDetails() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getClassifiedDetails(widget.id);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setClassifiedDetails(response.classifieds!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  void setAsFavourite(int? id, String type) async {
    final response = await ApiProvider.instance.setAsFavourite(id, type);
    if (response.success ?? false) {
      Fluttertoast.showToast(msg: "Added to favourites");
    } else {
      showError("Something went wrong");
    }
  }

  void showError(String msg) {
    AlertX.instance.showAlert(
        title: "Not Subscribed",
        msg: msg,
        positiveButtonText: "Done",
        positiveButtonPressed: () {
          Navigation.instance.goBack();
        });
  }

  void updateClassified(id) {
    Navigation.instance.navigate('/editingAListing', args: id);
  }

  String getStatusText(int i) {
    switch (i) {
      case 1:
        return 'Accepted';
      case 2:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  Color getStatusColour(int i) {
    switch (i) {
      case 1:
        return Colors.green;
      case 2:
        return Constance.thirdColor;
      default:
        return Constance.primaryColor;
    }
  }

  void deleteClassified(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.deleteClassified(id);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }

  void logTheAddToFavouritesClick(
    Profile profile,
    String title,
    String field_entered,
    String locality,
    int views,
  ) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "add_to_favourites",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "title": title,
        "field_entered": field_entered,
        "locality": locality,
        "screen_name": "classified",
        "views": views,
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }
}
