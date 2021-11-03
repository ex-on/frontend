import 'package:exon_app/constants/app_routes.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_excercise_controller.dart';
import 'package:exon_app/core/controllers/deep_link_controller.dart';
import 'package:exon_app/core/controllers/excercise_info_controller.dart';
import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk/link.dart';

void main() {
  Get.put<RegisterController>(RegisterController());
  Get.put<RegisterPhysicalInfoController>(RegisterPhysicalInfoController());
  Get.put<AddExcerciseController>(AddExcerciseController());
  Get.put<ExcerciseInfoController>(ExcerciseInfoController());
  KakaoContext.clientId = kakaoClientId;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _configureAmplify();
    });
  }

  void _configureAmplify() async {
    await AmplifyService.configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DeepLinkController());
    return GetMaterialApp(
      key: _scaffoldKey,
      initialRoute: '/',
      locale: const Locale('ko', 'KO'),
      getPages: AppRoutes.routes,
    );
  }
}
