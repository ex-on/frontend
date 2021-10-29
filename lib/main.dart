import 'package:exon_app/constants/app_routes.dart';
import 'package:exon_app/core/controllers/add_excercise_controller.dart';
import 'package:exon_app/core/controllers/deep_link_controller.dart';
import 'package:exon_app/core/controllers/excercise_info_controller.dart';
import 'package:exon_app/core/controllers/home_controller.dart';
import 'package:exon_app/core/controllers/register_controller.dart';
import 'package:exon_app/ui/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

bool _initialLinkIsHandled = false;

void main() {
  Get.put<RegisterController>(RegisterController());
  Get.put<RegisterPhysicalInfoController>(RegisterPhysicalInfoController());
  Get.put<HomeController>(HomeController());
  Get.put<AddExcerciseController>(AddExcerciseController());
  Get.put<ExcerciseInfoController>(ExcerciseInfoController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String? _initialLink;
  // String? _latestLink;
  // Object? _err;
  // String? _initialRoute;

  // StreamSubscription? _sub;

  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _handleIncomingLinks();
    // _handleInitialLink();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _configureAmplify();
    });
  }

  // @override
  // void dispose() {
  //   _sub?.cancel();
  //   super.dispose();
  // }

  void _configureAmplify() async {
    await AmplifyService.configureAmplify();
  }

  // /// Handle incoming links - the ones that the app will recieve from the OS
  // /// while already started.
  // void _handleIncomingLinks() {
  //   // It will handle app links while the app is already started - be it in
  //   // the foreground or in the background.
  //   _sub = linkStream.listen(
  //     (String? link) {
  //       if (!mounted) return;
  //       int index = link!.indexOf('?');
  //       String parsedLink = '/' + link.substring("exon://".length, index);
  //       print('got link: $parsedLink');
  //       setState(() {
  //         _latestLink = parsedLink;
  //         _err = null;
  //       });
  //       // Get.offNamed(parsedLink);
  //     },
  //     onError: (Object err) {
  //       if (!mounted) return;
  //       print('got err: $err');
  //       setState(() {
  //         _latestLink = null;
  //         if (err is FormatException) {
  //           _err = err;
  //         } else {
  //           _err = null;
  //         }
  //       });
  //     },
  //   );
  // }

  // /// Handle the initial Uri - the one the app was started with
  // ///
  // /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  // /// ONLY ONCE in your app's lifetime, since it is not meant to change
  // /// throughout your app's life.
  // ///
  // /// We handle all exceptions, since it is called from initState.
  // Future<void> _handleInitialLink() async {
  //   // In this example app this is an almost useless guard, but it is here to
  //   // show we are not going to call getInitialUri multiple times, even if this
  //   // was a weidget that will be disposed of (ex. a navigation route change).
  //   if (!_initialLinkIsHandled) {
  //     _initialLinkIsHandled = true;
  //     print('_handleInitialLink called');
  //     try {
  //       final link = await getInitialLink();
  //       int? index;
  //       String? parsedLink;
  //       if (link == null) {
  //         print('no initial link');
  //       } else {
  //         index = link.indexOf('?');
  //         parsedLink = '/' + link.substring("exon://".length, index);
  //         print('got initial link: $parsedLink');
  //       }
  //       if (!mounted) return;
  //       setState(() => _initialLink = parsedLink);
  //       print(_initialLink ?? _latestLink ?? '/');
  //     } on PlatformException {
  //       // Platform messages may fail but we ignore the exception
  //       print('falied to get initial link');
  //     } on FormatException catch (err) {
  //       if (!mounted) return;
  //       print('malformed initial link');
  //       setState(() => _err = err);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeepLinkController());
    return GetMaterialApp(
      key: _scaffoldKey,
      initialRoute: '/',
      locale: const Locale('ko', 'KO'),
      getPages: AppRoutes.routes,
    );
  }
}
