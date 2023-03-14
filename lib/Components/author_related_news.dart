import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Components/toppicks_card.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Helper/Storage.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/article.dart';
import '../Model/opinion.dart';
import '../Navigation/Navigate.dart';
import 'custom_button.dart';

class AuthorRelatedNews extends StatefulWidget {
  final DataProvider data;
  final List<Article> news;

  final Function updateState;

  AuthorRelatedNews(
    this.data, {
    Key? key,
    required this.news,
    required this.updateState,
  }) : super(key: key);

  @override
  State<AuthorRelatedNews> createState() => _AuthorRelatedNewsState();
}

class _AuthorRelatedNewsState extends State<AuthorRelatedNews> {
  int currentCount = 4;

  @override
  Widget build(BuildContext context) {
    return widget.news.isEmpty
        ? Container()
        : Container(
            // height: 30.h,
            width: double.infinity,
            // color: Constance.secondaryColor,
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Text(
                    'Articles',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Constance.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  width: double.infinity,
                  // height: 30.h,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: widget.news.length > currentCount
                        ? currentCount
                        : widget.news.length,
                    itemBuilder: (cont, count) {
                      var item = widget.news[count];
                      return GestureDetector(
                        onTap: () {
                          if (widget.data.profile?.is_plan_active ?? false) {
                            Navigation.instance.navigate('/story',
                                args:
                                    '${item.first_cat_name?.seo_name},${item.seo_name},author_page');
                          } else {
                            showNotaMember(context);
                          }
                        },
                        child: Card(
                          // margin: EdgeInsets.symmetric(horizontal: 5.s),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(
                              width: 0.5,
                              color: Colors.black,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.5.h),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: Colors.white,
                            ),
                            height: 22.h,
                            width: MediaQuery.of(context).size.width - 10.w,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                item.image_file_name ?? '',
                                            placeholder: (cont, _) {
                                              return Image.asset(
                                                Constance.logoIcon,
                                                // color: Colors.black,
                                              );
                                            },
                                            errorWidget: (cont, _, e) {
                                              return Image.network(
                                                Constance.defaultImage,
                                                fit: BoxFit.fitWidth,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: Text(
                                          item.title ??
                                              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient.",
                                          maxLines: 8,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                  // fontSize: 11.sp,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color:
                                                      Constance.primaryColor),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 1.5.h,
                                      // ),
                                      const Spacer(),
                                      // SizedBox(
                                      //   height: 1.5.h,
                                      // ),
                                      // Text(
                                      //   Jiffy(item.publish_date, "yyyy-MM-dd")
                                      //       .format("dd MMM,yyyy"),
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .headline6
                                      //       ?.copyWith(color: Colors.black87),
                                      // ),
                                      // SizedBox(
                                      //   height: 1.h,
                                      // ),
                                      // Text(
                                      //   item.author_name ?? "",
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .headline6
                                      //       ?.copyWith(color: Colors.black87),
                                      // ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Text(
                                            Jiffy(
                                                    item.publish_date
                                                            ?.split(" ")[0] ??
                                                        "",
                                                    "yyyy-MM-dd")
                                                .format("dd MMM,yyyy"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                    color: Storage
                                                            .instance.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black54),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            Constance.authorIcon,
                                            color: Constance.secondaryColor,
                                            // size: 8.sp,
                                            scale: 37,
                                          ),
                                          SizedBox(
                                            width: 1.w,
                                          ),
                                          Text(
                                            item.author_name ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                    color: Storage
                                                            .instance.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (cont, inde) {
                      return SizedBox(
                        width: 2.w,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                widget.news.length > currentCount
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // news.removeRange(0, 4);
                              setState(() {
                                currentCount = currentCount * 4;
                              });

                              debugPrint(currentCount.toString());
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Text(
                                'Read More',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      color: Storage.instance.isDarkMode
                                          ? Colors.white
                                          : Constance.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                          // CustomButton(
                          //     txt: 'Read More',
                          //     onTap: () {
                          //       // currentCount+=4;
                          //       news.removeRange(0, 4);
                          //       updateState();
                          //       // page++;
                          //       // fetchMoreData();
                          //     }),
                        ],
                      )
                    : Container(),
              ],
            ),
          );
  }

  void showNotaMember(context) {
    Constance.showMembershipPrompt(context, () {});
  }
}
