import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_place/google_place.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Navigation/Navigate.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({Key? key}) : super(key: key);

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  TextEditingController searchController = TextEditingController();
  var locationName = '';
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    // String apiKey = DotEnv().env['API_KEY'];
    googlePlace = GooglePlace(Constance.googleApiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Container(
          // color: Colors.white,
          padding: const EdgeInsets.only(bottom: 12, top: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: Navigation.instance.goBack,
                    icon: Icon(
                      Icons.close,
                      color: Constance.primaryColor,
                    ),
                  ),
                  Container(
                    // height: 10.h,
                    width: 80.w,
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
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
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
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    var data = predictions[index];
                    return ListTile(
                      onTap: () async {
                        DetailsResponse? current =
                            await googlePlace.details.get(data.placeId!);
                        debugPrint(current?.result?.reference);
                        // var googleGeocoding =
                        //     GoogleGeocoding(Constance.googleApiKey);
                        // var result = await googleGeocoding.geocoding
                        //     .get(current?.result?.formattedAddress ?? "", []);
                        // result?.result[0].geometry.location?.lat
                        Navigator.pop(
                            Navigation.instance.navigatorKey.currentContext ??
                                context,
                            current?.result?.formattedAddress);
                        // getAddress(data);
                      },
                      leading: const CircleAvatar(
                        backgroundColor: Constance.primaryColor,
                        child: Icon(
                          Icons.pin_drop,
                          color: Constance.secondaryColor,
                        ),
                      ),
                      title: Text(
                        predictions[index].description ?? "",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                      // onTap: () {
                      //   debugPrint(predictions[index].placeId);
                      // },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
    // searchController.text = locationName;
    Navigator.pop(Navigation.instance.navigatorKey.currentContext ?? context,
        locationName);
  }
}
