import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/ui/widgets/common/spacer.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentBadge extends StatelessWidget {
  final String text;
  const CommentBadge({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xffFF6086),
        borderRadius: BorderRadius.circular(2),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ),
    );
    // return Container(
    //   height: 14,
    //   decoration: BoxDecoration(
    //     color: const Color(0xffFF6086),
    //     borderRadius: BorderRadius.circular(2),
    //   ),
    //   margin: const EdgeInsets.symmetric(horizontal: 5),
    //   padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
    //   child: Center(
    //     child: Text(
    //       text,
    //       style: const TextStyle(
    //         color: Colors.white,
    //         fontSize: 8,
    //       ),
    //     ),
    //   ),
    // );
  }
}

class SelectedAnswerBadge extends StatelessWidget {
  const SelectedAnswerBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SizedBox(
        width: 75,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: darkSecondaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                const CheckIcon(
                  width: 10,
                  height: 10,
                  color: Colors.white,
                ),
                horizontalSpacer(4),
                const Text(
                  '채택된 답변',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
