import 'package:agora_flutter_quickstart/src/pages/teacherMask/components/view.dart';
import 'package:flutter/material.dart';

import 'components/center_btn.dart';
import 'components/right_to_left_view.dart';

class CallMask extends StatefulWidget {
  const CallMask({Key key}) : super(key: key);

  @override
  _CallMaskState createState() => _CallMaskState();
}

class _CallMaskState extends State<CallMask> with TickerProviderStateMixin {
  AnimationController _animationController;
  var interval = 1 / 26;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
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
            ),
            CommonView(
              animationController: _animationController,
              beginTime: interval * 2,
              endTime: interval * 3,
            ),
            CommonView(
              animationController: _animationController,
              beginTime: 0.3,
              endTime: 0.4,
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
              endTime: interval,
            ),
          ],
        ),
      ),
    );
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
