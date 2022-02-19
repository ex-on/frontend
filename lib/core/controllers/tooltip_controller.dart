import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TooltipController extends GetxController {
  static TooltipController to = Get.find<TooltipController>();
  GlobalKey key = GlobalKey<State<Tooltip>>();
  bool open = true;

  @override
  void onInit() {
    activateTooltip();
    super.onInit();
  }

  void activateTooltip() {
    dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
    open = true;
    update();
  }

  void deactivateTooltip() {
    dynamic tooltip = key.currentState;
    tooltip?.deactivate();
    open = false;
    update();
  }

  void toggleTooltip() {
    dynamic tooltip = key.currentState;
    if (open) {
      tooltip.deactivate();
    } else {
      tooltip.activate();
    }
    update();
  }
}
