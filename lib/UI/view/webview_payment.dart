import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPayment extends StatefulWidget {
  const WebviewPayment({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<WebviewPayment> createState() => _WebviewPaymentState();
}

class _WebviewPaymentState extends State<WebviewPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigation.instance.goBack();
        },
        child: const Icon(
          Icons.close,
          color: Constance.thirdColor,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          javascriptChannels: {
            JavascriptChannel(
              name: "Print",
              onMessageReceived: (JavascriptMessage message) {
                debugPrint(message.message);
              },
            ),

          },
        ),
      ),
    );
  }
}
