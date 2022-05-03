import 'package:dio/dio.dart';
import 'package:exon_app/core/controllers/connection_controller.dart';
import 'package:exon_app/core/services/amplify_service.dart';
import 'package:exon_app/helpers/dio_connectivity_request_retrier.dart';
import 'package:exon_app/helpers/parse_jwt.dart';
import 'package:exon_app/ui/widgets/common/connection_error_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

enum TokenErrorType { tokenNotFound, failedAccessTokenRegeneration }

class DioAuthInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  DioAuthInterceptor({
    required this.requestRetrier,
  });

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
    // storage.deleteAll();
    // return;
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
    ConnectionController.to.setLoading(false);
    print(err.requestOptions);
    if (err.requestOptions.extra['tokenErrorType'] ==
        TokenErrorType.tokenNotFound) {
      Get.offNamed('/auth');
      return;
    } else if (err.response!.statusCode == 303) {
      Get.toNamed('/register_info');
      return;
    } else {
      if (!Get.isDialogOpen!) {
        Get.dialog(
          ConnectionErrorDialog(
            onRetryPressed: () async {
              try {
                ConnectionController.to.setLoading(true);
                var res = await requestRetrier
                    .scheduleRequestRetry(err.requestOptions);
                ConnectionController.to.setLoading(false);
                if (res.statusCode! < 300) {
                  Get.until((route) => !Get.isDialogOpen!);
                  ConnectionController.to.completeRefresh();
                }
              } catch (e) {
                ConnectionController.to.setLoading(false);
                print(e);
              }
            },
          ),
          barrierDismissible: false,
        );
        return;
      }
      return;
    }

    // bool _shouldRetry(DioError err) {
    //   return err.type == DioErrorType.other &&
    //       err.error != null &&
    //       err.error is SocketException;
    // }

    // handler.next(err);
  }
}
