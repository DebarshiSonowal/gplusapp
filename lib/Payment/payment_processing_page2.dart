import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_upi/get_upi.dart';
import 'package:gplusapp/Payment/widgets/dialog_box_contents.dart';
import 'package:gplusapp/Payment/widgets/getUserInformationBody.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Components/custom_button.dart';
import '../Components/guwhati_connect_post_card.dart';
import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Helper/Storage.dart';
import '../Helper/app_data.dart';
import '../Helper/store_config.dart';
import '../Model/profile.dart';
import '../Model/upi_app.dart';
import '../Navigation/Navigate.dart';
import '../Networking/api_provider.dart';

class PaymentProcessingPage2 extends StatefulWidget {
  final String input;

  PaymentProcessingPage2({super.key, required this.input});

  @override
  State<PaymentProcessingPage2> createState() => _PaymentProcessingPage2State();
}

class _PaymentProcessingPage2State extends State<PaymentProcessingPage2>
    with WidgetsBindingObserver {
  final email = TextEditingController();
  final phone = TextEditingController();
  final name = TextEditingController();
  String? orderId, merchant_subscription_id, merchant_user_id;

  //
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<String> environmentList = <String>['SANDBOX', 'PRODUCTION'];
  bool enableLogs = true;
  Object? result;
  String environmentValue = 'SANDBOX';
  String body = "";
  String callback = "flutterDemoApp";
  String checksum = "";
  String packageName = "com.phonepe.simulator";

  // String? orderId;

  //
  Timer? timer;

  AppLifecycleState? _notification;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        if (orderId != "" &&
            merchant_subscription_id != "" &&
            merchant_user_id != "") {
          final resp = await checkForOrders(
            orderId,
            merchant_subscription_id,
            merchant_user_id,
          );
          if (resp) {
            fetchProfile();
            Navigation.instance.navigateAndRemoveUntil("/main");
          } else {
            Navigation.instance.goBack();
            Navigation.instance.goBack();
          }
        }
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  void initState() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      showError("${error}");
    }) as StreamSubscription<List<PurchaseDetails>>?;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () {
      if (Platform.isAndroid) {
        fetchPhonepe(widget.input.split(',')[0]);
      } else {
        showPaymentOptions();
      }
    });
    // timer = Timer.periodic(
    //   const Duration(seconds: 10),
    //   (timer) async {
    //
    //   },
    // );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constance.buildAppBar2("subscription"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                height: 12.h,
                width: 25.w,
                child: CircularProgressIndicator(
                  strokeWidth: 4.sp,
                  color: Storage.instance.isDarkMode
                      ? Colors.white
                      : Constance.primaryColor,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                'Please wait',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Constance.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'Your payment is being processed',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Storage.instance.isDarkMode
                          ? Colors.white70
                          : Constance.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Do not close this page',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Constance.thirdColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 5.h,
              ),
              CustomButton(
                txt: 'Cancel Payment',
                onTap: () {
                  Navigation.instance.goBack();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//Methods

  //IN APP
  _verifyPurchase(PurchaseDetails purchaseDetails) async {
    return await InAppPurchase.instance.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          showError(purchaseDetails.error.toString());
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            fetchProfile();
            Navigation.instance.goBack();
            showDialogBox();
          } else {
            showError(purchaseDetails.error.toString());
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void showPaymentOptions() async {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 32.h,
            width: 40.w,
            padding: EdgeInsets.only(
              top: 2.h,
              right: 2.w,
              left: 2.w,
              // bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select the desired payment method',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: !Storage.instance.isDarkMode
                            ? Colors.black
                            : Colors.white,
                      ),
                ),
                SizedBox(height: 2.h),
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.apple),
                      onTap: () {
                        initPlatformState();
                        Navigation.instance.goBack();
                      },
                      title: Text(
                        'InApp Purchase',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.green,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Constance.thirdColor,
                            ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setDebugLogsEnabled(true);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..observerMode = false;
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID =
            "${Provider.of<DataProvider>(context, listen: false).profile?.id}"
        ..observerMode = false;
    }
    await Purchases.configure(configuration);

    appData.appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      (customerInfo.entitlements.all[FlutterConfig.get('entitlementId')] !=
                  null &&
              customerInfo.entitlements.all[FlutterConfig.get('entitlementId')]!
                  .isActive)
          ? appData.entitlementIsActive = true
          : appData.entitlementIsActive = false;
    });

    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
      debugPrint("Packages1 ${offerings.current!.availablePackages}");
      final response = await Purchases.appUserID;
      debugPrint("1st $response");
      debugPrint("2nd ${offerings.getOffering("subscriptions")}");
      debugPrint("3rd ${widget.input.split(',')[2]}");
      CustomerInfo customerInfo =
          await Purchases.purchaseProduct(widget.input.split(',')[2]);

      // purchasePackage(offerings
      //       .getOffering("subscriptions")!
      //       .availablePackages
      //       .firstWhere((element) =>
      //           element.storeProduct.identifier == widget.input.split(',')[2]));

      fetchKeysInapp(
          widget.input.split(',')[0],
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .profile
              ?.name,
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .profile
              ?.email,
          Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext ?? context,
                  listen: false)
              .profile
              ?.mobile,
          customerInfo.nonSubscriptionTransactions[0].revenueCatIdentifier,
          customerInfo.nonSubscriptionTransactions[0].purchaseDate);
    } on PlatformException catch (e) {
      debugPrint("Payment ${e.message} ${e.details}");
      showError("Something went wrong");
    }
  }

  void fetchKeysInapp(
    subscription_id,
    name,
    email,
    phone,
    transaction_id,
    purchase_date,
  ) async {
    final response = await ApiProvider.instance.createOrder(
      subscription_id,
      0,
      name,
      email,
      phone,
      Platform.isAndroid ? "android" : "ios",
    );
    if (response.success ?? false) {
      verifyPaymentInapp(
          response.order?.voucher_no, transaction_id, purchase_date);
    } else {
      showError(response.message ?? "Something went wrong");
    }
  }

  void verifyPaymentInapp(order_code, transaction_id, purchase_date) async {
    final response = await ApiProvider.instance
        .verifyPaymentInapp(order_code, transaction_id, purchase_date);
    if (response.success ?? false) {
      fetchProfile();
      Navigation.instance.goBack();
      showDialogBox();
    } else {
      showError(response.message ?? "Something Went Wrong");
    }
  }

  //PhonePe
  void startPaymentProcessing(id, name, email, phone) {
    var payment_data = {
      "merchantId": FlutterConfig.get('MERCHANT_ID'),
      "merchantTransactionId": "MT7850590068188104",
      "merchantUserId": "MUID123",
      "amount": 10000,
      "callbackUrl": "https://webhook.site/callback-url",
      "mobileNumber": "9999999999",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    initPhonePeSdk(
        environmentValue, FlutterConfig.get('MERCHANT_ID'), enableLogs);
  }

  void initiateOrder(id, i) async {
    final response = await ApiProvider.instance.fetchRazorpay();
    if (response.status ?? false) {
      // order(id, i, response.razorpay!);
    } else {
      showError(response.message ?? "Something went wrong");
    }
  }

  void initPhonePeSdk(environmentValue, merchantId, enableLogs) {
    PhonePePaymentSdk.init(environmentValue, null, merchantId, enableLogs)
        .then((isInitialized) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $isInitialized';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void isPhonePeInstalled() {
    PhonePePaymentSdk.isPhonePeInstalled()
        .then((isPhonePeInstalled) => {
              setState(() {
                result = 'PhonePe Installed - $isPhonePeInstalled';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void isGpayInstalled() {
    PhonePePaymentSdk.isGPayAppInstalled()
        .then((isGpayInstalled) => {
              setState(() {
                result = 'GPay Installed - $isGpayInstalled';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void isPaytmInstalled() {
    PhonePePaymentSdk.isPaytmAppInstalled()
        .then((isPaytmInstalled) => {
              setState(() {
                result = 'Paytm Installed - $isPaytmInstalled';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void getPackageSignatureForAndroid() {
    if (Platform.isAndroid) {
      PhonePePaymentSdk.getPackageSignatureForAndroid()
          .then((packageSignature) => {
                setState(() {
                  result = 'getPackageSignatureForAndroid - $packageSignature';
                })
              })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    }
  }

  void getInstalledUpiAppsForiOS() {
    if (Platform.isIOS) {
      PhonePePaymentSdk.getInstalledUpiAppsForiOS()
          .then((apps) => {
                setState(() {
                  result = 'getUPIAppsInstalledForIOS - $apps';

                  // For Usage
                  List<String> stringList = apps
                          ?.whereType<
                              String>() // Filters out null and non-String elements
                          .toList() ??
                      [];

                  // Check if the string value 'Orange' exists in the filtered list
                  String searchString = 'PHONEPE';
                  bool isStringExist = stringList.contains(searchString);

                  if (isStringExist) {
                    print('$searchString app exist in the device.');
                  } else {
                    print('$searchString app does not exist in the list.');
                  }
                })
              })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    }
  }

  void getInstalledApps() {
    if (Platform.isAndroid) {
      getInstalledUpiAppsForAndroid();
    } else {
      getInstalledUpiAppsForiOS();
    }
  }

  void getInstalledUpiAppsForAndroid() {
    PhonePePaymentSdk.getInstalledUpiAppsForAndroid()
        .then((apps) => {
              setState(() {
                if (apps != null) {
                  Iterable l = json.decode(apps);
                  List<UPIApp> upiApps = List<UPIApp>.from(
                      l.map((model) => UPIApp.fromJson(model)));
                  String appString = '';
                  for (var element in upiApps) {
                    appString +=
                        "${element.applicationName} ${element.version} ${element.packageName}";
                  }
                  result = 'Installed Upi Apps - $appString';
                } else {
                  result = 'Installed Upi Apps - 0';
                }
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startTransaction() async {
    try {
      PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName)
          .then((response) => {
                setState(() {
                  if (response != null) {
                    String status = response['status'].toString();
                    String error = response['error'].toString();
                    if (status == 'SUCCESS') {
                      result = "Flow Completed - Status: Success!";
                    } else {
                      result =
                          "Flow Completed - Status: $status and Error: $error";
                    }
                  } else {
                    result = "Flow Incomplete";
                  }
                })
              })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      if (error is Exception) {
        result = error.toString();
      } else {
        result = {"error": error};
      }
    });
  }

  //Common

  void fetchProfile() async {
    // Navigation.instance.navigate('/loadingDialog');
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
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setFloatingButton(response.floating_button!);
      // Navigation.instance.goBack();
    } else {
      // Navigation.instance.goBack();
    }
  }

  void showDialogBox() {
    logTheSubscriptionSuccessfulClick(Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .profile!);
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
          content: const ShowDialogBoxContent(),
        );
      },
    );
  }

  void getUserInformation(
      String? redirect_url, m_subscription_id, m_user_id) async {
    name.text =
        Provider.of<DataProvider>(context, listen: false).profile?.name ?? "";
    email.text =
        Provider.of<DataProvider>(context, listen: false).profile?.email ?? "";
    phone.text =
        Provider.of<DataProvider>(context, listen: false).profile?.mobile ?? "";
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Storage.instance.isDarkMode ? Colors.black : Colors.white,
      builder: (BuildContext context) {
        return GetUserInformationBody(
            name: name,
            email: email,
            phone: phone,
            onTap: () async {
              if (name.text.isNotEmpty &&
                  phone.text.isNotEmpty) {
                // fetchKeys(widget.input.split(',')[0], name.text, email.text,
                //     phone.text);
                debugPrint("Soemn ${redirect_url}");
                // final resp = await Navigation.instance
                //     .navigate("/recurring_payment", args: redirect_url);
                setState(() {
                  merchant_subscription_id = m_subscription_id;
                  merchant_user_id = m_user_id;
                });
                GetUPI.openNativeIntent(
                  url: redirect_url!,
                );
              } else {
                showError("All the details are mandatory");
              }
            });
      },
    );
  }

  void fetchPhonepe(subscription_id) async {
    final response = await ApiProvider.instance.phonepeApi(subscription_id, 0);
    if (response.success ?? false) {
      setState(() {
        orderId = response.result?.order_code;
      });
      getUserInformation(
          response.result?.redirect_url,
          response.result?.merchant_subscription_id,
          response.result?.merchant_user_id);
    } else {
      showError(response.message ?? "Something went wrong");
    }
  }

  void logTheSubscriptionSuccessfulClick(Profile profile) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "subscription_successfull",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        "screen_name": "subscription",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  Future<bool> checkForOrders(
    order_code,
    merchant_subscription_id,
    merchant_user_id,
  ) async {
    final response = await ApiProvider.instance.PhonepePaymentVerify(
        order_code, merchant_user_id, merchant_subscription_id);
    if (response.success ?? false) {
      return response.success ?? false;
    } else {
      showError(response.message ?? "Something went wrong");
      return response.success ?? false;
    }
  }
}
