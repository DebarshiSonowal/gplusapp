import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
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
                      color: Constance.primaryColor,
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
                  color: Colors.black26, //                   <--- border color
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
              ),
              child: const GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
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
                      'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                      // overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
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
                const Icon(
                  Icons.edit,
                  color: Colors.black,
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
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        'Sunit Jain',
                        // overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.black,
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
                const Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      var url = Uri.parse('tel:+${0874647856}');
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
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          '+91 874647856',
                          // overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.black,
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
                const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      var url = Uri.parse('mailto:${'info@g-plus.in'}');
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
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'info@g-plus.in',
                          // overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.black,
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
        ),
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
}
