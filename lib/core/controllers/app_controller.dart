import 'dart:developer';

import 'package:exon_app/core/controllers/community_controller.dart';
import 'package:exon_app/core/controllers/notification_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/core/services/user_api_service.dart';
import 'package:exon_app/helpers/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();
  GlobalKey scaffoldKey = GlobalKey();
  final ThemeData theme = ThemeData();
  final Rxn<RemoteMessage> message = Rxn<RemoteMessage>();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      configureAmplify();
      initialize();
    });
  }

  void configureAmplify() async {
    await AmplifyService.configureAmplify();
  }

  Future<bool> initialize() async {
    // Firebase 초기화부터 해야 FirebaseMessaging 를 사용할 수 있다.
    await Firebase.initializeApp();
    // Android 에서는 별도의 확인 없이 리턴되지만, requestPermission()을 호출하지 않으면 수신되지 않는다.

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    var token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      await UserApiService.postFcmToken(token);
    }

    log("token : ${token ?? 'token NULL!'}");

    void _onMessageTap(RemoteMessage msg) async {
      switch (int.parse(msg.data['type'])) {
        case 2:
          CommunityController.to.onPostPageInit(
            int.parse(msg.data['link_id']),
            int.parse(msg.data['post_type']),
          );
          Get.toNamed('/community/post');
          await NotificationController.to.refreshNotifications();
          NotificationController.to
              .markNotificationAsRead(int.parse(msg.data['id']));
          break;
        case 3:
          CommunityController.to.onQnaPageInit(
              int.parse(msg.data['link_id']), msg.data['qna_solved'].toString().parseBool);
          Get.toNamed('/community/qna');
          await NotificationController.to.refreshNotifications();
          NotificationController.to
              .markNotificationAsRead(int.parse(msg.data['id']));
          break;
        default:
          NotificationController.to.refreshNotifications();
          Get.toNamed('/notification');
          break;
      }
    }

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage msg) {
        message.value = msg;
        Get.snackbar(
          msg.notification?.title ?? 'TITLE',
          msg.notification?.body ?? 'BODY',
          backgroundColor: Colors.white.withOpacity(0.8),
          onTap: (GetSnackBar snackBar) {
            _onMessageTap(msg);
          },
        );
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage msg) async {
        inspect(msg);

        _onMessageTap(msg);
      },
    );

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initialzationSettingsIOS = const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    return true;
  }
}
