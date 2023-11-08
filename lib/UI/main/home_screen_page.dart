import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

// import 'package:encrypt/encrypt.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:encrypt/encrypt.dart' as Enc;

// import 'package:encrypt/encrypt.dart';
import 'package:aespack/aespack.dart';

// import 'package:encryptions/encryptions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/FirebaseHelper.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:gplusapp/UI/main/sections/home_screen_body.dart';
import 'package:gplusapp/UI/main/sections/internet_issue_screen.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

// import 'package:uni_links/uni_links.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/NavigationBar.dart';
import '../../Helper/Constance.dart';
import '../../Helper/UpgraderTextCustom.dart';
import '../../Model/notification_received.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../../main.dart';
import '../Menu/berger_menu_member_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int current = 0, currentPage = 0;
  int random = 0;
  final ScrollController controller = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showing = false;

  // final _listController = PageController(keepPage: true, viewportFraction: 0.8);

  String _poll = Constance.pollWeek[0];

  StreamSubscription? _sub;

  void sendToRoute(String route, data, String? category) async {
    debugPrint("our route $route $data $category");
    switch (route) {
      // case "story":
      //   // Navigation.instance.navigate('/main');
      //   // print("this route");
      //   Navigation.instance
      //       .navigate('/story', args: '$category,$data,home_page');
      //   break;
      case "opinion":
        Navigation.instance
            .navigate('/opinionDetails', args: '$data,$category');
        break;
      default:
        Navigation.instance
            .navigate('/story', args: '$category,$data,home_page');
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    // _listController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint("didChangeAppLifecycleState $state");
    if (state == AppLifecycleState.resumed) {
      // getDynamicLink();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setUserProperty(Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .profile);
    // secureScreen();
    Future.delayed(Duration.zero, () => fetchDetails(context));
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          _refreshController.requestRefresh();
        } else {
          // print('At the bottom');
        }
      }
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    fetchPoll();
    fetchOpinion();
    fetchGPlusExcl();
    fetchToppicks();
    fetchAds();
    final result = await ApiProvider.instance.getHomeAlbum();
    if (result.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeAlbum(result.articles ?? []);

      final response = await ApiProvider.instance.getWeekly();
      if (response.success ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setVideoWeekly(response.videos ?? []);
        _refreshController.refreshCompleted();
      }
    } else {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        // debugDisplayAlways: true,
        // debugDisplayOnce: true,
        willDisplayUpgrade: (
            {String? appStoreVersion,
            bool? display,
            String? installedVersion,
            String? minAppVersion}) async {
          // print(
          //     "#123 $appStoreVersion | $display | $installedVersion | $minAppVersion");
          if ((Storage.instance.lastDisplayed == "" ||
                  (DateFormat("dd/MM/yyyy").format(
                          DateTime.parse(Storage.instance.lastDisplayed)) ==
                      DateFormat("dd/MM/yyyy").format(DateTime.now()))) &&
              (display ?? false)) {
            Storage.instance.setLastDisplayed(
                DateFormat("dd/MM/yyyy").format(DateTime.now()));
            return Future(() => true);
          }
          return Future(() => false);
        },
        durationUntilAlertAgain: const Duration(days: 3),
        dialogStyle: UpgradeDialogStyle.cupertino,
        messages: MyCustomMessages(),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            Storage.instance.isDarkMode ? Colors.black : Colors.grey.shade100,
        appBar: Constance.buildAppBar("home", true, _scaffoldKey),
        // floatingActionButtonLocation: showing
        //     ? FloatingActionButtonLocation.miniStartFloat
        //     : FloatingActionButtonLocation.miniEndFloat,
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.green,
        //   onPressed: () {
        //     _launchUrl(
        //         Uri.parse('whatsapp://send?phone=919365974702&text=Hi+G+Plus!'));
        //   Navigation.instance.navigate("/competitions");
        //   },
        //   child: Icon(
        //     FontAwesomeIcons.whatsapp,
        //     color: Colors.white,
        //     size: 22.sp,
        //   ),
        // ),
        floatingActionButton:
            Consumer<DataProvider>(builder: (context, data, _) {
          return (data.floating_button?.status ?? false)
              ? FloatingActionButton(
                  backgroundColor: (data.floating_button?.color == null|| data.floating_button?.image_url != "")
                      ? Colors.transparent
                      : hexToColor(
                          data.floating_button?.color.toString() ?? "#7CFC00"),
                  onPressed: () {
                    var encrypted = getEncrypted(data);
                    // while(encrypted.base64.toString().contains("+")){
                    //   encrypted = getEncrypted(data);
                    // }
                    Navigation.instance.navigate("/competitions",
                        args:
                            "${data.floating_button?.url}?key=${encrypted.base64}");
                  },
                  // child: Text(
                  //   "${data.floating_button?.text}",
                  //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //         color: Colors.black,
                  //       ),
                  // ),
                  child: data.floating_button?.image_url == ""
                      ? Text(
                          "${data.floating_button?.text}",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.black,
                                  ),
                        )
                      : CachedNetworkImage(
                          imageUrl: data.floating_button!.image_url!,
                    height: 35.sp,
                    width: 35.sp,
                        ),
                )
              : Container();
        }),
        drawer: const BergerMenuMemPage(
          screen: "home",
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return connected
                ? HomeScreenBody(
                    refreshController: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    showExitDialog: showExitDialog,
                    controller: controller,
                    random: random,
                    fetchPoll: fetchPoll,
                    poll: _poll,
                    getSpace: getSpace,
                  )
                : const InternetIssueScreen();
          },
          child: Container(),
        ),
        bottomNavigationBar: CustomNavigationBar(current, "home"),
      ),
    );
  }

  Future<void> fetchOpinion() async {
    final response = await ApiProvider.instance.getLatestOpinion();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setLatestOpinions(response.opinion ?? []);
    } else {
      // fetchGPlusExcl();
    }
  }

  void fetchToppicks() async {
    final response = await ApiProvider.instance.getTopPicks(1);
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeTopPicks(response.toppicks ?? []);
      // fetchAds();
    } else {
      // fetchAds();
    }
  }

  Future<void> fetchGPlusExcl() async {
    final response = await ApiProvider.instance.getArticle('exclusive-news');
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeExecl(response.articles ?? []);
    } else {
      // fetchPoll();
    }
  }

  Future<void> fetchPoll() async {
    final response = await ApiProvider.instance.getPollOfTheWeek();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setPollOfTheWeek(response.pollOfTheWeek!);
      if (response.pollOfTheWeek?.is_polled != 'false') {
        if (mounted) {
          setState(() {
            _poll = response.pollOfTheWeek?.is_polled ?? "";
          });
        }
      }
      fetchToppicks();
    } else {
      fetchToppicks();
    }
  }

  void fetchAds() async {
    final response = await ApiProvider.instance.getAdvertise();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAds(response.ads ?? []);
      random = Random().nextInt(response.ads?.length ?? 0);
      // fetchAds();
      askPermissions();
      fetchNotification();
    } else {
      askPermissions();
      fetchNotification();
    }
    final response1 = await ApiProvider.instance.getAdImage();
    if (response1.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setAdImage(response1.link!, response1.data!);
      if (mounted) {
        // setState(() {});
      }
    } else {}
    final response2 = await ApiProvider.instance.getFullScreenAdvertise();
    if (response2.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setFullAd(response2.link!, response2.data!);
    }
  }

  Future<void> fetchHome() async {
    final result = await ApiProvider.instance.getHomeAlbum();
    if (result.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setHomeAlbum(result.articles ?? []);

      final response = await ApiProvider.instance.getWeekly();
      if (response.success ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setVideoWeekly(response.videos ?? []);
        // _refreshController.refreshCompleted();
      }
    } else {
      // _refreshController.refreshFailed();
      // fetchOpinion();
    }
  }

  Future<void> _launchUrl(_url) async {
    if (await canLaunchUrl(_url)) {
      launchUrl(_url);
    } else {
      launchUrl(
        Uri.parse('https://api.whatsapp.com/send?phone=919365974702'),
      );
    }
  }

  void askPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        debugPrint("We got location permissions");
      } else {
        debugPrint("We require location permissions");
      }
    } else {
      debugPrint("We got location permissions already");
    }
  }

  Future<void> fetchProfile() async {
    debugPrint('object profile');
    // Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getprofile();
    if (response.success ?? false) {
      // Navigation.instance.goBack();
      debugPrint('object profile');
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
      // initUniLinks();
      // initUniLinksResume();
    } else {
      // Navigation.instance.goBack();
    }
  }

  void showPopUp() {
    double doubleInRange(Random source, num start, num end) =>
        source.nextDouble() * (end - start) + start;
    // Future.delayed(
    //     Duration(milliseconds: doubleInRange(Random(), 10000, 20000).toInt()),
    //     () {
    //   // code will be here
    //   if (Provider.of<DataProvider>(
    //               Navigation.instance.navigatorKey.currentContext ??
    //                   (_scaffoldKey.currentContext!),
    //               listen: false)
    //           .profile
    //           ?.is_plan_active ??
    //       false) {
    //   } else {
    //     // showDialogBox();
    //     Constance.showMembershipPrompt2(_scaffoldKey.currentState!);
    //   }
    // });
    // Future.delayed(Duration(seconds: 5), () => Navigation.instance.navigate("/fullScreenAd"));
    Timer.periodic(const Duration(hours: 2), (timer) {
      if (!Storage.instance.isFullScreenAd) {
        Navigation.instance.navigate("/fullScreenAd");
        Storage.instance.setFullScreenAd(true);
      }
    });
  }

  void showExitDialog() {
    Dialogs.materialDialog(
        msg: 'Are you sure ? you want to exit',
        title: "Exit",
        color: Colors.white,
        context: context,
        titleStyle: Theme.of(context).textTheme.headline2!.copyWith(
              color: Colors.black,
            ),
        msgStyle: Theme.of(context).textTheme.headline5!.copyWith(
              color: Colors.black,
            ),
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigation.instance.goBack();
            },
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              logTheExitAppClick(
                Provider.of<DataProvider>(
                        Navigation.instance.navigatorKey.currentContext ??
                            context,
                        listen: false)
                    .profile!,
                // String sort_applied,
              );
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            text: 'Exit',
            iconData: Icons.exit_to_app,
            color: Constance.thirdColor,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  void logTheExitAppClick(
    Profile profile,
    // String sort_applied,
  ) async {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
    // String id = await FirebaseInstallations.instance.getId();
    await FirebaseAnalytics.instance.logEvent(
      name: "exit_app",
      parameters: {
        "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id_event": id,
        "user_id_event": profile.id,
        // "sort_applied": sort_applied,
        "screen_name": "app_exit",
        "user_login_status":
            Storage.instance.isLoggedIn ? "logged_in" : "guest",
        "client_id": id,
        "user_id_tvc": profile.id,
      },
    );
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> fetchStories() async {
    final response = await ApiProvider.instance.getStories();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setStories(response.stories);
    } else {}
  }

  getSpace() {
    if (Platform.isAndroid) {
      return SizedBox(
        height: 20.h,
      );
    } else if (Platform.isIOS) {
      return SizedBox(
        height: 30.h,
      );
    }
  }

  void fetchReportMsg() async {
    final response = await ApiProvider.instance.getReportMsg();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setReportModel(response.reports);
      fetchRedeemMsg();
    } else {
      fetchRedeemMsg();
    }
  }

  void fetchRedeemMsg() async {
    final response = await ApiProvider.instance.getReferEarnText();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setReferEarnText(response.desc ?? "");
    } else {}
    final response1 = await ApiProvider.instance.getRedeemText();
    if (response1.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setRedeemText(response1.desc ?? "");
    } else {}
    final response2 = await ApiProvider.instance.getCitizenText();
    if (response2.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCitizenJournalistText(response2.desc!);
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setCitizenJournalistPermission(response2.has_permission ?? false);
    }
  }

  Future<void> fetchNotification() async {
    final response = await ApiProvider.instance.getNotifications();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setNotificationInDevice(response.notification);
      fetchReportMsg();
    } else {
      fetchReportMsg();
    }
  }

  void setUserProperty(Profile? profile) async {
    FirebaseAnalytics.instance.setUserProperty(
        name: "client_id",
        value: await FirebaseAnalytics.instance.appInstanceId);
    FirebaseAnalytics.instance
        .setUserProperty(name: "user_id_tvc", value: profile!.id.toString());
    FirebaseAnalytics.instance.setUserProperty(
        name: "user_login_status",
        value: Storage.instance.isLoggedIn ? "logged_in" : "guest");
  }

  Future<void> getDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLinkData) {
      if (dynamicLinkData != null) {
        final Uri deepLink = dynamicLinkData.link;
        debugPrint("URL link2 ${deepLink.path.split("/")}");
        Future.delayed(const Duration(seconds: 0), () {
          if (Storage.instance.isLoggedIn) {
            bool isOpinion = deepLink.path.split("/")[1] == "opinion";
            sendToRoute(
              isOpinion
                  ? dynamicLinkData.link.path.split("/")[1].trim()
                  : dynamicLinkData.link.path.split("/")[2].trim(),
              isOpinion
                  ? dynamicLinkData.link.path.split("/")[3].trim()
                  : dynamicLinkData.link.path.split("/")[2].trim(),
              (isOpinion
                  ? dynamicLinkData.link.path.split("/")[2].trim()
                  : dynamicLinkData.link.path.split("/")[1].trim()),
            );
          }
        });
      } else {
        debugPrint("Show Empty Link");
      }
    });

    // final PendingDynamicLinkData? dynamicLinkData =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // if (dynamicLinkData != null) {
    //   final Uri deepLink = dynamicLinkData.link;
    //   debugPrint("URL link2 $deepLink");
    //   Future.delayed(const Duration(seconds: 0), () {
    //     if (Storage.instance.isLoggedIn) {
    //       bool isOpinion = dynamicLinkData.link.path.split("/").length == 4;
    //       sendToRoute(
    //         dynamicLinkData.link.path.split("/")[1].trim(),
    //         isOpinion
    //             ? dynamicLinkData.link.path.split("/")[3].trim()
    //             : dynamicLinkData.link.path.split("/")[2].trim(),
    //         (isOpinion
    //             ? dynamicLinkData.link.path.split("/")[2].trim()
    //             : dynamicLinkData.link.path.split("/")[1].trim()),
    //       );
    //     }
    //   });
    // }else{
    //   debugPrint("Show Empty Link");
    // }
  }

  void fetchDetails(BuildContext context) async {
    var status = await Permission.notification.status;

    // If permission is not granted, request it.
    if (status != PermissionStatus.granted) {
      await Permission.notification.request();
    }

    // If permission is granted, show a notification.
    if (status == PermissionStatus.granted) {
      FirebaseMessaging.instance.getInitialMessage().then(
            (RemoteMessage? value) => setState(
              () {
                debugPrint("Initial!@8 1$value");
                String initialMessage = "${value?.data}";
                debugPrint("Initial!@8 2$initialMessage");
                if (value!.data.isNotEmpty) {
                  debugPrint("Notification Payload ${value.data}");
                  var propertyPattern = RegExp(r'(\w+): ([^,]+)');

                  var json = <String, String?>{};

                  propertyPattern.allMatches("${value.data}").forEach((match) {
                    var propertyName = match.group(1);
                    var propertyValue = match.group(2);

                    json[propertyName!] = propertyValue!.trim();
                  });
                  NotificationReceived notification =
                      // NotificationReceived.fromJson(jsonDecode(jsData1));
                      NotificationReceived.fromJson(json);
                  // Navigation.instance.navigate('');

                  NotificationHelper.setRead(
                      notification.notification_id,
                      notification.seo_name,
                      notification.seo_name_category,
                      notification.type,
                      notification.post_id,
                      notification.vendor_id,
                      notification.category_id);
                }
              },
            ),
          );
    }
    Provider.of<DataProvider>(
            Navigation.instance.navigatorKey.currentContext ?? context,
            listen: false)
        .setCurrent(0);
    await fetchProfile();

    await fetchStories();
    await fetchHome();
    await fetchOpinion();
    await fetchGPlusExcl();
    await fetchPoll();
    await fetchNotification();

    getDynamicLink();
    showPopUp();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.replaceAll('#', '0xFF')));
  }

  void encrypt(DataProvider data, String txt, key, iv) async {
    var text = txt;
    debugPrint(stringToBinary(key.toString()));
    var result = await Aespack.encrypt(text,
        "1A3D271CE36D07B79DD9E699D5A6F469731F80B6E4F2F9F1CC52F33BB7EF69B1", iv);
    debugPrint(result);
    Navigation.instance.navigate("/competitions",
        args: "${data.floating_button?.url}/$result");
  }

  String stringToBinary(String text) {
    List<int> bytes = text.codeUnits;
    String binaryString = '';
    for (int byte in bytes) {
      binaryString += byte.toRadixString(2).padLeft(8, '0');
    }
    return binaryString;
  }

  getEncrypted(DataProvider data) {
    final plainText =
        "${data.profile?.id}_${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}";
    final key = Enc.Key.fromBase64(
        FlutterConfig.get('AES_ENCRYPTION_KEY'));
    final iv = Enc.IV.fromBase64(FlutterConfig.get('IV'));
    final encrypter =
    Enc.Encrypter(Enc.AES(key, mode: Enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    debugPrint(
        "$plainText ${data.floating_button?.url}?key=${encrypted.base64}");
    return encrypted;
  }
}
