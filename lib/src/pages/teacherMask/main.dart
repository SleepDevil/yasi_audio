import 'package:agora_flutter_quickstart/src/pages/teacherMask/components/view.dart';
import 'package:agora_flutter_quickstart/src/pages/teacherMask/components/view_with_time.dart';
import 'package:agora_flutter_quickstart/src/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'components/center_btn.dart';
import 'components/right_to_left_view.dart';
import 'package:web_socket_channel/status.dart' as status;

class CallMask extends StatefulWidget {
  const CallMask({Key key}) : super(key: key);

  @override
  _CallMaskState createState() => _CallMaskState();
}

class _CallMaskState extends State<CallMask> with TickerProviderStateMixin {
  AnimationController _animationController;
  var interval = 1 / 26;
  String teacherName, studentName, identity, topicName;
  List questionArr;
  // var channel =
  //     IOWebSocketChannel.connect(Uri.parse('ws://8.136.109.187:8081/echo'));

  @override
  void initState() {
    // channel.stream.listen((message) {
    //   channel.sink.add('received!');
    //   channel.sink.close(status.goingAway);
    // });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 12),
    );
    _animationController.animateTo(interval * 14);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<SharedPreferences> getPrefs() async {
    var localPrefs = await SharedPreferences.getInstance();
    teacherName = localPrefs.getString('teacher');
    studentName = localPrefs.getString('student');
    identity = await getUserIdentity(studentName);
    // 获取part1问题列表
    var studyArr = await getQuestions('1');
    var workArr = await getQuestions('2');
    if (identity == 'study') {
      studyArr.addAll(workArr);
      questionArr = studyArr;
    } else {
      workArr.addAll(workArr);
      questionArr = workArr;
    }

    // 获取part2 topic
    topicName = await getTopic('2');
    print(topicName);
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
                      beginTime: interval,
                      endTime: interval * 2,
                      textTitle: '预备部分',
                      textContent: '本轮您是老师，请按照屏幕提示向对方提问(读出屏幕中出现的英文)。您准备好了吗？',
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 2,
                      endTime: interval * 3,
                      textTitle: '预备部分',
                      textContent:
                          'This is the speaking test for the International English Language Testing system and conducted. The examiner is ' +
                              (teacherName ?? '') +
                              ' and the candidate is ' +
                              (studentName ?? '') +
                              ' .',
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 3,
                      endTime: interval * 4,
                      textTitle: '预备部分',
                      textContent:
                          'Good afternoon. Can you tell me your full name please?',
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 4,
                      endTime: interval * 5,
                      textTitle: 'Part1',
                      textContent:
                          'Let’s talk about your ' + (identity ?? '') + '.',
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 5,
                      endTime: interval * 6,
                      textTitle: 'Part1',
                      textContent:
                          'Question1:' + questionArr[0]['questionName'],
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 6,
                      endTime: interval * 7,
                      textTitle: 'Part1',
                      textContent:
                          'Question2:' + questionArr[1]['questionName'],
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 7,
                      endTime: interval * 8,
                      textTitle: 'Part1',
                      textContent:
                          'Question3:' + questionArr[2]['questionName'],
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 8,
                      endTime: interval * 9,
                      textTitle: 'Part1',
                      textContent: 'Ok,let’s talk about your ' +
                          (identity == 'study' ? 'work' : 'study') +
                          '.',
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 9,
                      endTime: interval * 10,
                      textTitle: 'Part1',
                      textContent:
                          'Question1:' + questionArr[3]['questionName'],
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 10,
                      endTime: interval * 11,
                      textTitle: 'Part1',
                      textContent:
                          'Question2:' + questionArr[4]['questionName'],
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 11,
                      endTime: interval * 12,
                      textTitle: 'Part1',
                      textContent:
                          'Question3:' + questionArr[5]['questionName'],
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 12,
                      endTime: interval * 13,
                      textTitle: 'Part2',
                      textContent:
                          '''Ok, thank you. Now,in this second part, I’m going to give you a topic and I’d like you to talk about it for one to two minutes. Before you talk you’ll have one minute to think about what you’re going to say, you can make some notes if you wish. Do you understand? Ok, so here’sa pen and paper for making notes and here’s your topic.
All right! Remember you have one to two minutes for this. Don’t worry if I stop you I’ll tell you when the time is up. Can you start speaking now please?
''',
                    ),
                    TimeView(
                      animationController: _animationController,
                      beginTime: interval * 13,
                      endTime: interval * 14,
                      textTitle: 'Part2',
                      textContent: topicName,
                    ),
                    // TopBackSkipView(
                    //   onBackClick: _onBackClick,
                    //   onSkipClick: _onSkipClick,
                    //   animationController: _animationController!,
                    // ),
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
      _animationController?.animateTo(interval * 5);
    } else if (_animationController.value > interval * 4 &&
        _animationController.value <= interval * 5) {
      _animationController?.animateTo(interval * 6);
    } else if (_animationController.value > interval * 5 &&
        _animationController.value <= interval * 6) {
      _animationController?.animateTo(interval * 7);
    } else if (_animationController.value > interval * 6 &&
        _animationController.value <= interval * 7) {
      _animationController?.animateTo(interval * 8);
    } else if (_animationController.value > interval * 7 &&
        _animationController.value <= interval * 8) {
      _animationController?.animateTo(interval * 9);
    } else if (_animationController.value > interval * 8 &&
        _animationController.value <= interval * 9) {
      _animationController?.animateTo(interval * 10);
    } else if (_animationController.value > interval * 9 &&
        _animationController.value <= interval * 10) {
      _animationController?.animateTo(interval * 11);
    } else if (_animationController.value > interval * 10 &&
        _animationController.value <= interval * 11) {
      _animationController?.animateTo(interval * 12);
    } else if (_animationController.value > interval * 11 &&
        _animationController.value <= interval * 12) {
      _animationController?.animateTo(interval * 13);
    } else if (_animationController.value > interval * 12 &&
        _animationController.value <= interval * 13) {
      _animationController?.animateTo(interval * 14);
    } else if (_animationController.value > interval * 13 &&
        _animationController.value <= interval * 14) {
      _animationController?.animateTo(interval * 15);
    }
    print(_animationController.value <= interval);
  }
}
