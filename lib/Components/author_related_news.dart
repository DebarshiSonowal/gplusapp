import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Components/toppicks_card.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Networking/api_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/article.dart';
import '../Model/opinion.dart';
import '../Navigation/Navigate.dart';

class AuthorRelatedNews extends StatelessWidget {
  final DataProvider data;
  final List<Article> news;

  const AuthorRelatedNews(
    this.data, {
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return news.isEmpty
        ? Container()
        : Container(
            height: 30.h,
            width: double.infinity,
            color: Constance.secondaryColor,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'From same author',
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                  child: Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: news.length,
                      itemBuilder: (cont, count) {
                        var item = news[count];
                        return GestureDetector(
                          onTap: () {
                            if (data.profile?.is_plan_active ?? false) {
                              Navigation.instance.navigate('/story',
                                  args:
                                      '${item.first_cat_name?.seo_name},${item.seo_name}');
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
                              height: 12.h,
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
                                        SizedBox(
                                          height: 1.5.h,
                                        ),
                                        Text(
                                          Jiffy(item.publish_date, "yyyy-MM-dd")
                                              .format("dd/MM/yyyy"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(color: Colors.black87),
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
                                        Text(
                                          item.author_name ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(color: Colors.black87),
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
                ),
              ],
            ),
          );
  }
  void showNotaMember(context) {

    Constance.showMembershipPrompt(context, () {

    });
  }
}
