import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Components/custom_button.dart';
import '../../Helper/Constance.dart';
import '../../Model/profile.dart';
import '../../Navigation/Navigate.dart';
import '../../Networking/api_provider.dart';

class RedeemOfferPage extends StatefulWidget {
  const RedeemOfferPage({Key? key}) : super(key: key);

  @override
  State<RedeemOfferPage> createState() => _RedeemOfferPageState();
}

class _RedeemOfferPageState extends State<RedeemOfferPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchDeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Constance.buildAppBar2("bigdeal"),
      // drawer: const BergerMenuMemPage(screen: "bigdeal"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Storage.instance.isDarkMode ? Colors.black : Colors.white,
        // padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Consumer<DataProvider>(builder: (context, data, _) {
          return Stack(
            // alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 30.h,
                      // color: Colors.black,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(
                            data.details?.image_file_name ??
                                Constance.salonImage,
                          ),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   // flex: 4,
                    //   child: Container(),
                    // ),
                  ],
                ),
              ),
              Align(
                heightFactor: 1.7,
                child: SizedBox(
                  // height: 200,
                  width: 90.w,

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.5.h),
                          // height: 35.h,
                          width: 90.w,
                          decoration: const BoxDecoration(
                            color: const Color(0xfffec715),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Congratulations',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              Text(
                                'You have just redeemed your offer code for',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),
                              Text(
                                data.details?.shop_name ?? 'The Looks Saloon',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              Text(
                                data.redeemDetails?.title ??
                                    'Flat 20% off on all items',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.5.h, horizontal: 2.w),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          data.redeemDetails?.code ?? '8488',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              ?.copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await Clipboard.setData(
                                          ClipboardData(
                                              text: data.redeemDetails?.code ??
                                                  '8488'),
                                        );
                                        showInSnackBar(
                                            "Coupon Code copied successfully");
                                      },
                                      icon: const Icon(
                                        Icons.copy,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                '* The offer expires of ${Jiffy.parse(data.redeemDetails?.valid_to ?? "0000-00-00", pattern: "yyyy-MM-dd").format(pattern: "dd/MM/yyyy")}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                      color: Colors.black,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        SizedBox(
                          width: 90.w,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.zero,
                            child: ExpansionTile(
                              title: Text(
                                'Offer Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              collapsedBackgroundColor: Constance.forthColor,
                              backgroundColor: Constance.forthColor,
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  child: Text(
                                    data.redeemDetails?.description ??
                                        'when an unknown printer took a galley of type'
                                            ' and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        SizedBox(
                          width: 90.w,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            margin: EdgeInsets.zero,
                            child: ExpansionTile(
                              iconColor: Colors.black,
                              collapsedIconColor: Colors.black,
                              title: Text(
                                'Disclaimer',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              collapsedBackgroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  child: Text(
                                    data.redeemDetails?.disclaimer ??
                                        ' is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using '
                                            '\'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum '
                                            'as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // color: Constance.secondaryColor,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }





  void fetchDeals() async {
    final response = await ApiProvider.instance.getPromotedDeals();
    if (response.success ?? false) {
      Provider.of<DataProvider>(
              Navigation.instance.navigatorKey.currentContext ?? context,
              listen: false)
          .setPromotedDeals(response.deals ?? []);
      final response1 = await ApiProvider.instance.getShopCategory();
      if (response1.success ?? false) {
        Provider.of<DataProvider>(
                Navigation.instance.navigatorKey.currentContext ?? context,
                listen: false)
            .setShopCategory(response1.categories ?? []);
        // _refreshController.refreshCompleted();
      } else {
        // _refreshController.refreshFailed();
      }
    } else {
      // _refreshController.refreshFailed();
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
    // _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
  }
}
