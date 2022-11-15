import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Components/NavigationBar.dart';
import '../../Components/alert.dart';
import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Navigation/Navigate.dart';

class FoodDealPage extends StatefulWidget {
  final int id;

  FoodDealPage(this.id);

  @override
  State<FoodDealPage> createState() => _FoodDealPageState();
}

class _FoodDealPageState extends State<FoodDealPage> {
  String _value = 'Time';

  var current = 1;

  var locality = '', order_by = 'alphabet';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchCategories());
    // secureScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(7.w),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      decoration: BoxDecoration(
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.transparent,
                        border: Border.all(
                            color: Constance.secondaryColor, width: 0.5.h),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CachedNetworkImage(
                        height: 4.h,
                        imageUrl:
                            '${data.category.firstWhere((element) => element.id == widget.id).image_file_name}',
                        errorWidget: (cont, _, e) {
                          return Image.network(
                            Constance.defaultImage,
                            fit: BoxFit.fitWidth,
                          );
                        },
                        placeholder: (cont, _) {
                          return Image.asset(
                            Constance.logoIcon,
                            // color: Colors.black,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      '${data.category.firstWhere((element) => element.id == widget.id).name}',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Storage.instance.isDarkMode
                                ? Colors.white
                                : Constance.primaryColor,
                            fontSize: 3.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Constance.primaryColor,
                height: 5.h,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showSortByOption();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.sort,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            'Sort by',
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Colors.white,
                                      fontSize: 2.h,
                                      // fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                      child: Center(
                        child: Container(
                          height: double.infinity,
                          width: 0.5.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result =
                            await Navigation.instance.navigate('/filterPage');
                        if (result != '') {
                          setState(() {
                            locality = result;
                          });
                          fetchCategories();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.filter,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            'Filter by',
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Colors.white,
                                      fontSize: 2.h,
                                      // fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: data.shops.length,
                    itemBuilder: (cont, cout) {
                      var current = data.shops[cout];
                      return Container(
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              // height: 6.h,
                              width: 16.w,
                              imageUrl: current.vendor?.image_file_name ?? "",
                              placeholder: (cont, _) {
                                return Image.asset(
                                  Constance.logoIcon,
                                  // color: Colors.black,
                                );
                              },
                              errorWidget: (cont, _, e) {
                                return Image.network(
                                  Constance.defaultImage,
                                  fit: BoxFit.fitWidth,
                                );
                              },
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                current.title ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 2.2.h,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              Text(
                                current.vendor?.address ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Colors.grey.shade800,
                                      fontSize:
                                          1.5.h, // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          trailing: CustomButton(
                            txt: "View",
                            onTap: () {
                              if (Provider.of<DataProvider>(
                                          Navigation.instance.navigatorKey
                                                  .currentContext ??
                                              context,
                                          listen: false)
                                      .profile
                                      ?.is_plan_active ??
                                  false) {
                                Navigation.instance.navigate('/categorySelect',
                                    args: current.vendor_id!);
                              } else {
                                Constance.showMembershipPrompt(context, () {});
                              }
                            },
                          ),
                        ),
                      );
                    }),
              )
            ],
          );
        }),
      ),
      bottomNavigationBar: CustomNavigationBar(current),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .setCurrent(0);
          Navigation.instance.navigate('/main');
        },
        child: Image.asset(
          Constance.logoIcon,
          fit: BoxFit.fill,
          scale: 2,
        ),
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
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void showSortByOption() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, _) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    top: 3.h, right: 10.w, left: 10.w, bottom: 3.h),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                child: Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sort by',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Constance.primaryColor,
                            fontSize: 2.h,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        Radio(
                          groupValue: _value,
                          value: 'timeline',
                          fillColor: MaterialStateProperty.all(
                            Constance.primaryColor,
                          ),
                          onChanged: (String? value) {
                            _(() {
                              setState(() {
                                _value = value ?? "";
                                order_by = _value;
                              });
                            });
                            fetchCategories();
                            Navigation.instance.goBack();
                            print(_value);
                          },
                          activeColor: Constance.primaryColor,
                        ),
                        Text(
                          'Time',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          focusColor: Constance.primaryColor,
                          // overlayColor: MaterialStateProperty,
                          groupValue: _value,
                          value: 'alphabet',
                          fillColor: MaterialStateProperty.all(
                            Constance.primaryColor,
                          ),
                          onChanged: (String? value) {
                            _(() {
                              setState(() {
                                _value = value ?? "";
                                order_by = _value;
                              });
                              fetchCategories();
                              Navigation.instance.goBack();
                            });
                          },
                          activeColor: Constance.primaryColor,
                        ),
                        Text(
                          'Alphabetical',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Constance.primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void fetchCategories() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance
        .getShopByCategory(widget.id, locality, order_by);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setShops(response.shops ?? []);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError(response.message ?? "something went wrong");
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

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
