import 'package:agora_flutter_quickstart/src/pages/teacherMask/components/view.dart';
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
  String teacherName, studentName;
  var channel =
      IOWebSocketChannel.connect(Uri.parse('ws://8.136.109.187:8081/echo'));

  @override
  void initState() {
    channel.stream.listen((message) {
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 48),
    );
    _animationController.animateTo(interval);
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
    print(localPrefs.getString('teacher'));
    print(localPrefs.getString('student'));
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
                      textTitle: '预备部分',
                      textContent: 'Ok, and can I see the ID please?',
                    ),
                    CommonView(
                      animationController: _animationController,
                      beginTime: interval * 5,
                      endTime: interval * 6,
                      textTitle: '预备部分',
                      textContent:
                          'Now, in the first part I’d like to ask you a series of short questions.',
                    ),
                    // CommonView(
                    //   animationController: _animationController,
                    //   beginTime: 0.8,
                    //   endTime: 1.0,
                    // ),
                    // CommonView(
                    //   animationController: _animationController,
                    //   beginTime: 1.0,
                    //   endTime: 1.2,
                    // ),
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
    }
    print(_animationController.value <= interval);
  }
}
