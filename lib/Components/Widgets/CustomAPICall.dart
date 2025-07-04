import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/CustomToast/CustomToast.dart';
import '../../Utils/Alice/Alice.dart';
import '../../Utils/Constants/TextConstants.dart';

class CustomApiCallService {
  Dio dio = DioProvider().service;

  Future<Map<String, String>> _prepareHeaders(
      String? token, bool? isImageUpload) async {
    final SharedPreferences localDb = await SharedPreferences.getInstance();
    // String? cookies = localDb.getString('cookies');
    return {
      //isImageUpload!? "multipart/form-data":
      TextConstants.contentType: TextConstants.applicationJson,
      // "TIMEZONE": currentTimeZone,
      if (token != '') TextConstants.authorization: '${TextConstants.bearer} $token'
      else TextConstants.xClientType :TextConstants.mobile
      // if (cookies != null) 'Cookie': cookies,
    };
  }

  Future<Response<dynamic>> makeApiRequest(
      {required String method,
      required String token,
      required String url,
      Map<String, dynamic>? data,
      dynamic? imageData,
      bool? isImageUpload}) async {
    try {
      final headers = await _prepareHeaders(token, isImageUpload);

      Response response;
      switch (method) {
        case TextConstants.get:
          response = await dio.get(url, options: Options(headers: headers));
          break;
        case TextConstants.post:
          response = await dio.post(url,
              data: data, options: Options(headers: headers));
          break;
        case TextConstants.put:
          response = await dio.put(url,
              data: isImageUpload! ? imageData : data,
              options: Options(headers: headers));
          break;
        case TextConstants.patch:
          response = await dio.patch(url,
              data: data, options: Options(headers: headers));
          break;
        case TextConstants.delete:
          response = await dio.delete(url,
              data: data, options: Options(headers: headers));
          break;

        default:
          throw Exception(TextConstants.invalidHTTPMethod);
      }
      return response;
    } on DioException catch (e) {
      showSuccessToast(
          e.response?.data[TextConstants.error.toString()] ?? e.response?.data[TextConstants.message]);
      rethrow;
    }
  }
  // Future<LoginState> userRefreshLogin(
  //     String token,
  //     ) async {
  //   final SharedPreferences localDb = await SharedPreferences.getInstance();
  //   try {
  //     Response response = await makeApiRequest(
  //         method: 'POST', token: token, url: ApiLinks.loginApi);
  //     LoginState refreshData = LoginState.fromJson(response.data);
  //     await localDb.setInt(
  //         "expiresInTimeStampValue", refreshData.data!.expiresIn!);
  //     await localDb.setString("loginToken", refreshData.data!.jwtToken!);
  //     return response.data = LoginState.fromJson(response.data);
  //   } catch (error) {
  //     throw Exception('Failed to login: $error');
  //   }
  // }
}


