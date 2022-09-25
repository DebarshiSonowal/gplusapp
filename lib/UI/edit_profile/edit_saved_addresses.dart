import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_place/google_place.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';

class EditSavedAddresses extends StatefulWidget {
  const EditSavedAddresses({Key? key}) : super(key: key);

  @override
  State<EditSavedAddresses> createState() => _EditSavedAddressesState();
}

class _EditSavedAddressesState extends State<EditSavedAddresses> {
  final _searchQueryController = TextEditingController();
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  String locationName = "";

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
  }

  @override
  void initState() {
    // String apiKey = DotEnv().env['API_KEY'];
    googlePlace = GooglePlace(Constance.googleApiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
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
                        color: Constance.primaryColor,
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
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: Colors.black),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
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
                  : SizedBox(
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
                                      color: Colors.black,
                                    ),
                          ),
                          onTap: () {
                            debugPrint(predictions[index].placeId);
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
                  color: Colors.black,
                  thickness: 0.4.sp,
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigation.instance.navigate('/locationSearchPage');
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
                                    color: Colors.black,
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
                                    color: Colors.black38,
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
                  color: Colors.black,
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Home',
                          style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 3.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      'Royal Arcade, Kasturba Nagar, Ulubaria, Guwhahti, 781003',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      height: 1.h,
                      child: Divider(
                        color: Colors.black,
                        thickness: 0.4.sp,
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Other',
                          style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 3.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      'Royal Arcade, Kasturba Nagar, Ulubaria, Guwhahti, 781003',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      height: 1.h,
                      child: Divider(
                        color: Colors.black,
                        thickness: 0.4.sp,
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Other',
                          style:
                              Theme.of(context).textTheme.headline3?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 3.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      'Royal Arcade, Kasturba Nagar, Ulubaria, Guwhahti, 781003',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    SizedBox(
                      height: 1.h,
                      child: Divider(
                        color: Colors.black,
                        thickness: 0.4.sp,
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'See more',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Constance.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
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

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
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
  }
}
