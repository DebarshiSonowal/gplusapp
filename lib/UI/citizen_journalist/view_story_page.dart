import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Model/citizen_journalist.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class ViewStoryPage extends StatefulWidget {
  final int id;

  ViewStoryPage(this.id);

  @override
  State<ViewStoryPage> createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage> {
  var title = '';
  CitizenJournalist? local;
  var desc = '';

  var current = 3;
  final ImagePicker _picker = ImagePicker();
  List<File> attachements = [];
  List<CJAttachment> images = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .citizenJournalist
          .isNotEmpty) {
        fetchDetails();
      } else {
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // title.dispose();
    // desc.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("citizen_journalist"),
      // drawer: BergerMenuMemPage(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  'Submitted A Story',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Constance.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold
                      // fontSize: 1.6.h,
                      ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                desc,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      // fontSize: 1.6.h,
                    ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    color: Storage.instance.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                  Text(
                    'Attachments',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
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
                  (images.length ?? 0),
                  (pos) => (pos == images.length)
                      ? GestureDetector(
                          onTap: () {},
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
                      : GestureDetector(
                          onTap: () {
                            print(images[pos].file_type);
                            if (images[pos]
                                    .file_type
                                    .toString()
                                    .split('/')[0] ==
                                "image") {
                              Navigation.instance.navigate('/viewImage',
                                  args: images[pos].file_name);
                            } else {
                              // Navigation.instance.navigate('/viewVideo',
                              //     args: images[pos].file_name);
                            }
                          },
                          child: Container(
                            height: 8.h,
                            width: 20.w,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Image.network(
                                images[pos].file_name ?? "",
                                fit: BoxFit.fill,
                                errorBuilder: (err, cont, st) {
                                  return Image.asset(Constance.logoIcon);
                                },
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Posted on ${Jiffy.parse(local?.created_at ?? "2020-06-21", pattern: "yyyy-MM-dd").format(pattern: "dd/MM/yyyy")}',
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white70
                          : Colors.black,
                      // fontSize: 1.6.h,
                    ),
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current,"citizen_journalist"),
    );
  }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     title: GestureDetector(
  //       onTap: () {
  //         Provider.of<DataProvider>(
  //                 Navigation.instance.navigatorKey.currentContext ?? context,
  //                 listen: false)
  //             .setCurrent(0);
  //         Navigation.instance.navigate('/main');
  //       },
  //       child: Image.asset(
  //         Constance.logoIcon,
  //         fit: BoxFit.fill,
  //         scale: 2,
  //       ),
  //     ),
  //     centerTitle: true,
  //     backgroundColor: Constance.primaryColor,
  //     actions: [
  //       IconButton(
  //         onPressed: () {
  //           Navigation.instance.navigate('/notification');
  //         },
  //         icon: Consumer<DataProvider>(builder: (context, data, _) {
  //           return Badge(
  //             badgeColor: Constance.secondaryColor,
  //             badgeContent: Text(
  //               '${data.notifications.length}',
  //               style: Theme.of(context).textTheme.headline6?.copyWith(
  //                     color: Constance.thirdColor,
  //                   ),
  //             ),
  //             child: const Icon(Icons.notifications),
  //           );
  //         }),
  //       ),
  //       IconButton(
  //         onPressed: () {
  //           Navigation.instance.navigate('/search', args: "");
  //         },
  //         icon: Icon(Icons.search),
  //       ),
  //     ],
  //   );
  // }

  Future<void> getProfileImage(int index) async {
    if (index == 0) {
      // final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      // if (pickedFile != null) {
      //   setState(() {
      //     var profileImage = File(pickedFile.path);
      //     attachements.add(profileImage);
      //   });
      // }
      final pickedFile = await ImagesPicker.openCamera(
        pickType: PickType.image,
        quality: 0.7,
      );

      if (pickedFile != null) {
        for (var i in pickedFile) {
          setState(() {
            attachements.add(
              File(i.path),
            );
          });
        }
      }
    } else {
      final pickedFile = await _picker.pickMultiImage();
      if (pickedFile != null) {
        setState(() {
          for (var i in pickedFile) {
            attachements.add(
              File(i.path),
            );
          }
        });
      }
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
                  'Hello ${Provider.of<DataProvider>(context).profile?.name ?? ""}',
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

  fetchDetails() async {
    setState(() {
      local = Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .citizenlist
          .where((element) => element.id == widget.id)
          .first;
      title = local?.title ?? "";
      desc = local?.story ?? "";
      // attachements.add(File(''));
      images = local?.attach_files ?? [];
    });
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

  void fetchData() async {
    final response = await ApiProvider.instance.getCitizenJournalistApproved();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCitizenJournalist(response.posts);
      // Fluttertoast.showToast(msg: "G successfully");
      // Navigation.instance.goBack();
      // setState(() {
      //   isEmpty = response.posts.isEmpty ? true : false;
      // });
      fetchDetails();
    } else {
      // setState(() {
      //   isEmpty = true;
      // });
      // Navigation.instance.goBack();
    }
  }
}
