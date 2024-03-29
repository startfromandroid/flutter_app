import 'dart:io';

import 'package:dio/dio.dart';

const isWeb = true;

class DioManager {
  Dio _dio;

  factory DioManager() => singleton;

  DioManager._internal() {
    // 配置dio实例
    _dio = new Dio();

    dio.options.baseUrl =
        isWeb ? "http://localhost:4040/" : "https://www.wanandroid.com/";

    dio.options.connectTimeout = 8000; //5s
    dio.options.receiveTimeout = 4000;
  }

  static DioManager singleton = DioManager._internal();

  Dio get dio => _dio;
}
