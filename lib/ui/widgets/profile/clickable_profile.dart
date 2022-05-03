import 'package:exon_app/core/controllers/profile_controller.dart';
import 'package:flutter/material.dart';

class ClickableProfile extends StatelessWidget {
  final Widget child;
  final String username;
  const ClickableProfile({
    Key? key,
    required this.child,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => ProfileController.to.onUserProfileTap(username),
      child: child,
    );
  }
}
