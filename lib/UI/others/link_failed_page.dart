import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gplusapp/Components/custom_button.dart';
import 'package:sizer/sizer.dart';

// import 'package:uni_links/uni_links.dart';

import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class LinkFailedPage extends StatefulWidget {
  final String path;

  const LinkFailedPage({Key? key, required this.path}) : super(key: key);

  @override
  State<LinkFailedPage> createState() => _LinkFailedPageState();
}

class _LinkFailedPageState extends State<LinkFailedPage> {
  StreamSubscription? _sub;

  // void sendToRoute(String route, data, String? category) async {
  //   print("our route ${route}");
  //   switch (route) {
  //     case "story":
  //       // Navigation.instance.navigate('/main');
  //       print("this route");
  //       Navigation.instance.navigate('/story', args: '${category},${data}');
  //       break;
  //     case "opinion":
  //       Navigation.instance
  //           .navigate('/opinionDetails', args: '${data},${category}');
  //       break;
  //     default:
  //       debugPrint("deeplink failed 1 ${route}");
  //       Navigation.instance.navigate(
  //         '/link_failed',
  //         args: ""
  //       );
  //       break;
  //   }
  // }

  // Future<void> initUniLinksResume() async {
  //   // ... check initialUri
  //
  //   // Attach a listener to the stream
  //   _sub = uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       print("deeplink2 ${uri.toString().split("/")}");
  //       sendToRoute(
  //           uri.toString().split("/")[4],
  //           uri.toString().split("/")[5],
  //           (uri.toString().split("/").length <= 6
  //               ? ""
  //               : uri.toString().split("/")[6]));
  //     } else {
  //       Navigation.instance.navigate(
  //         '/link_failed',
  //       );
  //     }
  //     // Use the uri and warn the user, if it is not correct
  //   }, onError: (err) {
  //     // Handle exception by warning the user their action did not succeed
  //     Navigation.instance.navigate(
  //       '/link_failed',
  //     );
  //   });
  //
  //   // NOTE: Don't forget to call _sub.cancel() in dispose()
  // }
  //
  // Future<void> initUniLinks() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     final initialLink = await getInitialLink();
  //     if (initialLink != null) {
  //       print("deeplink1 ${initialLink.split("/")}");
  //       sendToRoute(
  //           initialLink.split("/")[4],
  //           initialLink.split("/")[5],
  //           (initialLink.split("/").length <= 6
  //               ? ""
  //               : initialLink.split("/")[6]));
  //     } else {
  //       initUniLinksResume();
  //     }
  //     // Parse the link and warn the user, if it is not correct,
  //     // but keep in mind it could be `null`.
  //   } on PlatformException {
  //     // Handle exception by warning the user their action did not succeed
  //     // return?
  //     Navigation.instance.navigate(
  //       '/link_failed',
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Constance.primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Constance.logoIcon,
              scale: 1,
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Something went wrong with your link.',
              style: Theme.of(Navigation.instance.navigatorKey.currentContext!)
                  .textTheme
                  .headline4
                  ?.copyWith(
                    color: Colors.white,
                    // fontSize: 2.2.h,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Please check it again.',
              style: Theme.of(Navigation.instance.navigatorKey.currentContext!)
                  .textTheme
                  .headline4
                  ?.copyWith(
                    color: Colors.white,
                    // fontSize: 2.2.h,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: 2.h,
            ),
            CustomButton(
              txt: 'Reload',
              onTap: () {
                Navigation.instance.navigateAndRemoveUntil('/main');
              },
            ),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // initUniLinks();
    checkForLinks();
  }

  void checkForLinks() {
    debugPrint("path ${widget.path}");
    // if (widget.path.contains("/link")){
    //   Navigation.instance.goBack();
    //   // sendToRoute(
    //   //     widget.path.split("/")[1].trim(),
    //   //     widget.path.split("/")[2].trim(),
    //   //     (widget.path.split("/").length <= 3
    //   //         ? ""
    //   //         : widget.path.split("/")[3].trim()));
    // }

  }
}
