import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  int time = 0;
  Timer? counter;

  @override
  void initState() {
    super.initState();
    counter = Timer.periodic(
      const Duration(milliseconds: 300),
      (timer) {
        if (time < 0) {
          timer.cancel();
        } else {
          setState(() {
            time++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    if (counter != null) {
      counter!.cancel();
    }
    super.dispose();
  }

  Widget _getLoadingCircle() {
    List<Widget> _circles = List.generate(
      time % 3,
      (int i) => Container(
        width: 8,
        height: 8,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
    _circles.add(Container(
      width: 11,
      height: 11,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _circles,
    );
  }

  @override
  Widget build(BuildContext context) {
    const _loadingLogo = "assets/loadingLogo.svg";
    const double _logoWidth = 100;
    const double _logoHeight = 60;

    return Container(
      width: context.width,
      height: context.height,
      color: Colors.white.withOpacity(0.7),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              _loadingLogo,
              height: _logoHeight,
              fit: BoxFit.contain,
            ),
            Positioned(
              top: _logoHeight / 3 - 7,
              child: SizedBox(
                width: _logoWidth - 50,
                child: _getLoadingCircle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
