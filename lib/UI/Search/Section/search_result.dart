import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Helper/DataProvider.dart';
import 'news_section.dart';
import 'others_section.dart';

class SearchResultWidget extends StatelessWidget {
  final int selected;
  final bool isEmpty;
  const SearchResultWidget({super.key, required this.selected, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
      selected == 0 ? NewsSection(isEmpty: isEmpty,) : OthersSection(isEmpty: isEmpty,),
    );
  }
}