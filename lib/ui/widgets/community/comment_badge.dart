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
      height: 14,
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
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}
