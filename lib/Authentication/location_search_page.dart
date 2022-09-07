import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../Helper/Constance.dart';
import '../Helper/Storage.dart';
import '../Navigation/Navigate.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({Key? key}) : super(key: key);

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  TextEditingController searchController = TextEditingController();
  var locationName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 12),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                  onPressed: Navigation.instance.goBack,
                  icon: Icon(
                    Icons.close,
                    color: Constance.primaryColor,
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GooglePlaceAutoCompleteTextField(
                      textEditingController: searchController,
                      googleAPIKey: Constance.googleApiKey,
                      inputDecoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide:
                                BorderSide(color: Colors.grey.shade200)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide:
                                BorderSide(color: Colors.grey.shade200)),
                        contentPadding:
                            const EdgeInsets.only(left: 16, right: 16),
                        hintText: "Search Location",
                      ),
                      countries: const ["in"],
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (Prediction prediction) async {
                        Storage.instance.signUpdata?.latitude =
                            double.parse(prediction.lat ?? "0");
                        Storage.instance.signUpdata?.longitude =
                            double.parse(prediction.lng ?? "0");
                        getAddress(
                            prediction.lat ?? "0", prediction.lng ?? "0");
                        // final result = await Navigation.instance.navigate("/locationSelect",args: LatLng(double.parse(prediction.lat ?? "0"), double.parse(prediction.lng ?? "0")));
                      },
                      itmClick: (Prediction prediction) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
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
    String address =
        "${(street.isEmpty) ? "" : "$street, "}${(thoroughfare.isEmpty) ? "" : "$thoroughfare, "}${(locality.isEmpty) ? "" : "$locality, "}${(subLocality.isEmpty) ? "" : "$subLocality, "}${(state.isEmpty) ? "" : "$state, "}${(pincode.isEmpty) ? "" : "$pincode."}";
    locationName = address;
    print('city pincode ${pincode}  ${street}');
    // setState(() {});
    Navigator.pop(Navigation.instance.navigatorKey.currentContext ?? context,
        locationName);
  }
}
