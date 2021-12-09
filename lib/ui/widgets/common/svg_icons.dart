import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const _likeIcon = 'assets/icons/lightningIcon.svg';
const _commentIcon = 'assets/icons/commentIcon.svg';
const _bookmarkIcon = 'assets/icons/bookmarkIcon.svg';

class LikeIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  const LikeIcon({
    Key? key,
    this.width = 10,
    this.height = 18,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _likeIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class CommentIcon extends StatelessWidget {
  const CommentIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _commentIcon,
      width: 13,
      height: 13,
    );
  }
}

class BookmarkIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  const BookmarkIcon({
    Key? key,
    this.width = 14,
    this.height = 14,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _bookmarkIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}
