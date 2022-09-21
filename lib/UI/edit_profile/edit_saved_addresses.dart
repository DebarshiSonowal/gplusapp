import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';

class EditSavedAddresses extends StatefulWidget {
  const EditSavedAddresses({Key? key}) : super(key: key);

  @override
  State<EditSavedAddresses> createState() => _EditSavedAddressesState();
}

class _EditSavedAddressesState extends State<EditSavedAddresses> {
  final _searchQueryController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchQueryController.dispose();
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
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                  border: Border.all(
                      width: 1, //                   <--- border width here
                      color: Colors.black26),
                ),
                // color: Colors.black,
                // height: 5.h,
                child: Center(
                  child: TextField(
                    controller: _searchQueryController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search for an area",
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.black26),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.black),
                    onChanged: (query) => {},
                  ),
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
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        'Using GPS',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.black38,
                              // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
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
                      onTap: (){

                      },
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
}
