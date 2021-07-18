import 'dart:async';

import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:agora_flutter_quickstart/src/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  TextEditingController targetscore = TextEditingController();
  TextEditingController roomid = TextEditingController();
  var currentTime = DateTime.now().toString().substring(0, 16) + ':00';
  final _formKey = GlobalKey();

  void createtask() async {
    if ((_formKey.currentState as FormState).validate()) {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.getString('nickname') == null) {
        showToast('请先登录');
        Timer(Duration(seconds: 2), () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginPage();
          }));
        });
        return;
      }
      print(currentTime);
      var res = await dio.post('/task', data: {
        'CreatedBy': prefs.getString('nickname'),
        'CreatedHead': prefs.getString('headerimg'),
        'CreatedScore': prefs.getString('oralscore'),
        'AcceptedBy': 'nobody',
        'Accepted': false,
        'TargetScore': targetscore.text,
        'BattleTime': currentTime,
        'RoomId': roomid.text
      });
      if (res.data['msg']
          .toString()
          .startsWith('Error 1062: Duplicate entry')) {
        showToast('该房间号已存在，请更换后重试');
        return;
      }
      print(res.data['msg']);
      if (res.data['code'] == 0) {
        showToast('发布成功！');
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context, '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发布任务'),
        actions: [
          ElevatedButton(
            onPressed: createtask,
            child: Text(
              '发布',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/assets/audio_bgc.jpg'),
                  fit: BoxFit.cover)),
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 140,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Center(
                              child: Text('目标口语成绩',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              controller: targetscore,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: '请输入目标口语成绩',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(40.0))),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '口语成绩不能为空';
                                }
                                return null;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 140,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Center(
                              child: Text('房间号',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: roomid,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: '请输入预定房间号',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(40.0))),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '房间号不能为空';
                                }
                                return null;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 140,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Center(
                              child: Text('约定时间',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: InkWell(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: 200,
                                            child: CupertinoDatePicker(
                                              initialDateTime:
                                                  DateTime.parse(currentTime),
                                              onDateTimeChanged: (date) {
                                                setState(() {
                                                  print(date);
                                                  currentTime = date
                                                          .toString()
                                                          .substring(0, 16) +
                                                      ':00';
                                                });
                                              },
                                            ),
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(currentTime),
                                  ))),
                        )
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}
