import 'dart:async';

import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:http/http.dart' as http;
import 'package:agora_flutter_quickstart/src/utils/toast.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call.dart';

class AudioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AudioState();
}

class AudioState extends State<AudioPage> {
  /// create a channelController to retrieve text value
  final TextEditingController _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

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
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: _channelController,
                    decoration: InputDecoration(
                      errorText: _validateError ? '请输入房间号' : null,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                      hintText: '请输入房间号',
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
    );
  }

  Future<String> getToken() async {
    var response =
        await dio.post('/token', data: {'RoomId': _channelController.text});

    print(response);
    if (response.data['code'] != 0) {
      if (response.data['data'] == 'record not found') {
        return 'not found';
      }
      return 'fail';
    }
    return response.data['data'];
  }

  Future<void> onJoin() async {
    var token = await getToken();
    print(token);
    if (token == 'fail') {
      showToast('进入房间失败，请联系管理员');
      return;
    }
    if (token == 'not found') {
      showToast('房间不存在');
      return;
    }
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
              channelName: _channelController.text, role: _role, token: token),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
