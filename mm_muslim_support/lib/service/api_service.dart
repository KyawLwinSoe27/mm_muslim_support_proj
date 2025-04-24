import 'package:dio/dio.dart';
import 'package:mm_muslim_support/core/network/dio_client.dart';

class ApiService {
  final DioClient _client = DioClient();

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) {
    return _client.get(path, queryParams: queryParams);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _client.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _client.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) {
    return _client.delete(path, data: data);
  }

  Future<Response> upload(String path, Map<String, dynamic> fields, List<MultipartFile> files) {
    return _client.postMultipart(path, fields, files);
  }
}
