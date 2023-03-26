import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Model/guwahati_connect.dart';

class FourImagesWidget extends StatelessWidget {
  List<GCAttachment> attachment = [];

  FourImagesWidget({Key? key, required this.attachment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  //                   <--- left side
                  color: Colors.grey.shade200,
                  width: 3.0,
                ),
              ),
            ),
            child: CachedNetworkImage(
              placeholder: (cont, _) {
                return Image.asset(
                  Constance.logoIcon,
                  // color: Colors.black,
                );
              },
              imageUrl: (attachment![0].file_name) ?? "",
              fit: BoxFit.fitHeight,
              errorWidget: (cont, _, e) {
                return Image.network(
                  Constance.defaultImage,
                  fit: BoxFit.fitWidth,
                );
              },
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
            child: CachedNetworkImage(
              placeholder: (cont, _) {
                return Image.asset(
                  Constance.logoIcon,
                  // color: Colors.black,
                );
              },
              imageUrl: (attachment[1].file_name) ?? "",
              fit: BoxFit.fitHeight,
              errorWidget: (cont, _, e) {
                return Image.network(
                  Constance.defaultImage,
                  fit: BoxFit.fitWidth,
                );
              },
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  //                   <--- left side
                  color: Colors.grey.shade200,
                  width: 3.0,
                ),
              ),
            ),
            child: CachedNetworkImage(
              placeholder: (cont, _) {
                return Image.asset(
                  Constance.logoIcon,
                  // color: Colors.black,
                );
              },
              imageUrl: (attachment[2].file_name) ?? "",
              fit: BoxFit.fitHeight,
              errorWidget: (cont, _, e) {
                return Image.network(
                  Constance.defaultImage,
                  fit: BoxFit.fitWidth,
                );
              },
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
            decoration: const BoxDecoration(
              border: Border(),
            ),
            child: CachedNetworkImage(
              placeholder: (cont, _) {
                return Image.asset(
                  Constance.logoIcon,
                  // color: Colors.black,
                );
              },
              imageUrl: (attachment[3].file_name) ?? "",
              fit: BoxFit.fitHeight,
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
    );
  }
}