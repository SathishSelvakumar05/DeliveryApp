import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioProvider {
  static final DioProvider _singleton = DioProvider._internal();
  final ValueNotifier<int> apiCallCount = ValueNotifier<int>(0);

  static final PrettyDioLogger _logger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    error: true,
    compact: false,
    maxWidth: 500,
  );



  factory DioProvider() {
    return _singleton;
  }

  DioProvider._internal() {
    // alice = Alice(
    //     showNotification: true, showInspectorOnShake: true, darkTheme: true);
    _dio = Dio();
    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        apiCallCount.value++;
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        return handler.next(response); // continue
      },
      onError: (DioException e, handler) {
        return handler.next(e); //continue
      },
    ));
    // _dio!.interceptors.add(alice.getDioInterceptor());
    _dio!.interceptors.add(_logger);
  }

  static Dio? _dio;

  Dio get service {
    return _dio!;
  }

  void clearInterceptors() {
    _dio!.interceptors.clear();
    // _dio!.interceptors.add(alice.getDioInterceptor());
    _dio!.interceptors.add(_logger);
  }

  void resetApiCallCount() {
    apiCallCount.value = 0;
  }
}
