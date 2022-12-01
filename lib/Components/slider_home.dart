import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'home_slider_card.dart';

class HomeBannerPage extends StatefulWidget {
  final Function showNotaMember;

  const HomeBannerPage({required this.showNotaMember});

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
      return Container(
        margin: EdgeInsets.only(top: 0.2.h),
        // height:25.5.h,
        width: MediaQuery.of(context).size.width,
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
            // height: 25.5.h,
            // padding: EdgeInsets.only(top: 0.h),
            color: Colors.grey.shade200,
            width: MediaQuery.of(context).size.width,
            // height: 30.h,
            child: CarouselSlider.builder(
              itemCount: data.home_albums.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                var current = data.home_albums[index];
                return HomeSliderItem(
                  current: current,
                  data: data,
                  showNotaMember: () => widget.showNotaMember(),
                );
              },
              options: CarouselOptions(
                  autoPlay: true,
                  // enlargeCenterPage: true,
                  aspectRatio: 10.5 / 9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 3.h,
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.home_albums.length,
                itemBuilder: (BuildContext context, int index) {
                  var current = data.home_albums[index];
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(index),
                    child: Container(
                      width: (index <= (data.home_albums.length / 2.toInt()))
                          ? 2.w
                          : (index >= (data.home_albums.length - 2))
                              ? 1.25.w
                              : 1.65.w,
                      height: (index <= (data.home_albums.length / 2.toInt()))
                          ? 2.h
                          : (index >= (data.home_albums.length - 2))
                              ? 1.25.w
                              : 1.65.w,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.white)
                            .withOpacity(_current == index ? 0.9 : 0.4),
                      ),
                    ),
                  );
                },
              ),
            ),
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
