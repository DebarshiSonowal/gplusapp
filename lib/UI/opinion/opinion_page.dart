import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';
import '../../Navigation/Navigate.dart';
import '../Menu/berger_menu_member_page.dart';
class OpinionPage extends StatefulWidget {
  const OpinionPage({Key? key}) : super(key: key);

  @override
  State<OpinionPage> createState() => _OpinionPageState();
}

class _OpinionPageState extends State<OpinionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      // drawer: BergerMenuMemPage(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Constance.thirdColor,
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.newspaper,
                      color: Colors.white,
                      size: 4.h,
                    ),
                    Text(
                      'Jonathan Doe',
                      style: Theme.of(
                          Navigation.instance.navigatorKey.currentContext!)
                          .textTheme
                          .headline3
                          ?.copyWith(
                        color: Colors.white,
                        // fontSize: 2.2.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Container(
                  height: 30.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(
                        'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bW9uZXklMjBwbGFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  'It is a long established fact that a reader will be distracted by the readable content of a',
                  style:
                  Theme.of(Navigation.instance.navigatorKey.currentContext!)
                      .textTheme
                      .headline3
                      ?.copyWith(
                    color: Constance.primaryColor,
                    // fontSize: 2.2.h,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GPlus Admin',
                      style:
                      Theme.of(Navigation.instance.navigatorKey.currentContext!)
                          .textTheme
                          .headline5
                          ?.copyWith(
                        color: Constance.thirdColor,
                        // fontSize: 2.2.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '12/8/2022',
                      style:
                      Theme.of(Navigation.instance.navigatorKey.currentContext!)
                          .textTheme
                          .headline5
                          ?.copyWith(
                        color: Colors.black,
                        // fontSize: 2.2.h,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Divider(
                  color: Colors.black,
                  thickness: 0.5.sp,
                ),
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
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: item.image ?? '',
                                    fit: BoxFit.fill,
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
                                SizedBox(
                                  height: 1.h,
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
                                  style:
                                  Theme.of(Navigation.instance.navigatorKey.currentContext!)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                    color: Constance.thirdColor,
                                    // fontSize: 2.2.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (cont, inde) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: SizedBox(
                        height: 1.h,
                        child: Divider(
                          color: Colors.black,
                          thickness: 0.3.sp,
                        ),
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
}
