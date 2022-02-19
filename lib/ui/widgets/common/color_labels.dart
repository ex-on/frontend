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

class TargetMuscleLabel extends StatelessWidget {
  final int targetMuscle;
  final String? text;
  final double? fontSize;
  const TargetMuscleLabel({
    Key? key,
    required this.targetMuscle,
    this.text,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: targetMuscleIntToColor[targetMuscle]!,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 6, top: 2),
        child: Text(
          text ?? targetMuscleIntToStr[targetMuscle]!,
          style: TextStyle(
            height: 1.0,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: clearBlackColor,
          ),
        ),
      ),
    );
  }
}

class CardioLabel extends StatelessWidget {
  final String? text;
  final double? fontSize;
  const CardioLabel({
    Key? key,
    this.text,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: cardioColor,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 6, top: 2),
        child: Text(
          text ?? '유산소',
          style: TextStyle(
            height: 1.0,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: clearBlackColor,
          ),
        ),
      ),
    );
  }
}

class ExerciseMethodLabel extends StatelessWidget {
  final int exerciseMethod;
  final String? text;
  final double? fontSize;
  const ExerciseMethodLabel({
    Key? key,
    required this.exerciseMethod,
    this.text,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: lightGrayColor,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 6, top: 2),
        child: Text(
          text ?? exerciseMethodIntToStr[exerciseMethod]!,
          style: TextStyle(
            height: 1.0,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: clearBlackColor,
          ),
        ),
      ),
    );
  }
}

class CardioMethodLabel extends StatelessWidget {
  final int exerciseMethod;
  final String? text;
  final double? fontSize;
  const CardioMethodLabel({
    Key? key,
    required this.exerciseMethod,
    this.text,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: lightGrayColor,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 6, top: 2),
        child: Text(
          text ?? cardioMethodIntToStr[exerciseMethod]!,
          style: TextStyle(
            height: 1.0,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: clearBlackColor,
          ),
        ),
      ),
    );
  }
}

class ExerciseRecordLabel extends StatelessWidget {
  final String text;
  final double? fontSize;
  const ExerciseRecordLabel({
    Key? key,
    required this.text,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: brightPrimaryColor,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 6, top: 2),
        child: Text(
          text,
          style: TextStyle(
            height: 1.0,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: brightPrimaryColor,
          ),
        ),
      ),
    );
  }
}
