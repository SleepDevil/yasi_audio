import 'package:agora_flutter_quickstart/src/pages/teacherMask/components/view.dart';
import 'package:agora_flutter_quickstart/src/pages/teacherMask/components/view_with_time.dart';
import 'package:agora_flutter_quickstart/src/utils/api.dart';
import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'components/center_btn.dart';
import 'components/right_to_left_view.dart';
import 'package:web_socket_channel/status.dart' as status;

class StudentCallMask extends StatefulWidget {
  const StudentCallMask({Key key}) : super(key: key);

  @override
  _StudentCallMaskState createState() => _StudentCallMaskState();
}

class _StudentCallMaskState extends State<StudentCallMask>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  var interval = 1 / 5;
  String teacherName, studentName, part2QuestionTitle;

  var channel =
      IOWebSocketChannel.connect(Uri.parse('ws://8.136.109.187:8081/echo'));

  @override
  void initState() {
    channel.stream.listen((message) {
      print(message);
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    );
    _animationController.animateTo(interval * 1);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<String> getPart2Question(String RoomId) async {
    var res = await dio.post('/part2question', data: {'RoomId': RoomId});
    return res.data['data'];
  }

  Future<SharedPreferences> getPrefs() async {
    var localPrefs = await SharedPreferences.getInstance();
    // teacherName = localPrefs.getString('teacher');
    // studentName = localPrefs.getString('student');
    print(localPrefs.getString('roomid'));
    part2QuestionTitle = await getPart2Question(localPrefs.getString('roomid'));
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
        _animationController.value <= interval * 2) {
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
