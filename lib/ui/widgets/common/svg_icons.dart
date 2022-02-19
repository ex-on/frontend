import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const String _exonLogo = "assets/exonLogo.svg";
const String _exonIconLogo = "assets/exonIconLogo.svg";

const String _communityIcon = 'assets/icons/communityIcon.svg';
const String _rankIcon = 'assets/icons/rankIcon.svg';
const String _statIcon = 'assets/icons/statIcon.svg';
const String _homeIcon = 'assets/icons/homeIcon.svg';
const String _profileIcon = 'assets/icons/profileIcon.svg';
const String _likeIcon = 'assets/icons/lightningIcon.svg';
const String _commentIcon = 'assets/icons/commentIcon.svg';
const String _bookmarkIcon = 'assets/icons/bookmarkIcon.svg';
const String _proteinIcon = 'assets/icons/proteinIcon.svg';
const String _whiteProteinIcon = 'assets/icons/whiteProteinIcon.svg';
const String _rankBadgeFirstIcon = 'assets/icons/rankBadgeFirstIcon.svg';
const String _rankBadgeSecondIcon = 'assets/icons/rankBadgeSecondIcon.svg';
const String _rankBadgeThirdIcon = 'assets/icons/rankBadgeThirdIcon.svg';
const String _energyIcon = 'assets/icons/lightningEnergyIcon.svg';
const String _helpIcon = 'assets/icons/helpIcon.svg';
const String _xIcon = 'assets/icons/XIcon.svg';
const String _checkIcon = 'assets/icons/checkIcon.svg';
const String _addIcon = 'assets/icons/addIcon.svg';
const String _subtractIcon = 'assets/icons/subtractIcon.svg';
const String _scrollUpIcon = 'assets/icons/arrowDropUp.svg';

const String _excitedCharacter = 'assets/characters/excitedCharacter.svg';
const String _tiredCharacter = 'assets/characters/tiredCharacter.svg';
const String _jumpingExcitedCharacter =
    'assets/characters/jumpingExcitedCharacter.svg';
const String _dumbellCharacter = 'assets/characters/dumbellCharacter.svg';
const String _privacyCharacter = 'assets/characters/privacyCharacter.svg';

const String _completeIcon = 'assets/completeIcon.svg';
const String _incompleteIcon = 'assets/icons/incompleteIcon.svg';
const String _fistIcon = 'assets/icons/fistIcon.svg';

const String _maleAvatar = 'assets/maleAvatar.svg';

class ExonLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const ExonLogo({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _exonLogo,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class ExonIconLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const ExonIconLogo({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _exonIconLogo,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class CommunityIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const CommunityIcon({
    Key? key,
    this.width = 25,
    this.height = 25,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _communityIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const ProfileIcon({
    Key? key,
    this.width = 25,
    this.height = 25,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _profileIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class StatIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const StatIcon({
    Key? key,
    this.width = 25,
    this.height = 25,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _statIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class HomeIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const HomeIcon({
    Key? key,
    this.width = 25,
    this.height = 25,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _homeIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class RankIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  const RankIcon({
    Key? key,
    this.width = 25,
    this.height = 25,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _rankIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

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
  final double width;
  final double height;
  final Color? color;
  const CommentIcon({
    Key? key,
    this.width = 13,
    this.height = 13,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _commentIcon,
      width: width,
      height: height,
      color: color,
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

class ProteinIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const ProteinIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _proteinIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class WhiteProteinIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const WhiteProteinIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _whiteProteinIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class RankBadgeFirstIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const RankBadgeFirstIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _rankBadgeFirstIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class RankBadgeSecondIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const RankBadgeSecondIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _rankBadgeSecondIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class RankBadgeThirdIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const RankBadgeThirdIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _rankBadgeThirdIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class EnergyIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const EnergyIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _energyIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class HelpIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const HelpIcon({
    Key? key,
    this.width = 18,
    this.height = 18,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _helpIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class XIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const XIcon({
    Key? key,
    this.width = 18,
    this.height = 18,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _xIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class CheckIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const CheckIcon({
    Key? key,
    this.width = 18,
    this.height = 18,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _checkIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class AddIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const AddIcon({
    Key? key,
    this.width = 18,
    this.height = 18,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _addIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class SubtractIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const SubtractIcon({
    Key? key,
    this.width = 18,
    this.height = 18,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _subtractIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class ScrollUpIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const ScrollUpIcon({
    Key? key,
    this.width = 15,
    this.height = 15,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _scrollUpIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

// Characters
class ExcitedCharacter extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const ExcitedCharacter({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _excitedCharacter,
      width: width,
      height: height,
      color: color,
    );
  }
}

class JumpingExcitedCharacter extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const JumpingExcitedCharacter({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _jumpingExcitedCharacter,
      width: width,
      height: height,
      color: color,
    );
  }
}

class TiredCharacter extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const TiredCharacter({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _tiredCharacter,
      width: width,
      height: height,
      color: color,
    );
  }
}

class DumbellCharacter extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const DumbellCharacter({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _dumbellCharacter,
      width: width,
      height: height,
      color: color,
    );
  }
}

class PrivacyCharacter extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const PrivacyCharacter({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _privacyCharacter,
      width: width,
      height: height,
      color: color,
    );
  }
}

class CompleteIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const CompleteIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _completeIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class IncompleteIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const IncompleteIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _incompleteIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class FistIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const FistIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _fistIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class MaleAvatar extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const MaleAvatar({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _maleAvatar,
      width: width,
      height: height,
      color: color,
    );
  }
}
