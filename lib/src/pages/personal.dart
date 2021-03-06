import 'dart:io';

import 'package:agora_flutter_quickstart/src/pages/login.dart';
import 'package:agora_flutter_quickstart/src/utils/api.dart';
import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'package:agora_flutter_quickstart/src/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m_loading/m_loading.dart';
import 'package:http_parser/http_parser.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final picker = ImagePicker();
  File _image;
  dynamic userInfo;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void _getCameraImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);

        uploadAvator();
      } else {
        print('No image selected.');
      }
    });
  }

  void _getGalleryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadAvator();
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void uploadAvator() async {
    var prefs = await SharedPreferences.getInstance();
    var name = _image.path
        .substring(_image.path.lastIndexOf('/') + 1, _image.path.length);

    var file = await MultipartFile.fromFile(_image.path, filename: name);
    print(file.contentType);
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _image.path,
        filename: name,
        contentType: MediaType('image', name.split('.').last),
      )
    });

    var res1 = await dio.post(
      '/avator',
      data: formData,
    );
    if (res1.data['code'] == 0) {
      showToast('????????????');
      var res2 = await dio.get(
        '/avator/update/' +
            prefs.getString('username') +
            '/' +
            prefs.getString('nickname'),
      );
      print(res2);
      if (res2.data['code'] == 0) {
        showToast('????????????');
      } else {
        showToast('????????????');
      }
      setState(() {});
    } else {
      showToast('???????????????????????????????????????');
    }
  }

  void _handleTap() {
    // ??????GestureDetector?????????
    // if (operateType == 'add' || operateType == 'Edit') {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => actionSheet(),
    ).then((value) {});
    // }
  }

  void letUserConfirm() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('??????'),
            content: Text('????????????????????????????'),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('??????'), //???????????????
              ),
              OutlinedButton(
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  await prefs.remove('nickname');
                  showToast('????????????');
                  Navigator.of(context).pop(true); //???????????????
                  setState(() {});
                },
                child: Text('??????'),
              ),
            ],
          );
        });
  }

  void logout() {}

  // ??????????????????actionSheet
  Widget actionSheet() {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () {
            // ??????????????????
            _getCameraImage();
            // ????????????
            Navigator.of(context).pop();
          },
          child: Text(
            '??????????????????',
            style: TextStyle(fontSize: 12.0, color: Colors.black),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            // ???????????????????????????
            _getGalleryImage();
            // ????????????
            Navigator.of(context).pop();
          },
          child: const Text(
            '???????????????????????????',
            style: TextStyle(fontSize: 12.0, color: Colors.black),
          ),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          // ????????????
          Navigator.of(context).pop();
        },
        child: Text(
          '??????',
          style: TextStyle(
            fontSize: 13.0,
            fontFamily: 'PingFangRegular',
            color: const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserInfo(),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Ring2InsideLoading(
              color: Colors.blue,
              duration: Duration(milliseconds: 1200),
              curve: Curves.bounceInOut,
            );
          }
          if (snapShot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('????????????'),
              ),
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/user_bgc.jpg'),
                        fit: BoxFit.cover)),
                padding: EdgeInsets.only(left: 20.0),
                child: Stack(
                  children: [
                    Positioned(
                      top: 70.0,
                      left: 20.0,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: _handleTap,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(snapShot.data['headerImg']),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text(
                              snapShot.data['nickName'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 120.0,
                        right: 40.0,
                        child: Column(
                          children: [
                            Text('???????????????' + snapShot.data['oralscore'])
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: Center(
                                child: SizedBox(
                              width: 200.0,
                              height: 40.0,
                              child: ElevatedButton(
                                onPressed: letUserConfirm,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(35))),
                                ),
                                child: Text('????????????',
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            )))
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('lib/assets/user_bgc.jpg'),
                      fit: BoxFit.cover)),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    })).then((value) {
                      setState(() {});
                    });
                  },
                  child: Text('????????????'),
                ),
              ),
            );
          }
        });
  }
}
