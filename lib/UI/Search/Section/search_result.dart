import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Helper/DataProvider.dart';
import 'news_section.dart';
import 'others_section.dart';

class SearchResultWidget extends StatelessWidget {
  final int selected;

  const SearchResultWidget({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, data, _) {
      return Expanded(
        child:
        selected == 0 ? NewsSection(data: data) : OthersSection(data: data),
      );
    });
  }
}