import 'dart:async';

import 'package:flutter/material.dart';

class TimeView extends StatefulWidget {
  final AnimationController animationController;
  final double beginTime;
  final double endTime;
  final String textContent;
  final String textTitle;

  TimeView({
    Key key,
    @required this.animationController,
    @required this.beginTime,
    @required this.endTime,
    @required this.textContent,
    @required this.textTitle,
  }) : super(key: key);

  @override
  _TimeViewState createState() => _TimeViewState(
      animationController, beginTime, endTime, textContent, textTitle);
}

class _TimeViewState extends State<TimeView> {
  String textContent, textTitle;
  double beginTime, endTime;
  AnimationController animationController;
  Timer _timer;

  _TimeViewState(this.animationController, this.beginTime, this.endTime,
      this.textContent, this.textTitle);

  var leftTime = 60;
  final _streamController = StreamController<int>();

  @override
  void initState() {
    Timer checkTime;
    checkTime = Timer.periodic(Duration(seconds: 1), (timer) {
      if (animationController.value == 0.7692307692307693) {
        checkTime.cancel();
        ticker();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void ticker() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      leftTime -= 1;
      _streamController.add(leftTime);
      if (leftTime <= 0) {
        _streamController.close();
        _timer.cancel();
        setState(() {
          textContent = '请您回答                                 ';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          beginTime,
          endTime,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          endTime,
          endTime * 2 - beginTime,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _textAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          beginTime,
          endTime,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _relaxAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          beginTime,
          endTime,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _relaxAnimation,
                child: Text(
                  textTitle ?? '',
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times'),
                ),
              ),
              SlideTransition(
                position: _textAnimation,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 64, right: 64, top: 16, bottom: 16),
                  child: Text(
                    textContent ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Times'),
                  ),
                ),
              ),
              SlideTransition(
                position: _textAnimation,
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 64, right: 64, top: 16, bottom: 16),
                    child: StreamBuilder<int>(
                      initialData: 60,
                      stream: _streamController.stream, //
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return Text('剩余时间: ${snapshot.data}');
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
