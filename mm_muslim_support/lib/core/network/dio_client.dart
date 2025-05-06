import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mm_muslim_support/utility/constants.dart'; // for debugPrint

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 100),
    receiveTimeout: const Duration(seconds: 100),
  )) {
    // Add interceptors
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));

    // Add error middleware
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) {
        _handleError(e);
        return handler.next(e); // continue
      },
    ));
  }

  void _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      debugPrint('Connection timeout!');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      debugPrint('Receive timeout!');
    } else if (error.type == DioExceptionType.badResponse) {
      final status = error.response?.statusCode;
      final message = error.response?.data.toString();
      debugPrint('API Error: $status - $message');
    } else {
      debugPrint('Unexpected Dio error: ${error.message}');
    }
    // You can also throw custom exceptions here
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams, Options? options}) {
    return _dio.get(path, queryParameters: queryParams, options: options);
  }

  Future<Response> post(String path, {dynamic data, Options? options}) {
    return _dio.post(path, data: data, options: options);
  }

  Future<Response> put(String path, {dynamic data, Options? options}) {
    return _dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) {
    return _dio.delete(path, data: data, options: options);
  }

  Future<Response> postMultipart(String path, Map<String, dynamic> fields, List<MultipartFile> files,
      {Options? options}) {
    final formData = FormData.fromMap({
      ...fields,
      'files': files,
    });
    return _dio.post(path, data: formData, options: options);
  }

  Future<void> downloadFile(
      String url,
      String savePath, {
        required void Function(int received, int total) onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        options: Options(responseType: ResponseType.bytes),
      );
    } catch (e) {
      debugPrint('Download error: $e');
      rethrow;
    }
  }
}
