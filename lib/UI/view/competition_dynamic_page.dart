import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Helper/Constance.dart';
import '../../Helper/DataProvider.dart';
import '../../Helper/Storage.dart';

class CompetitionDynamicPage extends StatefulWidget {
  const CompetitionDynamicPage({super.key, required this.url});

  final String url;

  @override
  State<CompetitionDynamicPage> createState() => _CompetitionDynamicPageState();
}

class _CompetitionDynamicPageState extends State<CompetitionDynamicPage> {
  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigation.instance.goBack();
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: GestureDetector(
          onTap: () {},
          child: Image.asset(
            Constance.logoIcon,
            fit: BoxFit.fill,
            scale: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Constance.primaryColor,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: WebViewWidget(
            controller: controller ?? WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(Colors.white)
              ..setUserAgent("GPlus/WebApp")
              ..addJavaScriptChannel(
                "MobileApp",
                onMessageReceived: (JavaScriptMessage msg) async{
                  debugPrint(msg.message);
                  // String id = await FirebaseAnalytics.instance.appInstanceId ?? "";
                  // await FirebaseAnalytics.instance.logEvent(
                  //   name: "gfa_vote",
                  //   parameters: {
                  //     "login_status": Storage.instance.isLoggedIn ? "logged_in" : "guest",
                  //     "client_id_event": id,
                  //     "user_id_event": Provider.of<DataProvider>(
                  //         Navigation.instance.navigatorKey
                  //             .currentContext ??
                  //             context,
                  //         listen: false)
                  //         .profile!.id,
                  //     "category_name": msg,
                  //   },
                  // );
                },
              )
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    // Update loading bar.
                  },
                  onPageStarted: (String url) {},
                  onPageFinished: (String url) {},
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (NavigationRequest request) {
                    if (request.url.startsWith('https://www.youtube.com/')) {
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(
                Uri.parse(widget.url),
              )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    });
    setState(() {});
  }
}
