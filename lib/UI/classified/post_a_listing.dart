import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Model/top_picks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class PostAListing extends StatefulWidget {
  const PostAListing({Key? key}) : super(key: key);

  @override
  State<PostAListing> createState() => _PostAListingState();
}

class _PostAListingState extends State<PostAListing> {
  var title = TextEditingController();

  var desc = TextEditingController();

  var price = TextEditingController();

  var current = 3;

  var category = [
    'Vehicles',
    'House',
  ];
  var selectedCategory = '';
  var selectedLocality = '';
  var locality = ['Rukminigaon', 'Khanapara', 'Beltola', ''];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchClassified();
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    desc.dispose();
    price.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post a story',
                style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: Constance.primaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Category',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Constance.primaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 0.3.h,
              ),
              Consumer<DataProvider>(builder: (context, data, _) {
                return DropdownButton(
                  // Initial Value
                  value: selectedCategory,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: data.classified_category
                      .map((e) => DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(
                              e.title ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Constance.primaryColor,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ))
                      .toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                );
              }),
              Text(
                'Add your locality',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Constance.primaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 0.3.h,
              ),
              Consumer<DataProvider>(builder: (context, data, _) {
                return DropdownButton(
                  // Initial Value
                  value: selectedLocality,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: data.locality
                      .map((e) => DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(
                              e.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    color: Constance.primaryColor,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ))
                      .toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLocality = newValue!;
                    });
                  },
                );
              }),
              SizedBox(
                height: 2.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: title,
                maxLines: 1,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter the title',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.5.h,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: desc,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 10,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter the details',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.5.h,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    color: Colors.black,
                  ),
                  Text(
                    'Add more attachments',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                          // fontSize: 1.6.h,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  (Constance.attachements.length ?? 0) + 1,
                  (pos) => (pos == Constance.attachements.length)
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              showPhotoBottomSheet(getProfileImage);
                            });
                          },
                          child: Container(
                            height: 8.h,
                            width: 20.w,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 8.h,
                          width: 20.w,
                          // color: Colors.grey.shade200,
                          child: Center(
                            child: Image.file(
                              Constance.attachements[pos],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Add Price',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Constance.primaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.black,
                      // fontSize: 1.6.h,
                    ),
                controller: title,
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Enter the price',
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        // fontSize: 1.5.h,
                      ),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onTap: () {
                    // showDialogBox();
                    if (title.text.isNotEmpty &&
                        desc.text.isNotEmpty &&
                        price.text.isNotEmpty) {
                      postClassified();
                    }
                  },
                  txt: 'Go ahead',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
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
          onPressed: () {},
          icon: Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void showPhotoBottomSheet(Function(int) getImage) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    BuildContext? context = Navigation.instance.navigatorKey.currentContext;
    if (context != null) {
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Center(
                    child: Text(
                  "Add Photo",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                )),
                contentPadding: const EdgeInsets.only(top: 24, bottom: 30),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigation.instance.goBack();
                              getImage(0);
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.pink.shade300),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  "Camera",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 42,
                        ),
                        InkWell(
                            onTap: () {
                              Navigation.instance.goBack();
                              getImage(1);
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.purple.shade300),
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  "Gallery",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ],
                ));
          });
    }
  }

  Future<void> getProfileImage(int index) async {
    final pickedFile = await _picker.pickImage(
        source: (index == 0) ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        // profileImage = File(pickedFile.path);
        print(pickedFile.path);
        Constance.attachements.add(
          File(pickedFile.path),
        );
      });
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
            'Be a journalist!',
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  color: Constance.secondaryColor,
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
                Icon(
                  FontAwesomeIcons.podcast,
                  color: Constance.secondaryColor,
                  size: 15.h,
                ),
                Text(
                  'Hello Jonathan!',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
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
                Text(
                  'is simply dummy text of the printing and typesetting industry',
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
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void fetchClassified() async {
    // showLoaderDialog(context);
    final response = await ApiProvider.instance.getClassifiedCategory();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      print(response.categories);
      setState(() {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setClassifiedCategory(response.categories ?? []);
        selectedCategory = response.categories![0].id.toString();
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setLocality(response.localities ?? []);
        selectedLocality = response.localities![0].id.toString();
      });
    } else {
      setState(() {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setClassifiedCategory(response.categories ?? []);
        selectedCategory = response.categories![0].id.toString();
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setLocality(response.localities ?? []);
        selectedLocality = response.localities![0].id.toString();
      });
      // Navigation.instance.goBack();
      // showError("Something went wrong");
    }
  }

  void postClassified() {

  }
}
