import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:async';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put<AuthController>(AuthController());
    Future.delayed(
        Duration.zero, () async => await AuthController.to.asyncMethod());
    const _logo = "assets/exonLogo.svg";
    const double _logoWidth = 130;
    const double _logoHeight = 100;

    return Scaffold(
      body: Container(
        color: splashViewBackgroundColor,
        child: Center(
          child: SvgPicture.asset(
            _logo,
            width: _logoWidth,
            height: _logoHeight,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
