import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

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
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Constance.primaryColor,
                      fontSize: 2.5.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.black,
                      fontSize: 1.6.h,
                    ),
                controller: first_name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter First Name',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 1.5.h,
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
                      fontSize: 1.6.h,
                    ),
                controller: last_name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter Last Name',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 1.5.h,
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
                      fontSize: 1.6.h,
                    ),
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter Email',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontSize: 1.5.h,
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
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Constance.primaryColor,
                  fontSize: 2.5.h,
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
                              fontSize: 1.6.h,
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
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          date.split('-')[0],
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.black,
                                    fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          date.split('-')[1] ?? "",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.black,
                                fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          date.split('-')[2],
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.black,
                                fontSize: 2.h,
                                    // fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'Gender',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Constance.primaryColor,
                      fontSize: 2.5.h,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: 150,
                  child: DropdownButton(
                    isExpanded: true,

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
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 2.h,
                                    fontWeight: FontWeight.bold,
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
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Constance.primaryColor,
                          fontSize: 2.5.h,
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
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Constance.primaryColor,
                          fontSize: 2.h,
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
                height: 3.h,
              ),
              Text(
                'The data can be changed in your profile later',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Constance.primaryColor,
                      fontSize: 1.6.h,
                      // fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
              Text(
                'All the data fields are mandatory for registration',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Constance.thirdColor,
                  fontSize: 1.6.h,
                      // fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: double.infinity,
                height: 5.h,
                child: CustomButton(
                  txt: 'Save & Continue',
                  onTap: () {
                    Navigation.instance.navigate('/enterPreferences');
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
      title: Image.asset(Constance.logoIcon,
          fit: BoxFit.fill, height: 10.h, width: 20.w),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
  }
}
