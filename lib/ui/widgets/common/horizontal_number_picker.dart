import 'dart:math';
import 'package:exon_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

enum InitialPosition { start, center, end }

class HorizontalPicker extends StatefulWidget {
  final double minValue, maxValue;
  final int divisions;
  final Function(double) onChanged;
  final InitialPosition? initialPosition;
  final Color? backgroundColor;
  final bool? showCursor;
  final Color? cursorColor;
  final Color? activeItemTextColor;
  final Color? passiveItemTextColor;
  final String? suffix;
  const HorizontalPicker(
      {Key? key,
      required this.minValue,
      required this.maxValue,
      required this.divisions,
      required this.onChanged,
      this.initialPosition = InitialPosition.center,
      this.backgroundColor = Colors.transparent,
      this.showCursor = true,
      this.cursorColor = deepPrimaryColor,
      this.activeItemTextColor = Colors.black,
      this.passiveItemTextColor = deepGrayColor,
      this.suffix = ''})
      : assert(minValue < maxValue),
        super(key: key);

  @override
  _HorizontalPickerState createState() => _HorizontalPickerState();
}

class _HorizontalPickerState extends State<HorizontalPicker> {
  List<double> valueList = [];
  late FixedExtentScrollController _scrollController;

  int selectedFontSize = 14;
  List<Map> valueMap = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i <= widget.divisions; i++) {
      double _height = 24;
      if (i % 10 == 0) {
        _height = 34;
      }
      valueMap.add({
        "value": widget.minValue +
            ((widget.maxValue - widget.minValue) / widget.divisions) * i,
        "fontSize": 14.0,
        "color": widget.passiveItemTextColor,
        "height": _height,
      });
    }
    setScrollController();
  }

  setScrollController() {
    int? initialItem;
    switch (widget.initialPosition!) {
      case InitialPosition.start:
        initialItem = 0;
        break;
      case InitialPosition.center:
        initialItem = (valueMap.length ~/ 2);
        break;
      case InitialPosition.end:
        initialItem = valueMap.length - 1;
        break;
    }
    _scrollController = FixedExtentScrollController(initialItem: initialItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(3),
      height: 100,
      alignment: Alignment.center,
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: Stack(
          children: <Widget>[
            RotatedBox(
              quarterTurns: 3,
              child: ListWheelScrollView(
                  controller: _scrollController,
                  itemExtent: 20,
                  onSelectedItemChanged: (item) {
                    setState(() {
                      int decimalCount = 1;
                      num fac = pow(10, decimalCount);
                      valueMap[item]["value"] =
                          (valueMap[item]["value"] * fac).round() / fac;
                      widget.onChanged(valueMap[item]["value"]);
                      for (var i = 0; i < valueMap.length; i++) {
                        double _height = 24;
                        if (i % 10 == 0) {
                          _height = 34;
                        }
                        if (i == item) {
                          valueMap[item]["color"] = widget.activeItemTextColor;
                          valueMap[item]["fontSize"] = 15.0;
                          valueMap[item]["width"] = 1.5;
                          valueMap[item]["height"] = _height;
                        } else {
                          valueMap[i]["color"] = widget.passiveItemTextColor;
                          valueMap[i]["fontSize"] = 14.0;
                          valueMap[i]["width"] = 1.0;
                          valueMap[i]["height"] = _height;
                        }
                      }
                    });
                    setState(() {});
                  },
                  children: valueMap.map((Map curValue) {
                    return ItemWidget(curValue,
                        backgroundColor: widget.backgroundColor!,
                        suffix: widget.suffix!);
                  }).toList()),
            ),
            Visibility(
              child: Container(
                  alignment: Alignment.topCenter,
                  height: 65,
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: widget.cursorColor!.withOpacity(0.3)),
                    width: 2,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWidget extends StatefulWidget {
  final Map curItem;
  final Color backgroundColor;
  final String? suffix;
  const ItemWidget(this.curItem,
      {Key? key, required this.backgroundColor, this.suffix})
      : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  void initState() {
    super.initState();
    int decimalCount = 1;
    num fac = pow(10, decimalCount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: RotatedBox(
        quarterTurns: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                height: widget.curItem["height"],
                width: widget.curItem["width"] ?? 1,
                color: widget.curItem["color"],
              ),
            ),
            widget.curItem["value"] % 1 == 0
                ? Text(
                    widget.curItem["value"].toInt().toString() + 'cm',
                    style: TextStyle(
                        fontSize: 8,
                        color: widget.curItem["color"],
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.visible,
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
