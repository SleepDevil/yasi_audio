import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class CenterNextButton extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onNextClick;
  final double beginTime, endTime;

  const CenterNextButton(
      {Key key,
      @required this.animationController,
      @required this.onNextClick,
      @required this.beginTime,
      @required this.endTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var interval = 1 / 5;

    final _topMoveAnimation =
        Tween<Offset>(begin: Offset(0, 5), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        beginTime,
        endTime / 2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _signUpMoveAnimation =
        Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        endTime,
        endTime * 2 - beginTime,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return Padding(
      padding:
          EdgeInsets.only(bottom: 16 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _topMoveAnimation,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => AnimatedOpacity(
                    opacity: animationController.value >= interval &&
                            animationController.value <= 1 - interval
                        ? 1
                        : 0,
                    duration: Duration(milliseconds: 480),
                    child: _pageView(),
                  ),
                ),
              ),
            ],
          ),
          SlideTransition(
            position: _topMoveAnimation,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) => Padding(
                padding: EdgeInsets.only(bottom: 38),
                child: Container(
                  height: 58,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color(0xff132137),
                  ),
                  child: PageTransitionSwitcher(
                    duration: Duration(milliseconds: 480),
                    // reverse: _signUpMoveAnimation.value < 0.7,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return SharedAxisTransition(
                        fillColor: Colors.transparent,
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        child: child,
                      );
                    },
                    child: animationController.value == 0.9615384615384616
                        ? InkWell(
                            key: ValueKey('next button'),
                            onTap: onNextClick,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '切换角色',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_rounded,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          )
                        : _signUpMoveAnimation.value > interval * 2
                            ? InkWell(
                                key: ValueKey('next button'),
                                onTap: onNextClick,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '下一步',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_rounded,
                                          color: Colors.white),
                                    ],
                                  ),
                                ),
                              )
                            : InkWell(
                                key: ValueKey('next button'),
                                onTap: onNextClick,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        '准备好了',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_rounded,
                                          color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageView() {
    var interval = 1 / 5;
    var _selectedIndex = 0;

    if (animationController.value >= interval * 9 / 2) {
      _selectedIndex = 4;
    } else if (animationController.value >= interval * 7 / 2) {
      _selectedIndex = 3;
    } else if (animationController.value >= interval * 5 / 2) {
      _selectedIndex = 2;
    } else if (animationController.value >= interval * 3 / 2) {
      _selectedIndex = 1;
    } else if (animationController.value >= interval / 2) {
      _selectedIndex = 0;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ignore: sdk_version_ui_as_code
              for (var i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 480),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: _selectedIndex == i
                          ? Color(0xff132137)
                          : Color(0xffE3E4E4),
                    ),
                    width: 10,
                    height: 10,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
