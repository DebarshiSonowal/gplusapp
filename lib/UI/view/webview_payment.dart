import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPayment extends StatefulWidget {
  const WebviewPayment({super.key, required this.url});

  final String url;

  @override
  State<WebviewPayment> createState() => _WebviewPaymentState();
}

class _WebviewPaymentState extends State<WebviewPayment> {
  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<WebViewController>(
        builder: (context, val) {
          if (val.hasError) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Something Went Wrong",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black87,
                        fontSize: 14.sp,
                      ),
                ),
              ),
            );
          }
          if (val.hasData && val.data != null ) {
            return WebViewWidget(controller: val.data!);
          }
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        },
        future: initController(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async{
      final resp = await _launchUrl(widget.url);
      if(resp){
        Navigator.pop(context,resp);
      }
      // controller?.loadRequest(
      //   Uri.parse(
      //     // "https://mercury-uat.phonepe.com/transact/simulator?token=9E7mYEWviFlagB06K57DXxQpeHfDcRETOhbtSdZaS8",
      //     widget.url,
      //   ),
      // );
      // "upi://mandate?pn=SUBSCRIBEMID&pa=MID12345@ybl&tid=YBL6663638d0312408a8f54f7df8f1bd6b9&tr=P1812191027266848105909&am=399.00&mam=399.00&cu=INR&url=https://phonepe.com&mc=7299&tn=Payment%20for%20TXN123456789&utm_source=TXN123456789&utm_medium=MID12345&utm_campaign=SUBSCRIBE_AUTH"));
      debugPrint("");
    });
  }

  Future<WebViewController> initController() async {
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
            //upi://mandate?pn=SUBSCRIBEMID&pa=MID12345@ybl&tid=YBL6663638d0312408a8f54f7df8f1bd6b9&tr=P1812191027266848105909&am=399.00&mam=399.00&cu=INR&url=https://phonepe.com&mc=7299&tn=Payment%20for%20TXN123456789&utm_source=TXN123456789&utm_medium=MID12345&utm_campaign=SUBSCRIBE_AUTH
            if (request.url.startsWith(
                'https://mercury-uat.phonepe.com/transact/simulator?token=9E7mYEWviFlagB06K57DXxQpeHfDcRETOhbtSdZaS8')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    return Future.value(controller);
  }
  Future<bool> _launchUrl(_url) async {
   final response = await launchUrl(Uri.parse(_url),mode: LaunchMode.externalApplication);
   return response;
  }
}
