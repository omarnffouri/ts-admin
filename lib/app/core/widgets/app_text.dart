import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  const AppText(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.weight = FontWeight.normal,
      this.size = 18,
      this.maxLines = 20,
      this.height,
      this.style});

  final String text;
  final Color color;
  final FontWeight weight;
  final double size;
  final int maxLines;
  final double? height;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: style ??
          TextStyle(
            color: color,
            height: height,
            fontSize: size.sp,
            fontWeight: weight,
            fontFamily: 'Poppins',
          ),
    );
  }
}
