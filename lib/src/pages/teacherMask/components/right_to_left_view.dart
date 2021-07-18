import 'package:flutter/material.dart';

class CommonView extends StatelessWidget {
  final AnimationController animationController;

  final double beginTime, endTime;
  final String textContent, textTitle;

  const CommonView(
      {Key key,
      @required this.animationController,
      @required this.beginTime,
      @required this.endTime,
      @required this.textContent,
      @required this.textTitle})
      : super(key: key);

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
                    textAlign: TextAlign.left,
                    style: TextStyle(fontFamily: 'Times'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
