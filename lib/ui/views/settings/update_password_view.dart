import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:exon_app/ui/pages/settings/check_password_page.dart';
import 'package:exon_app/ui/pages/settings/update_password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordView extends GetView<SettingsController> {
  const UpdatePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      const CheckPasswordPage(),
      const UpdatePasswordPage(),
    ];
    if (controller.updatePasswordPage < 0 ||
        controller.updatePasswordPage >= _pages.length) {
      controller.passwordJumpToPage(0);
    }
    return GetBuilder<SettingsController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: _pages[_.updatePasswordPage],
          ),
        );
      },
    );
  }
}
