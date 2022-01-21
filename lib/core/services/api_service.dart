import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/core/controllers/auth_controllers.dart';
import 'package:exon_app/helpers/dio_auth_interceptor.dart';
import 'package:exon_app/helpers/parse_jwt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio customDio() {
  var dioOptions = BaseOptions(
    baseUrl: endPointUrl,
    connectTimeout: 10000,
    receiveTimeout: 8000,
  );
  Dio dio = Dio(dioOptions);
  dio.interceptors.add(DioAuthInterceptor());

  return dio;
}

abstract class ApiService {
  static Dio dio = customDio();
  static const storage = FlutterSecureStorage();

  static Future<dynamic> get(
      String path, Map<String, dynamic>? parameters) async {
    try {
      var response = await dio.get(
        path,
        queryParameters: parameters,
      );
      if (response.statusCode == 200) {
        log(response.toString());
        return response;
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  static Future<dynamic> post(String path, dynamic data) async {
    try {
      var response = await dio.post(
        path,
        data: data,
      );
      log(response.toString());
      return response;
    } on DioError catch (e) {
      print(e);
    }
  }
}
