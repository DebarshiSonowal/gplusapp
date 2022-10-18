import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/custom_button.dart';
import '../../Components/slider_home.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
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
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    Container(
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
                                child: Opacity(
                                  opacity: 0.85,
                                  child: CachedNetworkImage(
                                    imageUrl: e.value.file_name ?? "",
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth,
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
                                        fit: BoxFit.fitWidth,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        carouselController: _controller,
                        options: CarouselOptions(
                            autoPlay: false,
                            // enlargeCenterPage: true,
                            // aspectRatio: 16/9,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                    ),
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
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.white)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  data.selectedClassified?.title ?? '2BHK for Rent',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Constance.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Posted by ${data.selectedClassified?.user_id}',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  'Rs: ${data.selectedClassified?.price}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Constance.thirdColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
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
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 5.h,
                        child: Text(
                          '4999 views',
                          // overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  data.selectedClassified?.description ??
                      'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                          ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                          ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                          ' remaining essentially unchanged',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Call ${data.selectedClassified?.id}',
                      onTap: () {
                        showDialogBox();
                      }),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
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
