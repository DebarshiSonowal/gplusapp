import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Components/alert.dart';
import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Model/profile.dart';
import '../Model/temp.dart';
import '../Navigation/Navigate.dart';

class PersonalDetailsPage extends StatefulWidget {
  final int mobile;

  const PersonalDetailsPage(this.mobile);

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final first_name = TextEditingController();
  final last_name = TextEditingController();
  final email = TextEditingController();
  final refer = TextEditingController();
  var date = '';
  int year = 1800;
  int max = 2022;
  int currentY = 2022;
  int currentM = 1;
  int currentD = 1;
  String dropdownvalue = 'Male';
  double longitude = 0, latitude = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of items in our dropdown menu
  var items = [
    'Male',
    'Female',
    'Others',
  ];

  var address = "";

  String address_id = "0";

  @override
  void dispose() {
    super.dispose();
    first_name.dispose();
    last_name.dispose();
    email.dispose();
  }

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
        final M = DateFormat('MM');
        currentM = int.parse(M.format(current));
        final D = DateFormat('yyyy');
        currentD = int.parse(D.format(current));
        year = 1800;
        max = currentY;
      });

      getLocationsWithoutLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar("personal_details", false, _scaffoldKey),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.all(6.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Personal Details',
                style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Constance.primaryColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      fontSize: 11.sp,
                    ),
                controller: first_name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter First Name',
                  labelStyle: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.5.h,
                        fontSize: 11.sp,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      fontSize: 11.sp,
                    ),
                controller: last_name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter Last Name',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 11.sp,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      fontSize: 11.sp,
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
                        fontSize: 11.sp,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Add your date of birth',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.5.h,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              GestureDetector(
                onTap: () async {
                  var datePicked = await DatePicker.showSimpleDatePicker(
                    context,
                    initialDate: DateTime(currentY, currentM, currentD),
                    firstDate: DateTime(year, 1, 1),
                    lastDate: DateTime(max, 12, 31),
                    dateFormat: "dd-MMMM-yyyy",
                    itemTextStyle:
                        Theme.of(context).textTheme.headline6?.copyWith(
                              color: Constance.primaryColor,
                              // fontSize: 1.6.h,
                              fontWeight: FontWeight.bold,
                            ),
                    locale: DateTimePickerLocale.en_us,
                    looping: true,
                  );
                  if (datePicked != null) {
                    setState(() {
                      date =
                          "${datePicked?.day}-${datePicked?.month}-${datePicked?.year}";
                    });
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 2.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade700,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              date == '' ? '' : '${date.split('-')[0]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.black,
                                    // fontSize: 2.h,
                                    fontSize: 11.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: 1.w, top: 0.5.h, bottom: .5.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.5.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                ),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 2.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade700,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              date == '' ? '' : '${date.split('-')[1]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.black,
                                    // fontSize: 2.h,
                                    fontSize: 11.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: 1.w, top: 0.5.h, bottom: .5.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.5.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                ),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 2.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade700,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              date == '' ? '' : '${date.split('-')[2]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.black,
                                    // fontSize: 2.h,
                                    fontSize: 11.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: 1.w, top: 0.5.h, bottom: .5.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.5.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                ),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: Colors.black,
                      //     ),
                      //     borderRadius: BorderRadius.circular(5.0),
                      //   ),
                      //   child: Text(
                      //     date == '' ? '' : date.split('-')[1],
                      //     style:
                      //         Theme.of(context).textTheme.headline5?.copyWith(
                      //               color: Colors.black,
                      //               // fontSize: 2.h,
                      //               // fontWeight: FontWeight.bold,
                      //             ),
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: Colors.black,
                      //     ),
                      //     borderRadius: BorderRadius.circular(5.0),
                      //   ),
                      //   child: Text(
                      //     date == '' ? '' : date.split('-')[2],
                      //     style:
                      //         Theme.of(context).textTheme.headline5?.copyWith(
                      //               color: Colors.black,
                      //               // fontSize: 2.h,
                      //               // fontWeight: FontWeight.bold,
                      //             ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'Gender',
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 2.5.h,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: 25.w,
                  // height: 10.h,
                  child: DropdownButtonFormField2(
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    isExpanded: false,

                    buttonHeight: 5.h,
                    buttonWidth: 20.w,
                    buttonPadding:
                        EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                    buttonDecoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade700,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.black,
                                    // fontSize: 2.h,
                                    fontSize: 11.sp,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
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
                height: 1.h,
              ),
              Text(
                'Enter referral code (if any)',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      fontSize: 11.sp,
                    ),
                controller: refer,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter referral code',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.5.h,
                        fontSize: 11.sp,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'The data can be changed in your profile later',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 1.6.h,
                      fontSize: 9.sp,
                      // fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                'All the data fields are mandatory for registration',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Constance.thirdColor,
                      // fontSize: 1.6.h,
                      fontSize: 9.sp,
                      // fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 4.h,
              ),
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: CustomButton(
                  txt: 'Save & Continue',
                  onTap: () {
                    if (first_name.text.isNotEmpty &&
                        last_name.text.isNotEmpty) {
                      if (email.text.isNotEmpty &&
                          isValidEmail(email.text.trim())) {
                        if (date != "") {
                          if (
                              // address != "" &&
                              //     latitude != 0 &&
                              //     longitude != 0
                              true) {
                            logTheSignupFlowClick();
                            setData(
                                widget.mobile,
                                first_name.text,
                                last_name.text,
                                email.text,
                                date,
                                address,
                                refer.text ?? "");
                          } else {
                            showError(
                                "Please select your location", null, null);
                          }
                        } else {
                          showError("Enter your birth date", null, null);
                        }
                      } else {
                        showError("Enter an actual email address", null, null);
                      }
                    } else {
                      showError("Enter the names correctly", null, null);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logTheSignupFlowClick() async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "sign_up_flow",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": "NA",
        "screen_name": "register",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": "NA",
      },
    );
  }

  bool isValidEmail(email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
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
      debugPrint('got locations ${longitude} ${latitude}');
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
        });
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

  void setData(mobile, fname, lname, email, dob, address, refer) {
    Storage.instance.setSignUpData(
      temp(mobile, fname, lname, email, dob, address, longitude, latitude,
          address_id, dropdownvalue, refer),
    );

    debugPrint("${Storage.instance.signUpdata?.mobile}");
    debugPrint("${Storage.instance.signUpdata?.f_name}");
    // Navigation.instance.navigate('/enterPreferences');
    signUp();
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

  void signUp() async {
    Navigation.instance.navigate("/loadingDialog");
    final reponse = await ApiProvider.instance.createProfile(
        '0',
        Storage.instance.signUpdata?.mobile,
        Storage.instance.signUpdata?.f_name,
        Storage.instance.signUpdata?.l_name,
        Storage.instance.signUpdata?.email,
        Storage.instance.signUpdata?.dob,
        Storage.instance.signUpdata?.address,
        Storage.instance.signUpdata?.longitude,
        Storage.instance.signUpdata?.latitude,
        "",
        "",
        0,
        0,
        0,
        Storage.instance.signUpdata?.gender,
        Storage.instance.signUpdata?.refer,
        1);
    if (reponse.success ?? false) {
      // setPreferences();

      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(reponse.profile!);
      debugPrint("Profile Created ${reponse.profile!.id}");
      // logTheSignUpSuccessClick("",
      //     "", reponse.profile!);
      Navigation.instance.navigateAndReplace('/main');
    } else {
      // showError(reponse.msg ?? "Something went wrong");
      Navigation.instance.goBack();
      AlertX.instance.showAlert(
          title: "Error",
          msg: reponse.msg ?? "Something went wrong",
          positiveButtonText: "Done",
          positiveButtonPressed: () {
            Navigation.instance.goBack();
            Navigation.instance.goBack();
          });
    }
  }
}
