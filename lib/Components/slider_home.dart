import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Helper/Constance.dart';
import 'package:sizer/sizer.dart';

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 40.h,
      width:MediaQuery.of(context).size.width,
      child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
        Container(
          padding: EdgeInsets.only(top: 1.h),
          color: Colors.grey.shade200,
          width: MediaQuery.of(context).size.width,
          // height: 40.h,
          child: CarouselSlider(

            items: Constance.sliderImages
                .asMap()
                .entries
                .map(
                  (e) => CachedNetworkImage(
                    imageUrl: e.value,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    placeholder: (cont, _) {
                      return const Icon(
                        Icons.image,
                        color: Colors.black,
                      );
                    },
                    errorWidget: (cont,_,e){
                      return Text(_);
                    },
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
          children: Constance.sliderImages.asMap().entries.map((entry) {
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
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
