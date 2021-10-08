import 'package:exon_app/ui/views/authentication_view.dart';
import 'package:exon_app/ui/views/splash_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const SplashView()),
    GetPage(name: '/auth', page: () => const AuthenticationView()),
  ];
}
