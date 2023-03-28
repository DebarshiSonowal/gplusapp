import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Components/search_item_card.dart';
import '../../../Helper/Constance.dart';
import '../../../Helper/Storage.dart';
import '../../../Model/search_result.dart';
import '../../../Navigation/Navigate.dart';
import '../../../Networking/api_provider.dart';

class OthersSection extends StatelessWidget {
  const OthersSection({Key? key, required this.isEmpty}) : super(key: key);
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return data.othersearchlist.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (cont, count) {
                var item = data.othersearchlist[count];
                return GestureDetector(
                  onTap: () {
                    if (item.has_permission ?? false) {
                      setAction(item, context, data);
                    } else {
                      Constance.showMembershipPrompt(cont, () {
                        // setState(() {
                        //   showing = false;
                        // });
                      });
                    }
                  },
                  child: SearchItemCard(item: item),
                );
              },
              separatorBuilder: (cont, inde) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: SizedBox(
                    height: 1.h,
                    child: Divider(
                      color: Storage.instance.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      thickness: 0.3.sp,
                    ),
                  ),
                );
              },
              itemCount: data.othersearchlist.length)
          : Lottie.asset(
              isEmpty ? Constance.noDataLoader : Constance.searchingIcon,
            );
    });
  }

  void setAction(OthersSearchResult item, context, DataProvider data) {
    switch (item.type) {
      case 'guwahati-connect':
        if (data.guwahatiConnect.isNotEmpty) {
          if (data.guwahatiConnect
              .where((element) => element.id == item.id)
              .isNotEmpty) {
            Navigation.instance.navigate(
              '/allImagesPage',
              args: int.parse(data.guwahatiConnect
                  .where((element) => element.id == item.id)
                  .first
                  .id
                  .toString()),
            );
          } else {
            Fluttertoast.showToast(msg: "Oops! This post is not available");
          }
        } else {
          fetchGuwahatiConnect(item.id);
        }

        break;
      case 'classified':
        Navigation.instance.navigate('/classifiedDetails', args: item.id);
        break;
      case 'vendor':
        Navigation.instance.navigate('/categorySelect', args: item.id);
        break;
    }
  }

  void fetchGuwahatiConnect(id) async {
    Navigation.instance.navigate('/loadingDialog');
    final response = await ApiProvider.instance.getGuwahatiConnect();
    if (response.success ?? false) {
      // setGuwahatiConnect
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setGuwahatiConnect(response.posts);
      if (Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .guwahatiConnect
          .where((element) => element.id == id)
          .isNotEmpty) {
        Navigation.instance.navigate(
          '/allImagesPage',
          args: int.parse(Provider.of<DataProvider>(
                  Navigation.instance.navigatorKey.currentContext!,
                  listen: false)
              .guwahatiConnect
              .where((element) => element.id == id)
              .first
              .id
              .toString()),
        );
      } else {
        Fluttertoast.showToast(msg: "Oops! This post is not available");
      }
    } else {
      Navigation.instance.goBack();
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext!,
              listen: false)
          .setGuwahatiConnect(response.posts);
    }
  }
}
