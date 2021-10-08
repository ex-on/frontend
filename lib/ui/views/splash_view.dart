import 'package:exon_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _logo = "assets/logo.png";
    const double _logoWidth = 130;
    const double _logoHeight = 35;

    Timer(const Duration(seconds: 5), () => Get.offNamed('/auth'));

    return Scaffold(
        body: Container(
      color: splashViewBackgroundColor,
      child: Center(
        child: Image.asset(
          _logo,
          width: _logoWidth,
          height: _logoHeight,
          fit: BoxFit.contain,
        ),
      ),
    ));
  }
}
