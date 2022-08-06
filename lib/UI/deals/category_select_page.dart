import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:sizer/sizer.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class CategorySelectPage extends StatefulWidget {
  const CategorySelectPage({Key? key}) : super(key: key);

  @override
  State<CategorySelectPage> createState() => _CategorySelectPageState();
}

class _CategorySelectPageState extends State<CategorySelectPage> {
  String dropdownvalue = '10:00 am - 8:00 pm';
  int selected = 0;

  // List of items in our dropdown menu
  var items = [
    '10:00 am - 8:00 pm',
    '12:00 am - 4:00 pm',
    '9:00 am - 3:00 pm',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(imageUrl: Constance.salonImage),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'The Looks Salon',
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 0;
                      });
                    },
                    child: Container(
                      height: 5.h,
                      color: selected == 0
                          ? Colors.black
                          : Constance.secondaryColor,
                      child: Center(
                        child: Text(
                          'Offer',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                  color: selected == 0
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 1;
                      });
                    },
                    child: Container(
                      height: 5.h,
                      color: selected == 0
                          ? Constance.secondaryColor
                          : Colors.black,
                      child: Center(
                        child: Text(
                          'Details',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(
                                color:
                                    selected == 0 ? Colors.black : Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            getBody(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill,scale: 2,),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }

  getBody() {
    switch (selected) {
      case 0:
        return Column(children: [
          SizedBox(
            height: 2.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: SizedBox(
                  height: 5.h,
                  child: Text(
                    'Hatigaon Bhetapara Road, Bhetapara, Guwahati, Assam, 781022',
                    // overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.phone,
                color: Colors.black,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: Text(
                  '+917838372617',
                  // overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            height: 4.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(
                  width: 4.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Open Now',
                      // overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 4.w,
                ),
                SizedBox(
                  width: 45.w,
                  child: Center(
                    child: DropdownButton(
                      isExpanded: false,
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
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                FontAwesomeIcons.clipboard,
                color: Colors.black,
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: SizedBox(
                  height: 5.h,
                  child: Text(
                    'Tanning Salon . Beauty Supply Shop . Hair Salon',
                    // overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ]);
      default:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: Constance.categoryDiscount.length,
            itemBuilder: (cont, count) {
              var data = Constance.categoryDiscount[count];
              return ListTile(
                title: SizedBox(
                  width: 45.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.discount ?? "",
                        style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Constance.thirdColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data.offer ?? "",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
                trailing: CustomButton(
                  txt: 'Reedem Now',
                  onTap: () {
                    showDialogBox();
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 2.h,
                child: Center(
                  child: Divider(
                    thickness: 0.1.h,
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
        );
    }
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Hello Jonathan!',
            style: Theme.of(context).textTheme.headline3?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
            // height: 50.h,
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Text(
                  'Do you really want to redeem the offer?',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        color: Constance.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,'
                  ' when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                  ' It has survived not only five centuries, but also the leap into electronic typesetting,'
                  ' remaining essentially unchanged',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Go Ahead',
                      onTap: () {
                        Navigation.instance.goBack();
                        Navigation.instance.navigate('/redeemOfferPage');
                      }),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Cancel',
                      onTap: () {
                        Navigation.instance.goBack();
                      }),
                )
              ],
            ),
          ),
          actions: [
            // FlatButton(
            //   textColor: Colors.black,
            //   onPressed: () {},
            //   child: Text('CANCEL'),
            // ),
            // FlatButton(
            //   textColor: Colors.black,
            //   onPressed: () {},
            //   child: Text('ACCEPT'),
            // ),
          ],
        );
      },
    );
  }
}
