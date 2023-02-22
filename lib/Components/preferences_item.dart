import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';
import '../Helper/DataProvider.dart';
import '../Model/topick.dart';

class preferencesItem extends StatelessWidget {
  const preferencesItem({
    super.key,
    required this.selTop,
    required this.i, required this.data,
  });
  final DataProvider data;
  final List<Topick> selTop;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 6, vertical: 6),
      padding: const EdgeInsets.symmetric(
          horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: selTop == []
            ? Colors.white
            : !selTop.contains(data.topicks[i])
            ? Colors.white
            : Constance.secondaryColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: selTop == []
              ? Colors.grey.shade600
              : !selTop.contains(data.topicks[i])
              ? Colors.grey.shade600
              : Constance.secondaryColor,
          width: 0.5.w,
          // left: BorderSide(
          //   color: Colors.green,
          //   width: 1,
          // ),
        ),
      ),
      child: Text(
        data.topicks[i].title ?? "",
        style:
        Theme.of(context).textTheme.headline5?.copyWith(
          color: Colors.grey.shade800,
          // fontSize: 2.h,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}