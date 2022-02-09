import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

abstract class BaseService {
  final Dio dio = new Dio();
  late String serviceUrl;
  BaseService(String path) {
    serviceUrl = 'https://vis.aih.az/api/$path/';
    // 'http://192.168.43.66:5000/api/$path/';
    // 'https://gistest.aih.local/api/$path/';
    // 'https://185.96.125.248/api/$path/';
    // 'https://vis.aih.az/api/$path/';
     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
  }
}
