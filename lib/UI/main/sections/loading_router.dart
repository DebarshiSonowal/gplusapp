import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';

import '../../../Helper/Storage.dart';
import '../../../Navigation/Navigate.dart';

class LoadingRouter extends StatefulWidget {
  const LoadingRouter({super.key, required this.deepLink});
  final String deepLink;
  @override
  State<LoadingRouter> createState() => _LoadingRouterState();
}

class _LoadingRouterState extends State<LoadingRouter> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(child:  CircularProgressIndicator(
          color: Constance.primaryColor,
        )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      Navigation.instance.navigateAndRemoveUntil("/main");
      debugPrint("OWE ${widget.deepLink.split("/")}");
      if (Storage.instance.isLoggedIn) {
        bool isOpinion = widget.deepLink.split("/")[3] == "opinion";
        sendToRoute(
          widget.deepLink.split("/")[3].trim(),
          isOpinion
              ? widget.deepLink.split("/")[5].trim()
              : widget.deepLink.split("/")[4].trim(),
          (isOpinion
              ? widget.deepLink.split("/")[4].trim()
              : widget.deepLink.split("/")[3].trim()),
        );
      }
    });
  }
  void sendToRoute(String route, data, String? category) async {
    debugPrint("our route $route $data $category");
    switch (route) {
      // case "story":
      // // Navigation.instance.navigate('/main');
      // // print("this route");
      //   Navigation.instance
      //       .navigate('/story', args: '$category,$data,home_page');
      //   break;
      case "poll_of_the_week":
        debugPrint("poll of the week ${Navigation.instance.navigatorKey.currentContext?.owner} \n ${ModalRoute.of(Navigation.instance.navigatorKey.currentContext!)?.settings.name} \n");
        Navigation.instance
            .pushNamedIfNotCurrent('/pollPage',);
        break;
      case "opinion":
        Navigation.instance
            .navigate('/opinionDetails', args: '$data,$category');
        break;
      // Navigation.instance.navigate('/main');
      // print("this route");
        Navigation.instance
            .navigate('/story', args: '$category,$data,home_page');
        break;
      default:
        Navigation.instance
            .navigate('/story', args: '$category,$data,home_page');
        break;
        // debugPrint("deeplink failed 1 ${route}");
        // // Navigation.instance.navigate(
        // //     '/link_failed',args: ""
        // // );
        // break;

    }
  }

}
