import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class GrieveanceRedressal extends StatefulWidget {
  const GrieveanceRedressal({Key? key}) : super(key: key);

  @override
  State<GrieveanceRedressal> createState() => _GrieveanceRedressalState();
}

class _GrieveanceRedressalState extends State<GrieveanceRedressal> {
  int selected = 0;
  var publicationDate = '';
  var date = '';
  int year = 2000;
  int max = DateTime.now().year;
  int currentY = DateTime.now().year;
  final _first_name = TextEditingController();
  final _last_name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _address = TextEditingController();
  final _pin = TextEditingController();
  final _link = TextEditingController();
  final _desc = TextEditingController();
  final _violation = TextEditingController();
  final _name = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _first_name.dispose();
    _last_name.dispose();
    _email.dispose();
    _mobile.dispose();
    _address.dispose();
    _pin.dispose();
    _link.dispose();
    _desc.dispose();
    _violation.dispose();
    _name.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        var current = DateTime.now();
        final f = DateFormat('dd-MM-yyyy');
        publicationDate = f.format(current);
        date = f.format(current);
        final y = DateFormat('yyyy');
        currentY = int.parse(y.format(current));
        year = currentY - 18;
        max = currentY + 18;
      });
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
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.mobile_friendly,
                    color: Constance.secondaryColor,
                    size: 3.5.h,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    'Grievance Redressal',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Constance.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
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
                            'Submit Grievances',
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
                            'Past Grievances',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      color: selected == 0
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.5.h,
              ),
              getBody(selected),
              SizedBox(
                height: 2.7.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () {
      //     Navigation.instance.navigate('/bergerMenuMem');
      //   },
      //   icon: Icon(Icons.menu),
      // ),
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/notification');
          },
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            Navigation.instance.navigate('/search');
            // showSearch(
            //   context: context,
            //   delegate: SearchPage<Listing>(
            //     items: Constance.listings,
            //     searchLabel: 'Search posts',
            //     suggestion: Center(
            //       child: Text(
            //         'Filter posts by name, descr',
            //         style: Theme.of(context).textTheme.headline5,
            //       ),
            //     ),
            //     failure: const Center(
            //       child: Text('No posts found :('),
            //     ),
            //     filter: (current) => [
            //       current.title,
            //       current.descr,
            //       // person.age.toString(),
            //     ],
            //     builder: (data) => ListTile(
            //       title: Text(
            //         data.title ?? "",
            //         style: Theme.of(context).textTheme.headline5,
            //       ),
            //       subtitle: Text(
            //         data.descr ?? '',
            //         style: Theme.of(context).textTheme.headline6,
            //       ),
            //       // trailing: CachedNetworkImage(
            //       //   imageUrl: data.image??'',
            //       //   height: 20,
            //       //   width: 20,
            //       // ),
            //     ),
            //   ),
            // );
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  getBody(int selected) {
    if (selected == 1) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26, //                   <--- border color
                // width: 5.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
            ),
            child: ExpansionTile(
              collapsedIconColor: Colors.black,
              iconColor: Colors.black,
              title: Text(
                'July 2022',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Constance.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  height: 1.h,
                  width: double.infinity,
                  child: Divider(
                    color: Colors.black26,
                    thickness: 0.7.sp,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grievances Received',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '20',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grievances Resolved  ',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '20',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26, //                   <--- border color
                // width: 5.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(
                  5.0) //                 <--- border radius here
              ),
            ),
            child: ExpansionTile(
              collapsedIconColor: Colors.black,
              iconColor: Colors.black,
              title: Text(
                'June 2022',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Constance.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  height: 1.h,
                  width: double.infinity,
                  child: Divider(
                    color: Colors.black26,
                    thickness: 0.7.sp,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grievances Received',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '20',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grievances Resolved  ',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '20',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26, //                   <--- border color
                // width: 5.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(
                  5.0) //                 <--- border radius here
              ),
            ),
            child: ExpansionTile(
              collapsedIconColor: Colors.black,
              iconColor: Colors.black,
              title: Text(
                'May 2022',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Constance.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  height: 1.h,
                  width: double.infinity,
                  child: Divider(
                    color: Colors.black26,
                    thickness: 0.7.sp,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grievances Received',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '20',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grievances Resolved  ',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '20',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Constance.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'It is a long established fact that a reader will be'
            ' distracted by the readable content of a page when looking'
            ' at its layout. The point of using Lorem Ipsum is that it has'
            ' a more-or-less normal distribution of letters, as opposed to'
            ' using',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Colors.black54,
                ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'The grievance can be addressed to our Grievance Officer',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Sidharth Bedi Varma',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Text(
            'Address: G Plus, 4-A, 4th Floor, Royal Arcade, B Barooah Road,'
            ' Ulubari, Guwahati, Assam- 781007\n'
            'Email: info@g-plus.in',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Colors.black54,
                ),
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Text(
            'Please fill out all the details of the Grievance Redressal'
            ' form. Any section left blank or anonymous* or fake'
            ' submissions will not be accepted',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Colors.black54,
                ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'First Name',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _first_name,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Enter First Name",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Last Name',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _last_name,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Enter Last Name",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Email Id',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _email,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Enter Email Id",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Mobile Phone',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _mobile,
                keyboardType: TextInputType.phone,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Enter Mobile Number",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Address',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _address,
                keyboardType: TextInputType.text,
                autofocus: true,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Enter Address",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Pincode',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _pin,
                keyboardType: TextInputType.phone,
                autofocus: true,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: "Enter Pincode",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Link to the content for which complaint needs to be filed',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.7.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _link,
                keyboardType: TextInputType.url,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Paste link here",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Date of publication',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.7.h,
          ),
          GestureDetector(
            onTap: () async {
              var datePicked = await DatePicker.showSimpleDatePicker(
                context,
                initialDate: DateTime(currentY),
                firstDate: DateTime(year),
                lastDate: DateTime(max),
                dateFormat: "dd-MMMM-yyyy",
                itemTextStyle: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Constance.primaryColor,
                      // fontSize: 1.6.h,
                      fontWeight: FontWeight.bold,
                    ),
                locale: DateTimePickerLocale.en_us,
                looping: true,
              );
              if (datePicked != null) {
                setState(() {
                  publicationDate =
                      "${datePicked?.day}-${datePicked?.month}-${datePicked?.year}";
                });
              }
            },
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          publicationDate == ''
                              ? ''
                              : '${publicationDate.split('-')[0]}',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
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
                          publicationDate == ''
                              ? ''
                              : '${publicationDate.split('-')[1]}',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
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
                          publicationDate == ''
                              ? ''
                              : '${publicationDate.split('-')[2]}',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
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
            height: 1.7.h,
          ),
          Text(
            'Exact details of the content that vou feel contains a '
            'violation. Please specify exact words or para of the '
            'article, or exact time stamps for videos and podcasts.',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _desc,
                keyboardType: TextInputType.text,
                autofocus: true,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Enter your answer",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Please summarise details of the content which is in '
            'violation and specify how it is a violation with respect'
            'to the Code of Ethics. Also, please specify the exact'
            'section from the Code of Ethics that vou are'
            'referencing in the violation/complaint.',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _violation,
                keyboardType: TextInputType.text,
                autofocus: true,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Enter your answer",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 2.7.h,
          ),
          Text(
            'I hereby declare that I am resident of India '
            'and all the information furnished above is '
            'true, complete and correct to the best of my '
            'knowledge and belief.',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.7.h,
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Name',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
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
                controller: _name,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Full Name",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black26),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.black),
                onChanged: (query) => {},
              ),
            ),
          ),
          SizedBox(
            height: 1.7.h,
          ),
          Text(
            'Date',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  color: Colors.black54,
                  // fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 0.7.h,
          ),
          GestureDetector(
            onTap: () async {
              var datePicked = await DatePicker.showSimpleDatePicker(
                context,
                initialDate: DateTime(currentY),
                firstDate: DateTime(year),
                lastDate: DateTime(max),
                dateFormat: "dd-MMMM-yyyy",
                itemTextStyle: Theme.of(context).textTheme.headline6?.copyWith(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
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
                ],
              ),
            ),
          ),
          SizedBox(
            height: 2.7.h,
          ),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              txt: 'Submit',
              onTap: () {},
            ),
          ),
          SizedBox(
            height: 2.7.h,
          ),
          RichText(
            text: TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Constance.thirdColor,
                    // fontWeight: FontWeight.bold,
                  ),
              children: <TextSpan>[
                const TextSpan(text: 'G Plus is a member of '),
                TextSpan(
                  text: 'DIGIPUB News India Foundation',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Constance.thirdColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const TextSpan(
                  text: '. If a complainant is dissatisfied with our'
                      'grievance redressal, lease reach out to IGIpuR\'s '
                      'grievance officer at the following address: ',
                ),
                TextSpan(
                  text: 'selfregulatorybody@digipubindia.in',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Constance.thirdColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
