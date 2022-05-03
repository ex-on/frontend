import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/dio_auth_interceptor.dart';
import 'package:exon_app/helpers/dio_connectivity_request_retrier.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio customDio() {
  var dioOptions = BaseOptions(
    baseUrl: endPointUrl,
    connectTimeout: 50000,
    receiveTimeout: 50000,
  );
  Dio dio = Dio(dioOptions);
  dio.interceptors.add(
    DioAuthInterceptor(
      requestRetrier: DioConnectivityRequestRetrier(
        dio: dio,
        connectivity: Connectivity(),
      ),
    ),
  );

  return dio;
}

Dio customDioWithoutToken() {
  var dioOptions = BaseOptions(
    baseUrl: endPointUrl,
    connectTimeout: 10000,
    receiveTimeout: 8000,
  );
  Dio dio = Dio(dioOptions);

  return dio;
}

abstract class ApiService {
  static Dio dio = customDio();
  static Dio dioWithoutToken = customDioWithoutToken();
  static const storage = FlutterSecureStorage();

  static Future<dynamic> getWithoutToken(
      String path, Map<String, dynamic>? parameters) async {
    try {
      var response = await dioWithoutToken.get(
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

  static Future<dynamic> postWithoutToken(String path, dynamic data) async {
    try {
      var response = await dioWithoutToken.post(
        path,
        data: data,
      );
      log(response.toString());
      return response;
    } on DioError catch (e) {
      print(e);
    }
  }

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
      } else if (response.data == null) {
        print(response.statusCode);
        // Get.dialog(const ConnectionErrorDialog());
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
