import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class EditAddressPage extends StatefulWidget {
  final count;

  EditAddressPage(this.count);

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Consumer<DataProvider>(builder: (context, data, _) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
                width: double.infinity,
                child: GoogleMap(
                  indoorViewEnabled: true,
                  mapType: MapType.normal,
                  markers: markers.values.toSet(),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(
                          data.addresses![widget.count].latitude.toString()),
                      double.parse(
                          data.addresses![widget.count].longitude.toString()),
                    ),
                    zoom: 14.4746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    final marker = Marker(
                      markerId:
                          MarkerId(data.addresses![widget.count].title ?? ""),
                      position: LatLng(
                        double.parse(
                            data.addresses![widget.count].latitude.toString()),
                        double.parse(
                            data.addresses![widget.count].longitude.toString()),
                      ),
                      // icon: BitmapDescriptor.,
                      infoWindow: InfoWindow(
                        title: data.addresses![widget.count].title ?? 'title',
                        snippet:
                            data.addresses![widget.count].address ?? 'address',
                      ),
                    );

                    setState(() {
                      markers[MarkerId(data.addresses![widget.count].title ?? "")] = marker;
                    });
                  },
                  onLongPress: (loc){
                    final marker = Marker(
                      markerId:
                      MarkerId("new Location"),
                      position: loc,
                      // icon: BitmapDescriptor.,
                      infoWindow: InfoWindow(
                        title: data.addresses![widget.count].title ?? 'title',
                        snippet:
                        data.addresses![widget.count].address ?? 'address',
                      ),
                    );

                    setState(() {
                      markers[MarkerId('place_name')] = marker;
                    });
                  },
                ),
              ),
              Container(
                color:
                    Storage.instance.isDarkMode ? Colors.black : Colors.white,
                width: double.infinity,
                height: 30.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Location',
                      // overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${data.addresses![widget.count].title}',
                          // overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'change',
                          // overflow: TextOverflow.clip,
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Constance.thirdColor,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Text(
                        '${data.addresses![widget.count].address}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                      width: double.infinity,
                      child: CustomButton(
                        txt: 'Confirm Location',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
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
}
