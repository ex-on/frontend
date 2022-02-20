import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/tooltip_controller.dart';
import 'package:exon_app/ui/widgets/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double arrowPosition;
  final double radius;

  const TooltipShapeBorder({
    this.radius = 10.0,
    this.arrowWidth = 16,
    this.arrowHeight = 8,
    this.arrowArc = 0.0,
    this.arrowPosition = 0.5,
  })  : assert(arrowArc <= 1.0 && arrowArc >= 0.0),
        assert(arrowPosition <= 0.9 && arrowPosition >= 0.1);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.bottomLeft.dx + rect.width * arrowPosition + x / 2,
          rect.bottomCenter.dy)
      ..relativeLineTo(-x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(
          -x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, -y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

class TooltipHelpIconButton extends StatelessWidget {
  final String message;
  final double? size;
  final Color? overlayColor;
  const TooltipHelpIconButton({
    Key? key,
    required this.message,
    this.size,
    this.overlayColor,
  }) : super(key: key);

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
    Future.delayed(const Duration(seconds: 2), () => tooltip?.deactivate());
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      textStyle: const TextStyle(
        fontSize: 13,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      preferBelow: false,
      showDuration: const Duration(seconds: 2),
      decoration: const ShapeDecoration(
        color: darkSecondaryColor,
        shape: TooltipShapeBorder(
          arrowPosition: 0.8,
          arrowHeight: 10,
        ),
      ),
      child: SizedBox(
        width: 25,
        height: 25,
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: HelpIconButton(
            onPressed: () => _onTap(key),
            overlayColor: overlayColor,
            size: size,
          ),
        ),
      ),
    );
  }
}

class BubbleTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;
  final double? arrowPosition;
  final double? arrowHeight;
  final void Function(GlobalKey)? onTap;
  final GlobalKey? tooltipKey;
  const BubbleTooltip({
    Key? key,
    required this.message,
    required this.child,
    this.backgroundColor = darkSecondaryColor,
    this.textColor = Colors.white,
    this.arrowPosition,
    this.arrowHeight,
    this.onTap,
    this.tooltipKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();

    void _onTap(GlobalKey key) {
      final dynamic tooltip = key.currentState;
      tooltip?.ensureTooltipVisible();
      Future.delayed(const Duration(seconds: 2), () => tooltip?.deactivate());
    }

    return Tooltip(
      key: tooltipKey ?? key,
      message: message,
      textStyle: TextStyle(
        fontSize: 13,
        color: textColor,
      ),
      triggerMode: TooltipTriggerMode.tap,
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 0),
      preferBelow: false,
      showDuration: const Duration(seconds: 2),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: TooltipShapeBorder(
          arrowPosition: arrowPosition ?? 0.5,
          arrowHeight: arrowHeight ?? 0,
        ),
      ),
      child: GestureDetector(
          onTap: () {
            if (onTap != null) {
              return onTap!(tooltipKey ?? key);
            } else {
              return _onTap(key);
            }
          },
          child: child),
    );
  }
}

class ReverseBubbleTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Color? backgroundColor;
  final Color? textColor;
  final double? arrowPosition;
  final double? arrowHeight;
  final EdgeInsets? margin;
  const ReverseBubbleTooltip({
    Key? key,
    required this.message,
    required this.child,
    this.backgroundColor = darkSecondaryColor,
    this.textColor = Colors.white,
    this.arrowPosition,
    this.arrowHeight = 8,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TooltipController controller =
        Get.put<TooltipController>(TooltipController());
    Future.delayed(Duration.zero, () {
      if (controller.open) {
        controller.activateTooltip();
      }
    });

    return GetBuilder<TooltipController>(builder: (_) {
      return Tooltip(
        key: _.key,
        message: message,
        textStyle: TextStyle(
          fontSize: 13,
          color: textColor,
        ),
        triggerMode: TooltipTriggerMode.manual,
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        margin: margin ?? const EdgeInsets.only(bottom: 0),
        preferBelow: false,
        showDuration: const Duration(seconds: 2),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: TooltipShapeBorder(
            arrowPosition: arrowPosition ?? 0.5,
            arrowHeight: arrowHeight ?? 0,
          ),
        ),
        child: GestureDetector(onTap: _.deactivateTooltip, child: child),
      );
    });
  }
}
