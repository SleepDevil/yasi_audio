import 'dart:async';

import 'package:agora_flutter_quickstart/src/pages/createtask.dart';
import 'package:agora_flutter_quickstart/src/utils/api.dart';
import 'package:flutter/material.dart';
import '../components/unacceptedtask.dart';
import '../components/acceptedtask.dart';
import '../utils/dio.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  var taskLists = [];
  var copyList = [];
  var selectedCategory = '未接受';
  Future GetTasks() async {
    var res = await dio.get('/task');
    taskLists = copyList = res.data['data']['tasks'];
    var filtArr = ArrFilter(copyList, (e) {
      if (selectedCategory == '未接受') {
        return e['accepted'] == false;
      } else {
        return e['accepted'] == true;
      }
    });
    setState(() {
      taskLists = filtArr;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    MockFirstClick();
  }

  // 用来解决第一次进入页面不加载数据的情况，模拟点击未接受情况
  void MockFirstClick() async {
    await GetTasks();
    handleSelectChange('未接受');
  }

  List ArrFilter(List arr, fn) {
    var newArr = [];
    for (var i = 0; i < arr.length; i++) {
      if (fn(arr[i])) {
        newArr.add(arr[i]);
      } else {
        continue;
      }
    }
    return newArr;
  }

  void handleSelectChange(value) {
    print(value);
    var filtArr = ArrFilter(copyList, (e) {
      if (value == '未接受') {
        return e['accepted'] == false;
      } else {
        return e['accepted'] == true;
      }
    });
    setState(() {
      selectedCategory = value;
      taskLists = filtArr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('社区'),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('分类：'),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 15),
              child: DropdownButton(
                items: [
                  DropdownMenuItem(
                    value: '未接受',
                    child: Text('未接受'),
                  ),
                  DropdownMenuItem(
                    value: '已接受',
                    child: Text('已接受'),
                  ),
                ],
                value: selectedCategory,
                onChanged: handleSelectChange,
              ),
            )
          ],
        ),
        body: Container(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: GetTasks,
                child: ListView.builder(
                    itemCount: taskLists.length,
                    itemBuilder: (context, i) {
                      if (selectedCategory == '未接受') {
                        return UnAcceptedTask(
                            CreatedAt: taskLists[i]['CreatedAt'],
                            CreatedBy: taskLists[i]['CreatedBy'],
                            headerImg: taskLists[i]['headerImg'],
                            OralScore: taskLists[i]['OralScore'],
                            AcceptedBy: taskLists[i]['AcceptedBy'],
                            accepted: taskLists[i]['accepted'].toString(),
                            TargetScore: taskLists[i]['TargetScore'],
                            BattleTime: taskLists[i]['BattleTime'],
                            RoomId: taskLists[i]['RoomId'],
                            GetTask: () => GetTasks());
                      } else {
                        return AcceptedTask(
                          CreatedAt: taskLists[i]['CreatedAt'],
                          CreatedBy: taskLists[i]['CreatedBy'],
                          headerImg: taskLists[i]['headerImg'],
                          OralScore: taskLists[i]['OralScore'],
                          AcceptedBy: taskLists[i]['AcceptedBy'],
                          accepted: taskLists[i]['accepted'].toString(),
                          TargetScore: taskLists[i]['TargetScore'],
                          BattleTime: taskLists[i]['BattleTime'],
                        );
                      }
                    }),
              ),
              Positioned(
                bottom: 40.0,
                right: 40.0,
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CreateTaskPage();
                    })).then((value) {
                      GetTasks();
                    })
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 40.0,
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
