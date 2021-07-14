import 'package:agora_flutter_quickstart/src/pages/audio.dart';
import 'package:agora_flutter_quickstart/src/pages/teacherMask/main.dart';
// import 'package:agora_flutter_quickstart/src/pages/learn.dart';
import 'package:agora_flutter_quickstart/src/pages/community.dart';
import 'package:agora_flutter_quickstart/src/pages/personal.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final pages = [CallMask(), CommunityPage(), AudioPage(), PersonalPage()];
  var currentIndex = 0;

  void _changePage(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '学习',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '社区',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_in_talk),
            label: '口语',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '个人中心',
          )
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _changePage(index);
        },
        currentIndex: currentIndex,
      ),
      body: pages[currentIndex],
    );
  }
}
