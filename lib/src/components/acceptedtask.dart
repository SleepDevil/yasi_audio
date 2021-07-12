import 'package:flutter/material.dart';

class AcceptedTask extends StatefulWidget {
  final String CreatedAt;
  final String CreatedBy;
  final String headerImg;
  final String OralScore;
  final String AcceptedBy;
  final String accepted;
  final String TargetScore;
  final String BattleTime;

  AcceptedTask(
      {Key key,
      @required this.CreatedAt,
      @required this.CreatedBy,
      @required this.headerImg,
      @required this.OralScore,
      @required this.AcceptedBy,
      @required this.accepted,
      @required this.TargetScore,
      @required this.BattleTime})
      : super(key: key);

  @override
  _AcceptedTaskState createState() => _AcceptedTaskState(CreatedAt, CreatedBy,
      headerImg, OralScore, AcceptedBy, accepted, TargetScore, BattleTime);
}

class _AcceptedTaskState extends State<AcceptedTask> {
  String CreatedAt,
      CreatedBy,
      headerImg,
      OralScore,
      AcceptedBy,
      accepted,
      TargetScore,
      BattleTime;
  _AcceptedTaskState(
      this.CreatedAt,
      this.CreatedBy,
      this.headerImg,
      this.OralScore,
      this.AcceptedBy,
      this.accepted,
      this.TargetScore,
      this.BattleTime);

  @override
  void initState() {
    super.initState();
  }

  void accept() {}

  @override
  Widget build(BuildContext context) {
    BattleTime =
        DateTime.parse(BattleTime).toLocal().toString().substring(0, 19);
    print(BattleTime);
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey)),
                    child: Text('已接受')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
