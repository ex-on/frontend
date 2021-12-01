import 'package:exon_app/ui/views/add_exercise_view.dart';
import 'package:exon_app/ui/views/auth_landing_view.dart';
import 'package:exon_app/ui/views/exercise_block_view.dart';
import 'package:exon_app/ui/pages/exercise_info_page.dart';
import 'package:exon_app/ui/views/home_navigation_view.dart';
import 'package:exon_app/ui/views/login_view.dart';
import 'package:exon_app/ui/views/registration_view.dart';
import 'package:exon_app/ui/views/settings_view.dart';
import 'package:exon_app/ui/views/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const SplashView(loading: false)),
    GetPage(name: '/loading', page: () => const SplashView(loading: true)),
    GetPage(name: '/auth', page: () => AuthLandingView()),
    GetPage(name: '/register', page: () => const RegistrationView()),
    GetPage(name: '/register_info', page: () => const RegisterInfoView()),
    GetPage(name: '/login', page: () => const LoginView()),
    GetPage(name: '/home', page: () => HomeNavigationView()),
    GetPage(name: '/add_excercise', page: () => AddExerciseView()),
    GetPage(name: '/exercise_block', page: () => const ExerciseBlockView()),
    GetPage(name: '/excercise_info', page: () => const ExerciseInfoPage()),
    GetPage(
        name: '/settings',
        page: () => const SettingsView(),
        transition: Transition.rightToLeft),
  ];
}
