import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
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

  String locationName = '';
  double lat = 0, lang = 0;

  final _textFieldController = TextEditingController();

  String title = "";

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
          child: SingleChildScrollView(
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
                          double.parse(data.addresses![widget.count].latitude
                              .toString()),
                          double.parse(data.addresses![widget.count].longitude
                              .toString()),
                        ),
                        // icon: BitmapDescriptor.,
                        infoWindow: InfoWindow(
                          title: data.addresses![widget.count].title ?? 'title',
                          snippet: data.addresses![widget.count].address ??
                              'address',
                        ),
                      );

                      setState(() {
                        markers[MarkerId(
                                data.addresses![widget.count].title ?? "")] =
                            marker;
                      });
                    },
                    onLongPress: (loc) {
                      final marker = Marker(
                        markerId: MarkerId("new Location"),
                        position: loc,
                        // icon: BitmapDescriptor.,
                        infoWindow: InfoWindow(
                          title: data.addresses![widget.count].title ?? 'title',
                          snippet: data.addresses![widget.count].address ??
                              'address',
                        ),
                      );

                      setState(() {
                        markers.clear();
                        markers[MarkerId('place_name')] = marker;
                        lat = loc.latitude;
                        lang = loc.longitude;
                      });
                      getAddress(loc.latitude, loc.longitude);
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
                            '${title == "" ? data.addresses![widget.count].title : title}',
                            // overflow: TextOverflow.clip,
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      // fontWeight: FontWeight.bold,
                                    ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _displayTextInputDialog(context);
                            },
                            child: Text(
                              'change',
                              // overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Constance.thirdColor,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Text(
                          '${locationName == "" ? data.addresses![widget.count].address : locationName}',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
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
                          onTap: () {
                            if (lat != 0 ||
                                lang != 0 ||
                                locationName != "" ||
                                title != "") {
                              updateNewAddress(
                                  locationName == ""
                                      ? data.addresses![widget.count].address
                                      : locationName,
                                  lat == 0
                                      ? data.addresses![widget.count].latitude
                                      : lat,
                                  lang == 0
                                      ? data.addresses![widget.count].longitude
                                      : lang,
                                  data.addresses![widget.count].id,
                                  title == ""
                                      ? data.addresses![widget.count].title
                                      : title);
                            } else {
                              showError("Must change Location");
                            }
                          },
                        ),
                      ),
                      Platform.isAndroid ? Container() : SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
          icon: Consumer<DataProvider>(builder: (context, data, _) {
            return Badge(
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
            Navigation.instance.navigate('/search');
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    String valueText = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor:
                !Storage.instance.isDarkMode ? Colors.white : Colors.black,
            title: Text(
              'Enter the title of the location',
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
            ),
            content: TextField(
              cursorColor:
                  Storage.instance.isDarkMode ? Colors.white : Colors.black,
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
              decoration: InputDecoration(
                hintText: "Enter a name",
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  // textColor: Colors.white,
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.white),
                  fixedSize: const Size.fromWidth(100),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  // textColor: Colors.white,
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.white),
                  fixedSize: const Size.fromWidth(100),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    title = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> getAddress(latitude, longitude) async {
    Navigation.instance.navigate('/loadingDialog');
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    String street = place.street ?? "";
    String thoroughfare = place.thoroughfare ?? "";
    String locality = place.locality ?? "";
    String subLocality = place.subLocality ?? "";
    String state = place.subAdministrativeArea ?? "";
    String pincode = place.postalCode ?? "";
    String address =
        "${(street.isEmpty) ? "" : "$street, "}${(thoroughfare.isEmpty) ? "" : "$thoroughfare, "}${(locality.isEmpty) ? "" : "$locality, "}${(subLocality.isEmpty) ? "" : "$subLocality, "}${(state.isEmpty) ? "" : "$state, "}${(pincode.isEmpty) ? "" : "$pincode."}";
    locationName = address;
    print('city pincode ${pincode}  ${street}');
    // setState(() {});
    // Navigator.pop(Navigation.instance.navigatorKey.currentContext ?? context,
    //     locationName);

    Navigation.instance.goBack();
  }

  void updateNewAddress(add, lat, lang, id, title) async {
    Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.updateAddress(add, lat, lang, id, title);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
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
