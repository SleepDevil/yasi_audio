import 'package:dio/dio.dart';

var options = BaseOptions(
  baseUrl: 'https://sleepdevil.top/yasi',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

Dio dio = Dio(options);
