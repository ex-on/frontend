import 'package:exon_app/constants/app_routes.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/add_exercise_controller.dart';
import 'package:exon_app/core/controllers/app_controller.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/core/controllers/community_search_controller.dart';
import 'package:exon_app/core/controllers/connection_controller.dart';
import 'package:exon_app/core/controllers/deep_link_controller.dart';
import 'package:exon_app/core/controllers/exercise_block_controller.dart';
import 'package:exon_app/core/controllers/home_navigation_controller.dart';
import 'package:exon_app/core/controllers/login_controller.dart';
import 'package:exon_app/core/controllers/notification_controller.dart';
import 'package:exon_app/core/controllers/physical_data_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/core/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put<AppController>(AppController());
  Get.put<RegisterController>(RegisterController());
  Get.put<RegisterInfoController>(RegisterInfoController());
  Get.put<LoginController>(LoginController());
  Get.put<AuthController>(AuthController());
  Get.put<SettingsController>(SettingsController());
  Get.put<AddExerciseController>(AddExerciseController());
  Get.put<ExerciseBlockController>(ExerciseBlockController());
  Get.put<HomeNavigationController>(HomeNavigationController());
  Get.put<NotificationController>(NotificationController());
  Get.put<PhysicalDataController>(PhysicalDataController());
  Get.put<ConnectionController>(ConnectionController());
  Get.put<CommunitySearchController>(CommunitySearchController());
  KakaoContext.clientId = kakaoClientId;

  runApp(const MyApp());
}

class MyApp extends GetView<AppController> {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DeepLinkController());

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        theme: controller.theme.copyWith(
          colorScheme: controller.theme.colorScheme.copyWith(
            // secondary: brightPrimaryColor.withOpacity(0.3),
            secondary: deepGrayColor,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],
        key: controller.scaffoldKey,
        initialRoute: '/',
        locale: const Locale('ko', 'KO'),
        getPages: AppRoutes.routes,
      ),
    );
  }
}
