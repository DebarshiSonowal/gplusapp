import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeBannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<HomeBannerPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return SizedBox(
        // height: 40.h,
        width: MediaQuery.of(context).size.width,
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
            padding: EdgeInsets.only(top: 0.h),
            color: Colors.grey.shade200,
            width: MediaQuery.of(context).size.width,
            // height: 40.h,
            child: CarouselSlider(
              items: data.home_albums
                  .asMap()
                  .entries
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        if (data.profile
                            ?.is_plan_active ??
                            false) {
                          Navigation.instance.navigate('/story',
                              args:
                              '${e.value.first_cat_name?.seo_name},${e.value.seo_name}');
                        } else {
                          Constance.showMembershipPrompt(
                              context);
                        }

                      },
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Opacity(
                            opacity: 0.85,
                            child: CachedNetworkImage(
                              imageUrl: e.value.image_file_name ?? "",
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              // filterQuality: FilterQuality.low,
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
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black]),
                            ),
                            // color: Colors.black.withOpacity(0.5),
                            padding: EdgeInsets.symmetric(
                                vertical: 3.h, horizontal: 2.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  e.value.title ?? 'Big Deals\nand Offers',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                          color: Colors.grey.shade200,
                                          fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                Text(
                                  "${e.value.author_name?.trim()}, ${Jiffy(e.value.publish_date?.split(" ")[0], "yyyy-MM-dd").fromNow()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              carouselController: _controller,
              options: CarouselOptions(
                  autoPlay: true,
                  // enlargeCenterPage: true,
                  // aspectRatio: 16/9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data.home_albums.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.white)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ]),
      );
    });
  }

  Color getTextColor(Color color) {
    int d = 0;

// Counting the perceptive luminance - human eye favors green color...
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5)
      d = 0; // bright colors - black font
    else
      d = 255; // dark colors - white font

    return Color.fromARGB(color.alpha, d, d, d);
  }
}
