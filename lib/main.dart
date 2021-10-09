import 'package:exon_app/constants/app_routes.dart';
import 'package:exon_app/core/controllers/auth_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put<AuthController>(AuthController());
  Get.put<RegisterController>(RegisterController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      locale: const Locale('ko', 'KO'),
      getPages: AppRoutes.routes,
    );
  }
}
