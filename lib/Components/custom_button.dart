import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Constance.dart';

class CustomButton extends StatefulWidget {
  final String txt;
  final Function onTap;
  var color, size, fcolor;

  CustomButton(
      {required this.txt,
      required this.onTap,
      this.color,
      this.size,
      this.fcolor});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(widget.color ?? Constance.secondaryColor),
      ),
      onPressed: () => widget.onTap(),
      child: Text(
        widget.txt,
        style: Theme.of(context).textTheme.headline5?.copyWith(
              color: widget.fcolor ?? Colors.black,
              fontSize: widget.size ?? 14.5.sp,
            ),
      ),
    );
  }
}
