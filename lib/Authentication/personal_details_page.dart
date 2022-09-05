import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../Components/alert.dart';
import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  var first_name = TextEditingController();
  var last_name = TextEditingController();
  var email = TextEditingController();
  var date = '';
  int year = 2000;
  int max = 2022;
  int currentY = 2022;
  String dropdownvalue = 'Male';
  double longitude = 0, latitude = 0;

  // List of items in our dropdown menu
  var items = [
    'Male',
    'Women',
    'Others',
  ];

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
        year = currentY - 18;
        max = currentY + 18;
      });
      getLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
                    initialDate: DateTime(currentY),
                    firstDate: DateTime(year),
                    lastDate: DateTime(max),
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
              Row(
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
              SizedBox(
                height: 1.5.h,
              ),
              Row(
                children: [
                  Text(
                    'Khanapara, Guwahati',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          // fontSize: 2.h,
                          fontSize: 11.sp,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Constance.primaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
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
                    Navigation.instance.navigateAndReplace('/enterPreferences');
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

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
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

  void getLocations() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        final position = await _determinePosition();
        longitude = position.longitude;
        latitude = position.latitude;
        if (mounted) {
          setState(() {});
        }
      } else {
        showError("We require Location permissions");
      }
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {}
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
