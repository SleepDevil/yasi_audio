import 'dart:async';

import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:agora_flutter_quickstart/src/utils/toast.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'call.dart';

class AudioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AudioState();
}

class AudioState extends State<AudioPage> {
  /// create a channelController to retrieve text value
  final TextEditingController _channelController = TextEditingController();
// ignore: unnecessary_new
  final GlobalKey _formKey = new GlobalKey<FormState>();
  final ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('口语'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/assets/audio_bgc.jpg'),
                  fit: BoxFit.cover)),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 400,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _channelController,
                          decoration: InputDecoration(
                              hintText: '请输入房间号',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0))),
                          validator: (value) {
                            if (value.isEmpty) {
                              return '房间号不能为空';
                            }
                            return null;
                          },
                        ),
                      ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35))),
                            ),
                            onPressed: onJoin,
                            child: Text('进入'),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future getToken() async {
    print(_channelController.text);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('roomid', _channelController.text);
    var response =
        await dio.post('/token', data: {'RoomId': _channelController.text});

    if (response.data['code'] != 0) {
      if (response.data['data'] == 'record not found') {
        return 'not found';
      }
      return 'fail';
    }
    return response.data['data'];
  }

  Future<void> onJoin() async {
    if ((_formKey.currentState as FormState).validate()) {
      var data = await getToken();
      if (data == 'fail') {
        showToast('进入房间失败，请联系管理员');
        return;
      }
      if (data == 'not found') {
        showToast('房间不存在');
        return;
      }
      var prefs = await SharedPreferences.getInstance();
      if (_channelController.text.isNotEmpty) {
        await _handleCameraAndMic(Permission.microphone);
        // push video page with given channel name
        await prefs.setString('teacher', data['teacher']);
        await prefs.setString('student', data['student']);

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallPage(
              channelName: _channelController.text,
              role: _role,
              token: data['token'],
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
