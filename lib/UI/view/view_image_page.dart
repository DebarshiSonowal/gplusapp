import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(
          widget.url,
        ),
      ),
    );
  }
}
