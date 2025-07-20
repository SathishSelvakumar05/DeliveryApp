import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🔸 REQUEST [${options.method}] => PATH: ${options.path}');
          print('🔸 HEADERS: ${options.headers}');
          print('🔸 BODY: ${options.data}');
          return handler.next(options); // continue
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE [${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response); // continue
        },
        onError: (DioException e, handler) {
          print('❌ ERROR [${e.response?.statusCode}] => MESSAGE: ${e.message}');
          print('❌ RESPONSE: ${e.response?.data}');
          return handler.next(e); // continue
        },
      ),
    );
  }

  Dio get client => _dio;
}
