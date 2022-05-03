import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Dio fcmDio() {
  var dioOptions = BaseOptions(
    baseUrl: 'https://fcm.googleapis.com/fcm/send',
    connectTimeout: 10000,
    receiveTimeout: 8000,
  );
  Dio dio = Dio(dioOptions);

  return dio;
}

class FCMService {
  static Dio dio = fcmDio();
  final String _serverKey =
      "AAAAc_Ivf_k:APA91bH_rXw61N5E7w11o9io1WIpC9H1GpWRb7NmOkpc3aD1nsC3g5OvY0U5g0MkX6yeLgiTK5Kheuk5Js_0jmXW9v3NyhAs4EHrebtE_A8Ap-tZYw4LZ_c05KgGyrKpni8DAVTvP9p2";

  Future<void> sendMessage({
    required String userToken,
    required String title,
    required String body,
  }) async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    try {
      var response = await dio.post(
        '',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverKey'
          },
        ),
        data: {
          'notification': {'title': title, 'body': body, 'sound': 'false'},
          'ttl': '60s',
          "content_available": true,
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            "action": '테스트',
          },
          // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
          'to': userToken
          // 'registration_ids': tokenList
        },
      );
      log(response.toString());
    } catch (e) {
      print('error $e');
    }
  }
}
