import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../Components/alert.dart';
import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';

class VideoReport extends StatefulWidget {
  const VideoReport({Key? key}) : super(key: key);

  @override
  State<VideoReport> createState() => _VideoReportState();
}

class _VideoReportState extends State<VideoReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        // padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Icon(
              //       Icons.star,
              //       color: Constance.secondaryColor,
              //       size: 4.h,
              //     ),
              //     Text(
              //       'Jonathan Doe',
              //       style: Theme.of(
              //               Navigation.instance.navigatorKey.currentContext!)
              //           .textTheme
              //           .headline3
              //           ?.copyWith(
              //             color: Constance.primaryColor,
              //             // fontSize: 2.2.h,
              //             fontWeight: FontWeight.bold,
              //           ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 1.h,
              // ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 30.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: CachedNetworkImageProvider(
                          'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Constance.secondaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              )),
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 1.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                              Text(
                                'Play Now',
                                style: Theme.of(Navigation
                                        .instance.navigatorKey.currentContext!)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Colors.white,
                                      // fontSize: 2.2.h,
                                      // fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'It is a long established fact that a reader will be distracted by the readable content of a',
                          style: Theme.of(Navigation
                                  .instance.navigatorKey.currentContext!)
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
                        Text(
                          'GPlus Admin, 1 min ago',
                          style: Theme.of(Navigation
                                  .instance.navigatorKey.currentContext!)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                color: Colors.grey.shade500,
                                // fontSize: 2.2.h,
                                // fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (cont, count) {
                    var item = Constance.topList[count];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.white,
                      ),
                      height: 20.h,
                      width: MediaQuery.of(context).size.width - 7.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Expanded(
                                        child: CachedNetworkImage(
                                          imageUrl: item.image ?? '',
                                          fit: BoxFit.cover,
                                          placeholder: (cont, _) {
                                            return const Icon(
                                              Icons.image,
                                              color: Colors.black,
                                            );
                                          },
                                          errorWidget: (cont, _, e) {
                                            // print(e);
                                            print(_);
                                            return Text(_);
                                          },
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Constance.secondaryColor,
                                          // borderRadius: BorderRadius.all(
                                          //   Radius.circular(5.0),
                                          // ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w, vertical: 0.3.h),
                                        child: Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Play Now',
                                              style: Theme.of(Navigation
                                                      .instance
                                                      .navigatorKey
                                                      .currentContext!)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    // fontSize: 2.2.h,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  item.date ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name ?? "",
                                    maxLines: 3,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                            color: Constance.primaryColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  "GPlus News",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (cont, inde) {
                    return SizedBox(
                      height: 1.h,
                      child: Divider(
                        color: Colors.black,
                        thickness: 0.3.sp,
                      ),
                    );
                  },
                  itemCount: Constance.topList.length),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Image.asset(
        Constance.logoIcon,
        fit: BoxFit.fill,
        scale: 2,
      ),
      centerTitle: true,
      backgroundColor: Constance.primaryColor,
    );
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
}
