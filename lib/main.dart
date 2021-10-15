import 'package:exon_app/constants/app_routes.dart';
import 'package:exon_app/core/controllers/add_excercise_controller.dart';
import 'package:exon_app/core/controllers/auth_controller.dart';
import 'package:exon_app/core/controllers/excercise_info_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put<AuthController>(AuthController());
  Get.put<RegisterController>(RegisterController());
  Get.put<RegisterPhysicalInfoController>(RegisterPhysicalInfoController());
  Get.put<HomeController>(HomeController());
  Get.put<AddExcerciseController>(AddExcerciseController());
  Get.put<ExcerciseInfoController>(ExcerciseInfoController());
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
