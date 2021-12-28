import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:flutter/material.dart';

class ColorBadge extends StatelessWidget {
  final String text;
  final String? type;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  const ColorBadge({
    Key? key,
    required this.text,
    this.type,
    this.width = 45,
    this.height = 26,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = color;
    if (type != null) {
      switch (type) {
        case 'activityRank':
          backgroundColor = activityRankToColor[text];
          break;
        case 'physicalRank':
          backgroundColor = physicalRankToColor[text];
          break;
        case 'targetMuscle':
          backgroundColor = brightSecondaryColor;
          break;
        case 'exerciseMethod':
          backgroundColor = brightPrimaryColor;
          break;
        case 'recommendedExerciseTime':
          backgroundColor = deepGrayColor;
          break;
        default:
          backgroundColor = brightPrimaryColor;
          break;
      }
    }

    return Container(
      height: height,
      width: width,
      // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: backgroundColor,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          height: 1.0,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: (int.parse(backgroundColor.toString().substring(10, 16),
                      radix: 16) <
                  int.parse('800000', radix: 16))
              ? Colors.white
              : Colors.white,
        ),
      ),
    );
  }
}
