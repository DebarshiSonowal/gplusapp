import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gplusapp/Navigation/Navigate.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../../Helper/Constance.dart';

class ViewImagePage extends StatefulWidget {
  final url;

  ViewImagePage(this.url);

  @override
  State<ViewImagePage> createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Constance.primaryColor,
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigation.instance.goBack();
        },
        child: Icon(
          Icons.close,
          size: 18.sp,
          // color: Constance.secondaryColor,
          color: Colors.red,
        ),
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(
          widget.url,
        ),
      ),
    );
  }
}
