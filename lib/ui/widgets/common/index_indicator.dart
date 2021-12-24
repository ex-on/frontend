import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalLength;
  const IndexIndicator({
    Key? key,
    required this.currentIndex,
    required this.totalLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalLength,
        (index) {
          return Container(
            height: 6,
            width: 6,
            margin: const EdgeInsets.fromLTRB(4, 12, 4, 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == currentIndex ? darkPrimaryColor : lightGrayColor,
            ),
          );
        },
      ),
    );
  }
}
