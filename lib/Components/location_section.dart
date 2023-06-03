
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';

class LocationSection extends StatelessWidget {
  final DataProvider data;
  final Function onTap;
  const LocationSection({
    Key? key,
    required this.data, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 10.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Constance.secondaryColor,
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                'Location',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Colors.white,
                  // fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          GestureDetector(
            onTap: () {
              onTap();
              Navigation.instance.navigate('/editSavedAddresses', args: 1);
            },
            child: Row(
              children: [
                SizedBox(
                  width: 8.w,
                ),
                SizedBox(
                  width: 45.w,
                  child: Text(
                      getAddress(),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontSize: 11.sp,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getAddress() {
    if(data.profile==null){
      return "";
    }
    if(data.profile!.addresses.isEmpty){
      return "";
    }
    return data.profile?.addresses
        .where((element) => element.is_primary == 1)
        .isEmpty ??
        false
        ? data.profile?.addresses.first.address ?? ""
        : data.profile?.addresses
        .where((element) => element.is_primary == 1)
        .first
        .address ??
        '';
  }
}