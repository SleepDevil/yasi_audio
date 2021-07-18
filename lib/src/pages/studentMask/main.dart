import 'dart:async';
import 'dart:convert';
import 'package:agora_flutter_quickstart/src/pages/studentMask/components/view.dart';
import 'package:agora_flutter_quickstart/src/pages/studentMask/components/view_with_time.dart';
import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/center_btn.dart';
import 'components/right_to_left_view.dart';

class StudentCallMask extends StatefulWidget {
  final int part2QuestionIndex;
  const StudentCallMask({Key key, @required this.part2QuestionIndex})
      : super(key: key);

  @override
  _StudentCallMaskState createState() =>
      _StudentCallMaskState(part2QuestionIndex);
}

class _StudentCallMaskState extends State<StudentCallMask>
    with TickerProviderStateMixin {
  var part2questionIndex;
  _StudentCallMaskState(this.part2questionIndex);

  AnimationController _animationController;
  var interval = 1 / 5;
  String teacherName, studentName, part2QuestionTitle;
  var leftTime = 2;
  Timer _timer;

  void ticker() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      leftTime -= 1;
      if (leftTime <= 0) {
        _timer.cancel();
      }
    });
  }

  @override
  void initState() {
    print('part2QuestionIndex===============');
    print(part2questionIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );
    _animationController.animateTo(interval * 1);
    Timer checkTime;
    checkTime = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_animationController.value == 0.4) {
        checkTime.cancel();
        ticker();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future getPart2Question(String RoomId) async {
    var res = await dio.post('/part2question', data: {'RoomId': RoomId});
    return res.data['data'];
  }

  Future<SharedPreferences> getPrefs() async {
    var localPrefs = await SharedPreferences.getInstance();
    // teacherName = localPrefs.getString('teacher');
    // studentName = localPrefs.getString('student');
    print(localPrefs.getString('roomid'));
    var resArr = await getPart2Question(localPrefs.getString('roomid'));
    resArr = jsonDecode(resArr);
    part2QuestionTitle = resArr[part2questionIndex]['topicName'];
    print(part2QuestionTitle);
    return localPrefs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPrefs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Color(0xffF7EBE1),
              appBar: AppBar(title: Text('Index')),
              body: ClipRect(
                child: Stack(
                  children: [
                    View(
                      animationController: _animationController,
                      beginTime: 0.0,
                      endTime: interval,
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 1,
                      endTime: interval * 2,
                      textTitle: '预备部分',
                      textContent:
                          '请听老师提问，并作答。                                    ',
                    ),
                    TimeView(
                      animationController: _animationController,
                      beginTime: interval * 2,
                      endTime: interval * 3,
                      textTitle: 'Part2',
                      textContent: part2QuestionTitle == 'redis: nil'
                          ? '获取题目出错，请联系管理员'
                          : part2QuestionTitle,
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 3,
                      endTime: interval * 4,
                      textTitle: '结束',
                      textContent:
                          '已结束，是否切换角色？                                    ',
                    ),
                    CenterNextButton(
                      animationController: _animationController,
                      onNextClick: _onNextClick,
                      beginTime: 0.0,
                      endTime: interval * 2,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Text('加载中');
          }
        });
  }

  void _onNextClick() {
    if (_animationController.value >= 0 &&
        _animationController.value <= interval) {
      _animationController?.animateTo(interval * 2);
    } else if (_animationController.value > interval &&
        _animationController.value <= interval * 2 &&
        leftTime <= 0) {
      _animationController?.animateTo(interval * 3);
    } else if (_animationController.value > interval * 2 &&
        _animationController.value <= interval * 3) {
      _animationController?.animateTo(interval * 4);
    } else if (_animationController.value > interval * 3 &&
        _animationController.value <= interval * 4) {
      // 切换角色
      // changeRole();
      Navigator.pop(context);
    }
    // print(_animationController.value <= interval);
  }
}
