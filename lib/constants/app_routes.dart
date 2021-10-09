import 'package:exon_app/ui/views/auth_landing_view.dart';
import 'package:exon_app/ui/views/registration_view.dart';
import 'package:exon_app/ui/views/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const SplashView()),
    GetPage(name: '/auth', page: () => const AuthLandingView()),
    GetPage(name: '/register', page: () => RegistrationView()),
  ];
}
