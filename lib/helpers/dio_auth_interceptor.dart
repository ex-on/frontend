import 'package:dio/dio.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/helpers/parse_jwt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

enum TokenErrorType { tokenNotFound, failedAccessTokenRegeneration }

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    var refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken != null) {
      var accessToken = await storage.read(key: 'access_token');
      if (parseJwt(accessToken!)["exp"] * 1000 <
              DateTime.now().millisecondsSinceEpoch ||
          (accessToken == null)) {
        print('Access token expired');
        await AmplifyService.getTokensWithRefreshToken(refreshToken);
        accessToken = await storage.read(key: 'access_token');
        print('Access token updated');
      }
      options.headers['Authorization'] = 'Bearer $accessToken';
      handler.next(options);
    } else {
      print("refresh token doesn't exist");
      options.extra['tokenErrorType'] = TokenErrorType.tokenNotFound;
      DioError _err = DioError(requestOptions: options);
      handler.reject(_err, true);
    }
  }

  @override
  void onResponse(
    dynamic response,
    ResponseInterceptorHandler handler,
  ) =>
      handler.next(response);

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    print(err.requestOptions);
    if (err.requestOptions.extra['tokenErrorType'] ==
        TokenErrorType.tokenNotFound) {
      Get.offNamed('/auth');
      return;
    }
    handler.next(err);
  }
}
