import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.env.enableLogging) {
      Logger.d(
        '🚀 REQUEST[${options.method}] => PATH: ${options.path}',
        tag: 'HTTP',
      );
      Logger.d('Headers: ${options.headers}', tag: 'HTTP');
      if (options.queryParameters.isNotEmpty) {
        Logger.d('Query: ${options.queryParameters}', tag: 'HTTP');
      }
      if (options.data != null) {
        Logger.d('Body: ${options.data}', tag: 'HTTP');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (AppConfig.env.enableLogging) {
      Logger.d(
        '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
        tag: 'HTTP',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.env.enableLogging) {
      Logger.e(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
        tag: 'HTTP',
        error: err.message,
      );
    }
    handler.next(err);
  }
}
