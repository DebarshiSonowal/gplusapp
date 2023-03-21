import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Model/membership.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../../Components/alert.dart';
import '../../Components/be_a_member_card.dart';
import '../../Helper/Constance.dart';
import '../../Helper/Storage.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';

class BeAMember extends StatefulWidget {
  const BeAMember({Key? key}) : super(key: key);

  @override
  State<BeAMember> createState() => _BeAMemberState();
}

class _BeAMemberState extends State<BeAMember> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);


  // final _razorpay = Razorpay();

  double tempTotal = 0;
  String be_a_member = "", benifits = "";
  var temp_order_id = "";

  @override
  void initState() {
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    Future.delayed(Duration.zero, () {
      fetch();
    });
  }



  @override
  void dispose() {
    // _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  void _onRefresh() async {
    // monitor network fetch
    final response = await ApiProvider.instance.getMembership(Platform.isAndroid?"android":"ios");
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMembership(response.membership ?? []);
      _refreshController.refreshCompleted();
    } else {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMembership(response.membership ?? []);
      _refreshController.refreshFailed();
    }
    // if failed,use refreshFailed()
  }

  void _onLoading() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted)
    //   setState(() {
    //
    //   });
    _refreshController.loadComplete();
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar("subscription",true,_scaffoldKey),
      drawer: const BergerMenuMemPage(screen: "subscription",),
      backgroundColor: Colors.white,
      // drawer: BergerMenuMemPage(),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        // onLoading: _onLoading,
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello ${data.profile?.name}',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    'Be a Subscriber',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          color: Constance.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    be_a_member ??
                        'when an unknown printer took a galley of type'
                            ' and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          // fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (conte, count) {
                        var current = data.memberships[count];
                        return BeMemberCard(current: current,count: count);
                      },
                      separatorBuilder: (cont, ind) {
                        return SizedBox(
                          height: 2.h,
                        );
                      },
                      itemCount: data.memberships.length),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Text(
                    'Benefits of being a subscriber',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Storage.instance.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 2.5.h,
                  ),
                  Html(
                    shrinkWrap: true,
                    data: benifits ?? '',
                    style: {
                      '#': Style(
                        // fontSize: FontSize(_counterValue),

                        // maxLines: 20,
                        color: Storage.instance.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        // textOverflow: TextOverflow.ellipsis,
                      ),
                    },
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }


  void fetch() async {
    final response = await ApiProvider.instance.getMembership(Platform.isAndroid?"android":"ios");
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMembership(response.membership ?? []);
      setState(() {
        benifits = response.benifit_members ?? "";
        be_a_member = response.be_a_member ?? "";
      });
      // _refreshController.refreshCompleted();
    } else {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMembership(response.membership ?? []);
      // _refreshController.refreshFailed();
    }
  }

  // void order(subscription_id, use_referral_point, razorpay) async {
  //   Navigation.instance.navigate('/loadingDialog');
  //   final response = await ApiProvider.instance
  //       .createOrder(subscription_id, use_referral_point);
  //   // startPayment(response.order?.base_price,response.order?.id,);
  //   if (response.success ?? false) {
  //     Navigation.instance.goBack();
  //     tempTotal = response.order?.base_price ?? 0;
  //     temp_order_id = response.order?.voucher_no.toString() ?? "";
  //     startPayment(
  //         razorpay,
  //         response.order?.base_price,
  //         response.order?.voucher_no,
  //         Provider.of<DataProvider>(
  //                 Navigation.instance.navigatorKey.currentContext ?? context,
  //                 listen: false)
  //             .profile
  //             ?.id);
  //   } else {
  //     Navigation.instance.goBack();
  //     showError(response.message ?? "Something went wrong");
  //   }
  // }

  // void initiatePaymentProcess() async {
  //   Navigation.instance.navigate('/loadingDialog');
  //   final response = await ApiProvider.instance.fetchRazorpay();
  //   if (response.status ?? false) {
  //     initateOrder(response.razorpay!);
  //   } else {
  //     Navigation.instance.goBack();
  //     // CoolAlert.show(
  //     //   context: context,
  //     //   type: CoolAlertType.warning,
  //     //   text: "Something went wrong",
  //     // );
  //   }
  // }

  // void startPayment(RazorpayKey razorpay, double? total, id, customer_id) {
  //   var options = {
  //     'key': razorpay.api_key,
  //     'amount': total! * 100,
  //     // 'order_id': id,
  //     'name':
  //         '${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.f_name} ${Provider.of<DataProvider>(Navigation.instance.navigatorKey.currentContext ?? context, listen: false).profile?.l_name}',
  //     'description': 'Books',
  //     'prefill': {
  //       'contact': Provider.of<DataProvider>(
  //               Navigation.instance.navigatorKey.currentContext ?? context,
  //               listen: false)
  //           .profile
  //           ?.mobile,
  //       'email': Provider.of<DataProvider>(
  //               Navigation.instance.navigatorKey.currentContext ?? context,
  //               listen: false)
  //           .profile
  //           ?.email
  //     },
  //     'note': {
  //       'customer_id': customer_id,
  //       'order_id': id,
  //     },
  //   };
  //   debugPrint(jsonEncode(options));
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   print(
  //       'success ${response.paymentId} ${response.orderId} ${response.signature}');
  //   handleSuccess(response);
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   // Do something when payment fails
  //   print('error ${response.message} ${response.code} ');
  //   showError(response.message ?? "Something went wrong");
  //   // Navigation.instance.goBack();
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Do something when an external wallet was selected
  // }
  //
  // void handleSuccess(PaymentSuccessResponse response) async {
  //   final response1 = await ApiProvider.instance
  //       .verifyPayment(temp_order_id, response.paymentId, tempTotal ?? 1);
  //   if (response1.success ?? false) {
  //     // Navigation.instance.goBack();
  //     showDialogBox();
  //     // Fluttertoast.showToast(
  //     //     msg: "Payment Successful. Congratulations You are now a member. ");
  //
  //   } else {
  //     Navigation.instance.goBack();
  //     showError(response1.message ?? "Something went wrong");
  //   }
  // }

  void fetchProfile() async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getprofile();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setProfile(response.profile!);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyTopicks(response.topicks);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setMyGeoTopicks(response.geoTopicks);
      Navigation.instance.goBack();
    } else {
      Navigation.instance.goBack();
      showError(response.msg ?? "Something went wrong");
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

  // void initiateOrder(int? id, int i) async {
  //   final response = await ApiProvider.instance.fetchRazorpay();
  //   if (response.status ?? false) {
  //     order(id, i, response.razorpay!);
  //   } else {
  //     showError(response.message ?? "Something went wrong");
  //   }
  // }

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
            'Congratulations',
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
                Text(
                  'You are now a member of Gplus community',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                      txt: 'Close',
                      onTap: () {
                        Navigation.instance.goBack();
                        Navigation.instance.goBack();
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


