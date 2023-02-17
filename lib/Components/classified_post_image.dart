import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Navigation/Navigate.dart';

class ClassifiedPostImageWidget extends StatelessWidget {
  const ClassifiedPostImageWidget({Key? key, required this.data, required this.controller, required this.updatePage})
      : super(key: key);
  final DataProvider data;
  final CarouselController controller;
  final Function(int) updatePage;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 2.h,
      padding: EdgeInsets.only(top: 0.h),
      color: Colors.grey.shade200,
      width: MediaQuery.of(context).size.width,
      // height: 40.h,
      child: ((data.selectedClassified?.attach_files ?? []).isNotEmpty)
          ? CarouselSlider(
              items: data.selectedClassified?.attach_files
                  ?.asMap()
                  .entries
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        Navigation.instance.navigate('/viewImage',
                            args: e.value.file_name ?? Constance.defaultImage);
                      },
                      child: CachedNetworkImage(
                        imageUrl: e.value.file_name ?? "",
                        width: double.infinity,
                        // height: 35.h,
                        fit: BoxFit.fitHeight,
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
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
              carouselController: controller,
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  // aspectRatio: 1,
                  aspectRatio: 12 / 9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    updatePage(index);
                  }),
            )
          : Image.asset(
              Constance.logoIcon,
              scale: 1,
              // color: Colors.black,
            ),
    );
  }
}
