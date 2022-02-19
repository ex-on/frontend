import 'dart:async';

import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoadingIndicator extends StatefulWidget {
  final bool route;
  final bool icon;
  final Color? backgroundColor;
  const LoadingIndicator({
    Key? key,
    this.route = false,
    this.icon = false,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

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

    if (widget.icon) {
      return Center(
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
      );
    } else {
      return Container(
        width: context.width,
        height: context.height,
        color: widget.route ? Colors.white : Colors.white.withOpacity(0.7),
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
}

class CircularLoadingIndicator extends StatelessWidget {
  const CircularLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: brightPrimaryColor,
      ),
    );
  }
}

class LinearLoadingIndicator extends StatefulWidget {
  final int? duration;
  final double? width;
  final Color indicatorColor;

  const LinearLoadingIndicator({
    Key? key,
    this.duration = 2,
    this.width = 300,
    required this.indicatorColor,
  }) : super(key: key);

  @override
  State<LinearLoadingIndicator> createState() => _LinearLoadingIndicatorState();
}

class _LinearLoadingIndicatorState extends State<LinearLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration ?? 2),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: widget.width,
        height: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: SizedBox(
                width: 120,
                height: 15,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0),
                        widget.indicatorColor.withOpacity(0.4),
                        Colors.white.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(_controller.value * widget.width! - 60, 0),
                  child: child!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
