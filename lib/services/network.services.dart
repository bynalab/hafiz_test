import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.alquran.cloud/v1/',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<Response?> get(String url) async {
    try {
      return await _dio.get(url);
    } on DioException catch (e, stackTrace) {
      _logError('DioException', e.message, stackTrace);
    } catch (e, stackTrace) {
      _logError('UnknownException', e.toString(), stackTrace);
    }

    return null;
  }

  void _logError(String type, String? message, StackTrace stackTrace) {
    if (kDebugMode) {
      print('[$type] $message');
      print(stackTrace);
    }
  }
}
