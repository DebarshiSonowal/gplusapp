import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';

// import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_place/google_place.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class EditSavedAddresses extends StatefulWidget {
  final int which;

  const EditSavedAddresses({super.key, required this.which});

  @override
  State<EditSavedAddresses> createState() => _EditSavedAddressesState();
}

class _EditSavedAddressesState extends State<EditSavedAddresses> {
  final _searchQueryController = TextEditingController();
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  String locationName = "";
  double longitude = 0, latitude = 0;

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
  }

  @override
  void initState() {
    // String apiKey = DotEnv().env['API_KEY'];

    googlePlace = GooglePlace(Platform.isAndroid
        ? FlutterConfig.get('androidMapKey')
        : FlutterConfig.get('iosMapKey'));

    super.initState();
    Future.delayed(Duration.zero, () {
      fetchAddress();
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("profile"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Icon(
                    Icons.location_on,
                    color: Constance.secondaryColor,
                    size: 3.5.h,
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Container(
                // height: 10.h,
                width: double.infinity,
                child: Center(
                  child: TextField(
                    controller: _searchQueryController,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black),
                    cursorColor: Storage.instance.isDarkMode
                        ? Colors.white
                        : Constance.primaryColor,
                    decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Storage.instance.isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Storage.instance.isDarkMode
                              ? Colors.white70
                              : Colors.black54,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Storage.instance.isDarkMode
                              ? Colors.white70
                              : Colors.black54,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      } else {
                        if (predictions.length > 0 && mounted) {
                          setState(() {
                            predictions = [];
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
              predictions.isEmpty
                  ? Container()
                  : const SizedBox(
                      height: 10,
                    ),
              predictions.isEmpty
                  ? Container()
                  : ListView.builder(

                      shrinkWrap: true,
                      itemCount: predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Constance.primaryColor,
                            child: Icon(
                              Icons.pin_drop,
                              color: Constance.secondaryColor,
                            ),
                          ),
                          title: Text(
                            predictions[index].description ?? "",
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                          ),
                          onTap: () async {
                            debugPrint(predictions[index].placeId);
                            var data = await googlePlace.details
                                .get(predictions[index].placeId!);
                            debugPrint(
                                'desc ${predictions[index].description}');
                            findLocation(predictions[index].description);
                            // addAddress(predictions[index].placeId);
                          },
                        );
                      },
                    ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color:
                      Storage.instance.isDarkMode ? Colors.white : Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              GestureDetector(
                onTap: () {
                  getLocations();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.gps_fixed,
                      color: Constance.thirdColor,
                      size: 3.5.h,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Current Location',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          'Using GPS',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black38,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              SizedBox(
                height: 1.h,
                child: Divider(
                  color:
                      Storage.instance.isDarkMode ? Colors.white : Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'Saved Addresses',
                style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: Constance.thirdColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Consumer<DataProvider>(builder: (context, data, _) {
                return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (cont, count) {
                      var current = data.addresses![count];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(current.id);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  current.title ?? 'Home',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      ?.copyWith(
                                        color: Storage.instance.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await Navigation.instance
                                            .navigate('/editAddress',
                                                args: count);
                                        if (result == null) {
                                          fetchAddress();
                                        }
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Storage.instance.isDarkMode
                                            ? Constance.secondaryColor
                                            : Colors.black,
                                        size: 3.h,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        deleteAddress(current.id!);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Constance.thirdColor,
                                        size: 3.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              current.address ??
                                  'Royal Arcade, Kasturba Nagar, Ulubaria, Guwhahti, 781003',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Storage.instance.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (cont, count) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 1.5.h,
                          ),
                          SizedBox(
                            height: 1.h,
                            child: Divider(
                              color: Storage.instance.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              thickness: 0.4.sp,
                            ),
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                        ],
                      );
                    },
                    itemCount: data.addresses?.length ?? 0);
              }),
            ],
          ),
        ),
      ),
    );
  }

  // AppBar buildAppBar() {
  //   return AppBar(
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
  //                 color: Constance.thirdColor,
  //               ),
  //             ),
  //             child: const Icon(Icons.notifications),
  //           );
  //         }),
  //       ),
  //       IconButton(
  //         onPressed: () {
  //           Navigation.instance.navigate('/search',args: "");
  //         },
  //         icon: Icon(Icons.search),
  //       ),
  //     ],
  //   );
  // }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
      // addAddress();
    } else {
      print(result);
    }
  }

  void getLocations() async {
    showLoaderDialog(context);
    debugPrint('got locations1');
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        debugPrint('got1 locations1');
        final position = await _determinePosition();
        longitude = position.longitude;
        latitude = position.latitude;
        debugPrint('got locations ${longitude} ${latitude}');
        if (mounted) {
          setState(() {});
        }
        getAddress(position.latitude, position.longitude);
      } else {
        Navigation.instance.goBack();
        showError("We require Location permissions");
      }
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      debugPrint('got1 locations1');
      final position = await _determinePosition();
      longitude = position.longitude;
      latitude = position.latitude;
      debugPrint('got locations ${longitude} ${latitude}');
      if (mounted) {
        setState(() {});
      }
      getAddress(position.latitude, position.longitude);
    }
  }

  Future<void> getAddress(latitude, longitude) async {
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
    addAddress(address);
    Navigation.instance.goBack();
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      debugPrint('got locations2');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void fetchAddress() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getAddress();
    if (response.success ?? false) {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAddressess(response.addresses);
    } else {
      Navigation.instance.goBack();
    }
  }

  void addAddress(String? address) async {
    Navigation.instance.navigate('/loadingDialog');
    final response =
        await ApiProvider.instance.postAddress(address, latitude, longitude);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAddressess(response.addresses);
      Navigation.instance.goBack();
      if (widget.which == 0) {
        Navigator.of(context).pop(response.addresses.last.id);
      }
    } else {
      Navigation.instance.goBack();
      showError("Something went wrong");
    }
  }

  void findLocation(String? address) async {
    List<geo.Location> locations = await locationFromAddress(address!);
    // var result1 = await googleGeocoding.geocoding.get(address ?? "", []);
    // debugPrint(result1?.results?.length.toString());
    latitude = locations[0].latitude ?? 0;
    longitude = locations[0].longitude ?? 0;
    addAddress(address);
    setState(() {
      predictions = [];
      _searchQueryController.text = "";
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        color: Colors.white,
        child: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(
                "Loading...",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteAddress(int i) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.deleteAddress(i);
    if (response.success ?? false) {
      Navigation.instance.goBack();
      fetchAddress();
    } else {
      Navigation.instance.goBack();
    }
  }
}
