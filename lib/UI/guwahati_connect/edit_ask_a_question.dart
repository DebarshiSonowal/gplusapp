import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Model/guwahati_connect.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';
import '../Menu/berger_menu_member_page.dart';

class EditAskAQuestionPage extends StatefulWidget {
  final String id;

  const EditAskAQuestionPage(this.id);

  @override
  State<EditAskAQuestionPage> createState() => _EditAskAQuestionPageState();
}

class _EditAskAQuestionPageState extends State<EditAskAQuestionPage> {
  final desc = TextEditingController();

  var current = 3;
  final ImagePicker _picker = ImagePicker();
  List<File> attachements = [];
  List<GCAttachment> images = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      desc.text = int.parse(widget.id.split(",")[0]) == 0
          ? (Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .guwahatiConnect[int.parse(widget.id.split(",")[1])]
                  .question ??
              "")
          : (Provider.of<DataProvider>(
                      Navigation.instance.navigatorKey.currentContext ??
                          context,
                      listen: false)
                  .myGuwahatiConnect[int.parse(widget.id.split(",")[1])]
                  .question ??
              "");

      setState(() {
        if (int.parse(widget.id.split(",")[0]) == 0) {
          images.addAll(Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .guwahatiConnect[int.parse(widget.id.split(",")[1])]
              .attachment!);
        } else {
          images.addAll(Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .myGuwahatiConnect[int.parse(widget.id.split(",")[1])]
              .attachment!);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // title.dispose();
    desc.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("guwahati"),
      // drawer: const BergerMenuMemPage(screen: "guwahati"),
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
                  'Edit Question',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      fontWeight: FontWeight.bold),
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
                minLines: 15,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Ask a question',
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
                  Icon(
                    Icons.attach_file,
                    color: Storage.instance.isDarkMode
                        ? Constance.secondaryColor
                        : Colors.black,
                  ),
                  Text(
                    'Add attachments',
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
                      : Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 8.h,
                              width: 20.w,
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Image.network(
                                  images[pos].file_name ?? "",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  attachements.removeAt(pos);
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.white,
                                child: const Icon(
                                  Icons.remove,
                                  color: Constance.thirdColor,
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  (attachements.length ?? 0) + 1,
                  (pos) => (pos == attachements.length)
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
                      : Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 8.h,
                              width: 20.w,
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Image.file(
                                  attachements[pos],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  attachements.removeAt(pos);
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.white,
                                child: const Icon(
                                  Icons.remove,
                                  color: Constance.thirdColor,
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onTap: () {
                    // showDialogBox();
                    if (desc.text.isNotEmpty) {
                      if (int.parse(widget.id.split(",")[0]) == 0) {
                        updateQuestion(Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .guwahatiConnect[int.parse(widget.id.split(",")[1])]
                            .id!);
                      } else {
                        updateQuestion(Provider.of<DataProvider>(
                                Navigation
                                        .instance.navigatorKey.currentContext ??
                                    context,
                                listen: false)
                            .myGuwahatiConnect[
                                int.parse(widget.id.split(",")[1])]
                            .id!);
                      }
                    } else {}
                  },
                  txt: 'Submit',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(current, "guwahati"),
    );
  }

  void showPhotoBottomSheet(Function(int) getImage) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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

  void updateQuestion(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.updateGuwahatiConnect(
        id, desc.text, attachements, getComaSeparated(images));
    if (response.success ?? false) {
      print("post success ${response.success} ${response.message}");
      Fluttertoast.showToast(msg: "Posted successfully");
      Navigation.instance.goBack();
      fetchGuwahatiConnect();
      fetchMyGuwahatiConnect();
      Navigation.instance.goBack();
    } else {
      print("post failed ${response.success} ${response.message}");
      Navigation.instance.goBack();
      showError(response.message ?? "Something went wrong");
    }
  }

  String getComaSeparated(List<dynamic> list) {
    String temp = "";
    for (int i = 0; i < list.length; i++) {
      if (i == 0) {
        temp = '${list[i].id.toString()},';
      } else {
        temp += '${list[i].id.toString()},';
      }
    }
    return temp.endsWith(",") ? temp.substring(0, temp.length - 1) : temp;
  }

  void fetchGuwahatiConnect() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
    } else {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setGuwahatiConnect(response.posts);
    }
  }

  void fetchMyGuwahatiConnect() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getMyGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGuwahatiConnect(response.posts);
    } else {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGuwahatiConnect(response.posts);
    }
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
}
