import 'dart:async';

import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:webview_flutter/webview_flutter.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchContactUs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar2(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.call,
                    color: Constance.secondaryColor,
                    size: 3.5.h,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'Contact Us',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                width: double.infinity,
                height: 25.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                    //                   <--- border color
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                ),
                child: WebView(
                  initialUrl: Uri.dataFromString(
                          '<html><body><iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3580.6220674969863!2d91.75290802615376!3d26.176435144780122!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x375a598111600481%3A0xb90bf25d769e96f7!2sG%20Plus!5'
                          'e0!3m2!1sen!2sin!4v1664103997060!5m2!1sen!2sin" '
                          'width="1000" height="600" style="border:0;" allowfullscreen="true" '
                          'loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe></body></html>',
                          mimeType: 'text/html')
                      .toString(),
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Storage.instance.isDarkMode
                        ? Constance.secondaryColor
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      ('${data.contactUs?.address1},${data.contactUs?.address2},${data.contactUs?.address3}') ??
                          'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
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
                    Icons.edit,
                    color: Storage.instance.isDarkMode
                        ? Constance.secondaryColor
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Editor',
                          // overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                        ),
                        Text(
                          data.contactUs?.editor ?? 'Sunit Jain',
                          // overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        :Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
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
                    Icons.phone,
                    color: Storage.instance.isDarkMode
                        ? Constance.secondaryColor
                        :Colors.black,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        var url = Uri.parse('tel:+${data.contactUs?.phone!}');
                        UrlLauncher.launchUrl(url);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone',
                            // overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Colors.black,
                                    ),
                          ),
                          Text(
                            data.contactUs?.phone ?? '+91 874647856',
                            // overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
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
                    Icons.email,
                    color: Storage.instance.isDarkMode
                        ? Constance.secondaryColor
                        :Colors.black,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        var url = Uri.parse('mailto:${data.contactUs?.email}');
                        UrlLauncher.launchUrl(url);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            // overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Colors.black,
                                    ),
                          ),
                          Text(
                            data.contactUs?.email ?? 'info@g-plus.in',
                            // overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          :Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
            Navigation.instance.navigate('/search',args: "");
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

  void fetchContactUs() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getContactUs();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setContactUs(response.contactUs!);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
    }
  }

  void setLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: LatLng(26.1764316, 91.7568453),
              zoom: 15,
            ),
          ),
        )
        .then((value) => print('hello'));
    final MarkerId markerId = MarkerId('0');

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(26.1764316, 91.7568453),
      infoWindow: InfoWindow(title: 'G Plus', snippet: '*'),
      onTap: () {},
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }
}
