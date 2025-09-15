

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TextBoldWidget extends StatelessWidget {
  const TextBoldWidget({
    required this.TheText,
    required this.TheTextSize,
    this.TheTextColor,
    super.key,
  });

  final String TheText ;
  final double TheTextSize ;
  final String? TheTextColor ;

  @override
  Widget build(BuildContext context) {
    return Text(
      TheText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: TheTextSize),);
  }
}