import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/custom_button.dart';
import '../../Components/slider_home.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // height: .h,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
                      // height: 2.h,
                      padding: EdgeInsets.only(top: 0.h),
                      color: Colors.grey.shade200,
                      width: MediaQuery.of(context).size.width,
                      // height: 40.h,
                      child: CarouselSlider(
                        items: data.selectedClassified?.attach_files
                            ?.asMap()
                            .entries
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  Navigation.instance.navigate('/viewImage',
                                      args: e.value.file_name ??
                                          Constance.defaultImage);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: e.value.file_name ?? "",
                                  width: double.infinity,
                                  // height: 35.h,
                                  fit: BoxFit.fill,
                                  // filterQuality: FilterQuality.low,
                                  placeholder: (cont, _) {
                                    return Image.asset(
                                      Constance.logoIcon,
                                      // color: Colors.black,
                                    );
                                  },
                                  errorWidget: (cont, _, e) {
                                    return Image.network(
                                      Constance.defaultImage,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                        carouselController: _controller,
                        options: CarouselOptions(
                            autoPlay: false,
                            enlargeCenterPage: true,
                            // aspectRatio: 1,
                            viewportFraction: 0.9,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
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
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.solidHeart,
                                color: Colors.grey.shade400,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: data.selectedClassified!.attach_files!
                                .asMap()
                                .entries
                                .map((entry) {
                              return GestureDetector(
                                onTap: () => _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.white)
                                          .withOpacity(
                                              _current == entry.key ? 0.8 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                          PopupMenuButton<int>(
                            color:Constance.secondaryColor,
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
                                          ?.copyWith(color: Colors.black),
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
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (int value) {
                              setState(() {});
                            },
                            // color: Colors.white,
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
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
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Storage.instance.isDarkMode ? Colors.white :Constance.primaryColor,
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
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode ? Colors.white70 :Colors.black,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'Rs: ${data.selectedClassified?.price}',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Icon(
                        Icons.location_on,
                        color: Storage.instance.isDarkMode ? Constance.secondaryColor :Colors.black,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 5.h,
                          child: Text(
                            data.selectedClassified?.locality?.name ??
                                'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                            // overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Storage.instance.isDarkMode ? Colors.white :Colors.black,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 1.h,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Storage.instance.isDarkMode ? Constance.secondaryColor :Colors.black,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 5.h,
                          child: Text(
                            '${data.selectedClassified?.total_views} views',
                            // overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Storage.instance.isDarkMode ? Colors.white :Colors.black,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: ReadMoreText(
                    data.selectedClassified?.description ??
                        'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                            ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                            ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                            ' remaining essentially unchanged',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode ? Colors.white70 :Colors.black,
                          // fontWeight: FontWeight.bold,
                        ),
                    trimLines: 5,
                    colorClickableText: Constance.secondaryColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                data.selectedClassified?.user == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                              txt:
                                  'Call ${data.selectedClassified?.user?.name ?? "Anonymous"}',
                              onTap: () {
                                // showDialogBox();
                                _launchUrl(Uri.parse(
                                    'tel:${data.selectedClassified?.user?.mobile}'));
                              }),
                        ),
                      ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
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
          onPressed: () {},
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

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
}
