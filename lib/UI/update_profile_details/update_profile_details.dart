import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Model/topick.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class UpdateProfileDetails extends StatefulWidget {
  const UpdateProfileDetails({super.key});

  @override
  State<UpdateProfileDetails> createState() => _UpdateProfileDetailsState();
}

class _UpdateProfileDetailsState extends State<UpdateProfileDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var referralCode = TextEditingController();
  var date = 'DOB', address = "", address_id = "0", id = '0';
  bool agreed = false;
  double longitude = 0, latitude = 0;
  List<GeoTopick> selGeo = [];
  int year = 2000;
  int max = 2023;
  int currentY = 2023;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        var current = DateTime.now();
        final f = DateFormat('dd-MM-yyyy');
        date = f.format(current);
        final y = DateFormat('yyyy');
        currentY = int.parse(y.format(current));
        year = currentY - 18;
        max = currentY + 18;
      });
      fetchTopicks();
      fetchAddress();
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("profile"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 6.w,
          vertical: 1.5.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create Your Account',
                style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      // fontSize: 2.5.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Container(
                padding: !Storage.instance.isDarkMode
                    ? const EdgeInsets.all(0)
                    : EdgeInsets.symmetric(vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: firstName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Enter First Name',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.5.h,
                        ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Container(
                padding: !Storage.instance.isDarkMode
                    ? const EdgeInsets.all(0)
                    : EdgeInsets.symmetric(vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: lastName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Enter Last Name',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.5.h,
                        ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Container(
                padding: !Storage.instance.isDarkMode
                    ? const EdgeInsets.all(0)
                    : EdgeInsets.symmetric(vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Enter Email',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.5.h,
                        ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Container(
                padding: !Storage.instance.isDarkMode
                    ? const EdgeInsets.all(0)
                    : EdgeInsets.symmetric(
                        vertical: 0.5.h,
                        horizontal: 2.w,
                      ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 7.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 2.5.w,
                      ),
                      Text(
                        date ?? "DOB",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.black,
                              // fontSize: 1.6.h,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Container(
                padding: !Storage.instance.isDarkMode
                    ? const EdgeInsets.all(0)
                    : EdgeInsets.symmetric(vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.6.h,
                      ),
                  controller: referralCode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Enter Referral Code',
                    labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.5.h,
                        ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.w,
                      width: 2.h,
                      child: Checkbox(
                          fillColor:
                              MaterialStateProperty.all(Colors.grey.shade300),
                          checkColor: Colors.black,
                          value: agreed,
                          onChanged: (val) {
                            setState(() {
                              agreed = val!;
                            });
                          }),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'I Accept All The Terms and Conditions',
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.black,
                            fontSize: 11.sp,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  showLocationSelectDialog();
                },
                child: Row(
                  children: [
                    Text(
                      'Location',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: Constance.primaryColor,
                            // fontSize: 2.5.h,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Icon(
                      Icons.location_on,
                      color: Constance.secondaryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              GestureDetector(
                onTap: () async {
                  // getLocations();
                  showLocationSelectDialog();
                },
                child: Row(
                  children: [
                    SizedBox(
                      // height: 5.h,
                      width: 40.w,
                      child: Text(
                        address == '' ? 'Please Select one address' : address,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Constance.primaryColor,
                              // fontSize: 2.h,
                              fontSize: 10.sp,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Constance.primaryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Text(
                    'Change your News interests',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor,
                          // fontSize: 2.h,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Text(
                    'Geographical',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Constance.primaryColor,
                          // fontSize: 2.h,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Consumer<DataProvider>(builder: (context, data, _) {
                return SizedBox(
                  // height: 15.h,
                  width: double.infinity,
                  child: Wrap(
                    children: [
                      for (int i = 0; i < data.geoTopicks.length; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!check(selGeo, data.geoTopicks[i])) {
                                selGeo.add(data.geoTopicks[i]);
                              } else {
                                // selGeo.remove(data.geoTopicks[i]);
                                selGeo.removeWhere((element) =>
                                    element.id == data.geoTopicks[i].id);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: selGeo == null
                                  ? Colors.white
                                  : !check(selGeo, data.geoTopicks[i])
                                      ? Colors.white
                                      : Constance.secondaryColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: selGeo == null
                                    ? Constance.primaryColor
                                    : !check(selGeo, data.geoTopicks[i])
                                        ? Constance.primaryColor
                                        : Constance.secondaryColor,
                                width: 0.5.w,
                                // left: BorderSide(
                                //   color: Colors.green,
                                //   width: 1,
                                // ),
                              ),
                            ),
                            child: Text(
                              data.geoTopicks[i].title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Constance.primaryColor,
                                    // fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constance.secondaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                      ),
                    ),
                    onPressed: () {
                      if (agreed) {
                        if (firstName.text.isNotEmpty &&
                            lastName.text.isNotEmpty &&
                            email.text.isNotEmpty &&
                            date != "") {
                          if (address != "") {
                            signUp(
                                context,
                                firstName.text,
                                lastName.text,
                                email.text,
                                date,
                                referralCode.text,
                                address_id,
                                Provider.of<DataProvider>(context,
                                            listen: false)
                                        .profile
                                        ?.mobile ??
                                    "");
                          } else {
                            Fluttertoast.showToast(
                                msg: "Enter the address details");
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Enter the details properly");
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "You have to agree to our terms and conditions");
                      }
                    },
                    child: Text(
                      'SIGN UP',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Constance.secondaryColor,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'CANCEL',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
      if (mounted) {
        setState(() {
          id = response.addresses
              .firstWhere((element) => element.is_primary == 1)
              .id
              .toString();
        });
      } else {
        id = response.addresses
            .firstWhere((element) => element.is_primary == 1)
            .id
            .toString();
      }
      debugPrint(id);
    } else {
      Navigation.instance.goBack();
    }
  }

  void showLocationSelectDialog() {
    Dialogs.materialDialog(
        msg: 'Where do you live?',
        title: "Address",
        color: Colors.white,
        context: context,
        titleStyle: Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.black,
            ),
        msgStyle: Theme.of(context).textTheme.headline5!.copyWith(
              color: Colors.black,
            ),
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigation.instance.goBack();
              getLocations();
            },
            color: Constance.thirdColor,
            text: 'Current Location',
            iconData: Icons.gps_fixed,
            textStyle: const TextStyle(
              color: Colors.white,
            ),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () async {
              Navigation.instance.goBack();
              final result =
                  await Navigation.instance.navigate('/locationSearchPage');
              if (result != null && result != "") {
                setState(() {
                  address = result;
                });
                findLocation(address);
              }
            },
            text: 'Search',
            iconData: Icons.exit_to_app,
            color: Constance.primaryColor,
            textStyle: const TextStyle(
              color: Colors.white,
            ),
            iconColor: Colors.white,
          ),
        ]);
  }

  bool check(List<dynamic> list1, dynamic list2) {
    for (var i in list1) {
      if (i.id == list2.id) {
        return true;
      }
    }
    return false;
  }

  void getLocations() async {
    showLoaderDialog(context);
    debugPrint('got locations1');
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        debugPrint('got1 locations1');
        final position = await _determinePositionAgain();
        longitude = position.longitude;
        latitude = position.latitude;
        debugPrint('got locations ${longitude} ${latitude}');
        if (mounted) {
          setState(() {});
        }
        getAddress(position.latitude, position.longitude);
      } else {
        Navigation.instance.goBack();
        showError(
            "Please enable permissions for G Plus application from settings",
            () {
          OpenSettings.openAppSetting();
        }, "We require Location permissions");
      }
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      debugPrint('got1 locations1');
      final position = await _determinePositionAgain();
      longitude = position.longitude;
      latitude = position.latitude;
      debugPrint('got locations ${longitude} ${latitude}');
      if (mounted) {
        setState(() {});
      }
      getAddress(position.latitude, position.longitude);
    }
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

  void getLocationsWithoutLoader() async {
    // showLoaderDialog(context);
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
        getAddressNoGoBack(position.latitude, position.longitude);
      } else {
        // Navigation.instance.goBack();
        showError(
            "Please enable permissions for G Plus application from settings",
            () {
          OpenSettings.openAppSetting();
        }, "We require Location permissions");
      }
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      debugPrint('got1 locations1');
      final position = await _determinePosition();
      longitude = position.longitude;
      latitude = position.latitude;
      debugPrint('got locations $longitude $latitude');
      if (mounted) {
        setState(() {});
      }
      getAddressNoGoBack(position.latitude, position.longitude);
    }
  }

  void showError(String msg, Function? onTap, String? title) {
    AlertX.instance.showAlert(
      title: title ?? "Error",
      msg: msg,
      positiveButtonText: "Done",
      positiveButtonPressed: () {
        if (onTap == null) {
          Navigation.instance.goBack();
        } else {
          Navigation.instance.goBack();
          onTap();
        }
      },
      negativeButtonPressed: () {
        Navigation.instance.goBack();
      },
      negativeButtonText: "Cancel",
    );
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
    String address1 =
        "${(street.isEmpty) ? "" : "$street, "}${(thoroughfare.isEmpty) ? "" : "$thoroughfare, "}${(locality.isEmpty) ? "" : "$locality, "}${(subLocality.isEmpty) ? "" : "$subLocality, "}${(state.isEmpty) ? "" : "$state, "}${(pincode.isEmpty) ? "" : "$pincode."}";

    debugPrint('city pincode ${pincode}  ${street}');
    setState(() {
      address = address1;
    });
    Navigation.instance.goBack();
  }

  Future<void> getAddressNoGoBack(latitude, longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    String street = place.street ?? "";
    String thoroughfare = place.thoroughfare ?? "";
    String locality = place.locality ?? "";
    String subLocality = place.subLocality ?? "";
    String state = place.subAdministrativeArea ?? "";
    String pincode = place.postalCode ?? "";
    String address1 =
        "${(street.isEmpty) ? "" : "$street, "}${(thoroughfare.isEmpty) ? "" : "$thoroughfare, "}${(locality.isEmpty) ? "" : "$locality, "}${(subLocality.isEmpty) ? "" : "$subLocality, "}${(state.isEmpty) ? "" : "$state, "}${(pincode.isEmpty) ? "" : "$pincode."}";

    debugPrint('city pincode ${pincode}  ${street}');
    setState(() {
      address = address1;
    });
    // Navigation.instance.goBack();
  }

  void findLocation(String? address) async {
    List<geo.Location> locations = await locationFromAddress(address!);
    // var result1 = await googleGeocoding.geocoding.get(address ?? "", []);
    // debugPrint(result1?.results?.length.toString());
    latitude = locations[0].latitude ?? 0;
    longitude = locations[0].longitude ?? 0;
    // addAddress(address);
  }

  void addAddress(String? address) async {
    final response =
        await ApiProvider.instance.postAddress(address, latitude, longitude);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAddressess(response.addresses);
      address_id = response.addresses.last.id.toString();
      // Navigator.of(context).pop(response.addresses.last.id);
    } else {
      // showError("Something went wrong");
    }
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
      // Navigation.instance.goBack();
      showError("Please Enable Location Services from Settings", () {
        OpenSettings.openLocationSourceSetting();
      }, "Location Services");
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
        // Navigation.instance.goBack();
        showError(
            "Please enable permissions for G Plus application from settings",
            () {
          OpenSettings.openAppSetting();
        }, "We require Location permissions");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // Navigation.instance.goBack();
      showError(
          "Please enable permissions for G Plus application from settings", () {
        OpenSettings.openAppSetting();
      }, "We require Location permissions");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> _determinePositionAgain() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      debugPrint('got locations2');
      Navigation.instance.goBack();
      showError("Please Enable Location Services from Settings", () {
        OpenSettings.openLocationSourceSetting();
      }, "Location Services");
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
        Navigation.instance.goBack();
        showError(
            "Please enable permissions for G Plus application from settings",
            () {
          OpenSettings.openAppSetting();
        }, "We require Location permissions");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Navigation.instance.goBack();
      showError(
          "Please enable permissions for G Plus application from settings", () {
        OpenSettings.openAppSetting();
      }, "We require Location permissions");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void fetchTopicks() async {
    // showLoaderDialog(context);
    final response = await ApiProvider.instance.getTopicks();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setTopicks(response.topicks);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGeoTopicks(response.geoTopicks);
    }
  }

  void fetchData() {
    final data = Provider.of<DataProvider>(context, listen: false).profile;
    if ((data?.f_name?.isNotEmpty ?? false) && (data?.f_name != "")) {
      firstName.text = data?.f_name ?? "";
    }
    if ((data?.l_name?.isNotEmpty ?? false) && (data?.l_name != "")) {
      lastName.text = data?.l_name ?? "";
    }
    if ((data?.email?.isNotEmpty ?? false) && (data?.email != "")) {
      email.text = data?.email ?? "";
    }
    setState(() {});
  }

  void signUp(BuildContext context, String fname, String lname, String email,
      String date, String referal, String address_id, String mobile) async {
    Navigation.instance.navigate("/loadingDialog");
    final response = await ApiProvider.instance.updateProfile(
      address_id,
      mobile,
      fname,
      lname,
      email,
      date,
      address,
      longitude,
      latitude,
      null,
      getComaSeparated(selGeo),
      true,
      true,
      true,
      null,
      referal,
      null,
    );
    if (response.success ?? false) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "You're all set");
      fetchProfile();
    } else {
      // Navigator.pop(context);
      Fluttertoast.showToast(msg: "Please Try Again");
    }
  }

  Future<void> fetchProfile() async {
    debugPrint('object profile');
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getprofile();
    if (response.success ?? false) {

      debugPrint('object profile');
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(response.profile!);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyTopicks(response.topicks);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGeoTopicks(response.geoTopicks);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setFloatingButton(response.floating_button!);
      Navigation.instance.goBack();
      // initUniLinks();
      // initUniLinksResume();
    } else {
      // Navigation.instance.goBack();
    }
  }
  String getComaSeparated(List<dynamic> list) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (i == 0) {
        temp = '${list[i].id.toString()},';
      } else {
        temp += '${list[i].id.toString()},';
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
  }

}
