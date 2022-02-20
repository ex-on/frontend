import 'dart:async';

import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/enums.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/physics.dart';

class ElevatedRouteButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function()? onPressed;
  final Color backgroundColor;

  const ElevatedRouteButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor),
      overlayColor: backgroundColor == Colors.white
          ? MaterialStateProperty.all(Colors.grey[200])
          : null,
      minimumSize: MaterialStateProperty.all(const Size(250, 50)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 16,
      )),
      side: MaterialStateProperty.all(
        backgroundColor == Colors.white
            ? const BorderSide(color: Color(0xff999999), width: 1.0)
            : BorderSide.none,
      ),
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      elevation: MaterialStateProperty.all(0),
    );
    return ElevatedButton(
      child: Text(
        buttonText,
        style: TextStyle(
          color: (int.parse(backgroundColor.toString().substring(10, 16),
                      radix: 16) <
                  int.parse('800000', radix: 16))
              ? Colors.white
              : Colors.black,
        ),
      ),
      onPressed: onPressed,
      style: style,
    );
  }
}

class TextActionButton extends StatelessWidget {
  final String buttonText;
  final void Function() onPressed;
  final double? fontSize;
  final Color? textColor;
  final Color? overlayColor;
  final bool? isUnderlined;
  final Widget? leading;
  final double? width;
  final double? height;
  final FontWeight? fontWeight;

  const TextActionButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.overlayColor,
    this.isUnderlined = true,
    this.leading,
    this.width,
    this.height = 40,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      overlayColor: MaterialStateProperty.all(
          overlayColor ?? brightPrimaryColor.withOpacity(0.1)),
      minimumSize: MaterialStateProperty.all(Size.zero),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    Widget text = Text(
      buttonText,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: textColor,
        textBaseline: TextBaseline.ideographic,
        height: 1.0,
      ),
    );

    Widget underlinedText = isUnderlined!
        ? DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: textColor ?? Colors.black,
                  width: 0.5,
                ),
              ),
            ),
            child: text)
        : text;

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        child: leading == null
            ? underlinedText
            : Row(
                children: [
                  leading!,
                  underlinedText,
                ],
              ),
        style: style,
      ),
    );
  }
}

class ElevatedActionButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function()? onPressed;
  final bool? activated;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? overlayColor;
  final Color? disabledColor;
  final TextStyle? textStyle;
  final double? borderRadius;
  final BorderSide? borderSide;
  const ElevatedActionButton({
    Key? key,
    required this.buttonText,
    required dynamic Function() this.onPressed,
    this.activated,
    this.height,
    this.width,
    this.backgroundColor = brightPrimaryColor,
    this.overlayColor,
    this.disabledColor,
    this.borderRadius = 30,
    this.borderSide,
    this.textStyle = const TextStyle(color: Colors.white),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return disabledColor ?? deepGrayColor;
          }
          return backgroundColor!; // Use the component's default.
        },
      ),
      overlayColor: MaterialStateProperty.all(overlayColor),
      minimumSize: MaterialStateProperty.all(const Size(250, 50)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 16,
      )),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
      )),
      side: borderSide != null ? MaterialStateProperty.all(borderSide) : null,
      elevation: MaterialStateProperty.all(0),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        child: Text(buttonText, style: textStyle),
        onPressed: activated == null || activated! ? onPressed : null,
        style: style,
      ),
    );
  }
}

class FloatingIconButton extends StatelessWidget {
  final Function() onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Widget icon;
  final String heroTag;
  const FloatingIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
    this.height = 70,
    this.width = 70,
    this.backgroundColor = brightPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: heroTag,
          onPressed: onPressed,
          child: icon,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}

class HelpIconButton extends StatelessWidget {
  final void Function() onPressed;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double? size;
  final double? fontSize;
  final double? splashRadius;
  const HelpIconButton(
      {Key? key,
      required this.onPressed,
      this.overlayColor,
      this.backgroundColor,
      this.size,
      this.fontSize,
      this.splashRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 20,
      height: size ?? 20,
      child: Material(
        color: backgroundColor ?? Colors.white,
        shape: const CircleBorder(),
        child: IconButton(
          icon: Text(
            '?',
            style: TextStyle(
              fontSize: fontSize ?? 12,
              color: brightPrimaryColor,
            ),
          ),
          splashRadius: splashRadius ?? (size != null ? (size! / 2) : 10),
          splashColor: overlayColor ?? mainBackgroundColor,
          highlightColor: overlayColor ?? mainBackgroundColor,
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class StartExerciseButton extends StatelessWidget {
  final Function() onStartPressed;
  const StartExerciseButton({
    Key? key,
    required this.onStartPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _playIcon = 'assets/icons/playIcon.svg';

    return Stack(
      children: [
        SvgPicture.asset(_playIcon),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onStartPressed,
              splashColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.3),
              customBorder: const CircleBorder(),
            ),
          ),
        )
      ],
    );
  }
}

class SlidableButton extends StatefulWidget {
  /// A widget that is behind the button.
  final Widget? child;

  /// Button color if it disabled.
  ///
  /// [disabledColor] is set to `Colors.grey` by default.
  final Color? disabledColor;

  /// The color of button.
  ///
  /// If null, it will be transparent.
  final Color? buttonColor;

  /// The color of background.
  ///
  /// If null, it will be transparent.
  final Color? color;

  /// Border of area slide (usually called background).
  final BoxBorder? border;

  /// Border Radius for the button and it's child.
  ///
  /// Default value is `const BorderRadius.all(const Radius.circular(60.0))`
  final BorderRadius borderRadius;

  /// The height of this widget (button and it's background).
  ///
  /// Default value is 36.0.
  final double height;

  /// Width of area slide (usually called background).
  ///
  /// Default value is 120.0.
  final double width;

  /// Width of button. If [buttonWidth] is still null and the [label] is not null, this will automatically wrapping [label].
  ///
  /// The minimum size is [height], and the maximum size is three quarters from [width].
  final double? buttonWidth;
  final double? buttonHeight;

  /// It means the effect while and after sliding.
  ///
  /// If `true`, [child] will disappear along with button sliding. Otherwise, it stay visible even the button was slide.
  final bool dismissible;

  /// Initial button position. It can on the left or right.
  final SlidableButtonPosition initialPosition;

  /// Listen to position, is button on the left or right.
  ///
  /// You must set this argument although is null.
  final ValueChanged<SlidableButtonPosition>? onChanged;

  /// Controller for the button while sliding.
  final AnimationController? controller;

  /// Creates a [SlidableButton]
  const SlidableButton({
    Key? key,
    required this.onChanged,
    this.controller,
    this.child,
    this.disabledColor,
    this.buttonColor,
    this.color,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(60.0)),
    this.initialPosition = SlidableButtonPosition.center,
    this.height = 36.0,
    this.width = 120.0,
    this.buttonWidth,
    this.buttonHeight,
    this.dismissible = true,
  }) : super(key: key);

  @override
  _SlidableButtonState createState() => _SlidableButtonState();
}

class _SlidableButtonState extends State<SlidableButton>
    with SingleTickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _positionedKey = GlobalKey();

  late final AnimationController _controller;
  late Animation<double> _contentAnimation;
  Offset _start = Offset.zero;

  RenderBox? get _positioned =>
      _positionedKey.currentContext!.findRenderObject() as RenderBox?;

  RenderBox? get _container =>
      _containerKey.currentContext!.findRenderObject() as RenderBox?;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? AnimationController.unbounded(vsync: this);
    _contentAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    if (widget.initialPosition == SlidableButtonPosition.right) {
      _controller.value = 1.0;
    } else if (widget.initialPosition == SlidableButtonPosition.center) {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        border: widget.border,
        borderRadius: widget.borderRadius,
      ),
      child: Stack(
        key: _containerKey,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: widget.borderRadius,
            ),
            child: widget.dismissible
                ? ClipRRect(
                    borderRadius: widget.borderRadius,
                    child: SizedBox.expand(
                      child:
                          // FadeTransition(
                          //   opacity: _contentAnimation,
                          //   child:
                          widget.child,
                      // ),
                    ),
                  )
                : SizedBox.expand(child: widget.child),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Align(
              alignment: Alignment((_controller.value * 2.0) - 1.0, 0.0),
              child: child,
            ),
            child: Container(
              key: _positionedKey,
              width: widget.buttonWidth,
              height: widget.buttonHeight,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: widget.onChanged == null
                    ? widget.disabledColor ?? Colors.grey
                    : widget.buttonColor,
              ),
              child: widget.onChanged == null
                  ? Center()
                  : GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragStart: _onDragStart,
                      onHorizontalDragUpdate: _onDragUpdate,
                      onHorizontalDragEnd: _onDragEnd,
                      child: Center(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    final pos = _positioned!.globalToLocal(details.globalPosition);
    _start = Offset(pos.dx, 0.0);
    _controller.stop(canceled: true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final pos = _container!.globalToLocal(details.globalPosition) - _start;
    final extent = _container!.size.width - _positioned!.size.width;
    _controller.value = (pos.dx.clamp(0.0, extent) / extent);
  }

  void _onDragEnd(DragEndDetails details) {
    final extent = _container!.size.width - _positioned!.size.width;
    var fractionalVelocity = (details.primaryVelocity! / extent).abs();
    if (fractionalVelocity < 0.5) {
      fractionalVelocity = 0.5;
    }
    SlidableButtonPosition result;
    double velocity;
    if (_controller.value >= 0.85) {
      velocity = fractionalVelocity;
      result = SlidableButtonPosition.right;
    } else if (_controller.value < 0.85 && _controller.value >= 0.5) {
      velocity = -fractionalVelocity;
      result = SlidableButtonPosition.center;
    } else if (_controller.value < 0.5 && _controller.value > 0.15) {
      velocity = fractionalVelocity;
      result = SlidableButtonPosition.center;
    } else {
      velocity = -fractionalVelocity;
      result = SlidableButtonPosition.left;
    }

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    double getEndPosition(SlidableButtonPosition position) {
      if (position == SlidableButtonPosition.left) {
        return 0.0;
      } else if (position == SlidableButtonPosition.center) {
        return 0.5;
      } else {
        return 1.0;
      }
    }

    final simulation = SpringSimulation(
      spring,
      _controller.value,
      getEndPosition(result),
      velocity,
    );

    _controller.animateWith(simulation).whenComplete(() {
      if (widget.onChanged != null) {
        widget.onChanged!(result);
      }
    });
  }
}

class LoadingIndicatorButton extends StatefulWidget {
  final Color? color;
  final double? size;
  final double? margin;
  const LoadingIndicatorButton({
    Key? key,
    this.color = Colors.white,
    this.size = 8,
    this.margin = 3,
  }) : super(key: key);

  @override
  State<LoadingIndicatorButton> createState() => _LoadingIndicatorButtonState();
}

class _LoadingIndicatorButtonState extends State<LoadingIndicatorButton> {
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
        width: widget.size,
        height: widget.size,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(horizontal: widget.margin ?? 3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ),
      ),
    );
    _circles.add(Container(
      width: (widget.size ?? 8) * 1.3,
      height: (widget.size ?? 8) * 1.3,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.symmetric(horizontal: widget.margin ?? 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
    ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _circles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        child: _getLoadingCircle(),
      ),
    );
  }
}
