import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Model/promoted_deal.dart';

class PromotedDealItemImage extends StatelessWidget {
  const PromotedDealItemImage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final PromotedDeal data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(
              10.0,
            ),
            // bottomRight: Radius.circular(
            //   10.0,
            // ),
            topLeft: Radius.circular(
              10.0,
            ),
            // bottomLeft: Radius.circular(
            //   10.0,
            // ),
          ),
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: CachedNetworkImageProvider(
              data.vendor?.image_file_name ??
                  "https://source.unsplash.com/user/c_v_r/1900x800",
            ),
          ),
        ),
      ),
    );
  }
}