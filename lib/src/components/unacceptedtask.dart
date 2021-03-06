import 'package:agora_flutter_quickstart/src/pages/login.dart';
import 'package:agora_flutter_quickstart/src/utils/api.dart';
import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:agora_flutter_quickstart/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnAcceptedTask extends StatefulWidget {
  final String CreatedAt;
  final String CreatedBy;
  final String headerImg;
  final String OralScore;
  final String AcceptedBy;
  final String accepted;
  final String TargetScore;
  final String BattleTime;
  final String RoomId;
  final Function GetTask;

  UnAcceptedTask({
    Key key,
    @required this.CreatedAt,
    @required this.CreatedBy,
    @required this.headerImg,
    @required this.OralScore,
    @required this.AcceptedBy,
    @required this.accepted,
    @required this.TargetScore,
    @required this.BattleTime,
    @required this.RoomId,
    @required this.GetTask,
  }) : super(key: key);

  @override
  _UnAcceptedTaskState createState() => _UnAcceptedTaskState(
      CreatedAt,
      CreatedBy,
      headerImg,
      OralScore,
      AcceptedBy,
      accepted,
      TargetScore,
      BattleTime,
      RoomId,
      GetTask);
}

class _UnAcceptedTaskState extends State<UnAcceptedTask> {
  String CreatedAt,
      CreatedBy,
      headerImg,
      OralScore,
      AcceptedBy,
      accepted,
      TargetScore,
      BattleTime,
      RoomId;
  Function GetTask;
  _UnAcceptedTaskState(
      this.CreatedAt,
      this.CreatedBy,
      this.headerImg,
      this.OralScore,
      this.AcceptedBy,
      this.accepted,
      this.TargetScore,
      this.BattleTime,
      this.RoomId,
      this.GetTask);

  @override
  void initState() {
    super.initState();
  }

  void accept() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('nickname') == null) {
      showToast('请先登录！');
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      })).then((value) => setState(() {}));
      return;
    }
    if (prefs.getString('nickname') == CreatedBy) {
      showToast('不能接受自己的任务哦');
      return;
    }
    BattleTime =
        DateTime.parse(BattleTime).toLocal().toString().substring(0, 19);
    var res = await dio.post('/room', data: {
      'RoomId': RoomId,
      'AcceptedBy': prefs.getString('nickname'),
      'BattleTime': BattleTime,
      'Founder': CreatedBy
    });
    var topicRes = await getTopicRedis('2', RoomId);
    print(topicRes);
    if (res.data['code'] != 0) {
      showToast(res.data['msg']);
      return;
    }
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          var formatedBattletime = formatDate(DateTime.parse(BattleTime),
              [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
          return AlertDialog(
            title: Text('接受成功'),
            content: Text('预定的房间号为：' +
                RoomId +
                '，时间为：' +
                formatedBattletime +
                '请记住您的房间号并按时参加'),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('确定'), //关闭对话框
              ),
              OutlinedButton(
                onPressed: () async {
                  showToast('房间号和时间已复制到您的剪贴板！');
                  Navigator.of(context).pop(true); //关闭对话框
                  await Clipboard.setData(
                      ClipboardData(text: formatedBattletime + '   ' + RoomId));
                },
                child: Text('复制并继续'),
              ),
            ],
          );
        });
    await GetTask();
  }

  @override
  Widget build(BuildContext context) {
    BattleTime =
        DateTime.parse(BattleTime).toLocal().toString().substring(0, 19);

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: CircleAvatar(
                      //头像半径
                      radius: 20,
                      //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                      backgroundImage: NetworkImage(headerImg),
                    ),
                  ),
                  Column(
                    children: [
                      Text(CreatedBy),
                      Text(
                        '口语成绩：' + OralScore,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  )
                ],
              ),
              Text('发布于：' + CreatedAt.substring(0, 10))
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '预定时间：' + BattleTime,
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  child: Text(
                    '目标分数：' + TargetScore,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                ElevatedButton(
                    onPressed: accept,
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(50, 25)),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    child: Text('接受')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
