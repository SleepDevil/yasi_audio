import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:agora_flutter_quickstart/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dio/dio.dart';

void main() {
  // dio.interceptors.add(InterceptorsWrapper(onError: (DioError err, handler) {
  //   print(err);
  //   if (err.response.statusCode == 502) {
  //     showToast('服务器错误，请联系管理员');
  //   }
  //   return handler.next(err);
  // }));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('zh', 'CN'),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
      ],
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexPage(),
    );
  }
}
