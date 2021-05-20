import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController repeatPassword = TextEditingController();
  TextEditingController invitationCode = TextEditingController();
  TextEditingController yasiScore = TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  void Register() async {
    print('haluo');
    try {
      var res = await Dio().post('https://sleepdevil.top/invite/register',
          data: {
            "Username": "SleepDevil",
            "Password": password.text,
            "Nickname": "我不是睡魔"
          });
      print(res);
    } catch (e) {
      print(e);
    }
  }

  void register() {
    // if (password.text != repeatPassword.text) {
    //   showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (context) {
    //         return AlertDialog(
    //           title: Text('提示'),
    //           content: Text('两次密码不一致，请重新输入'),
    //           actions: <Widget>[
    //             TextButton(
    //               child: Text("确定"),
    //               onPressed: () => Navigator.of(context).pop(), //关闭对话框
    //             ),
    //           ],
    //         );
    //       });
    // }
    // if ((_formKey.currentState as FormState).validate()) {
    //   Register();
    // }
    // print(password.value);
    // print(repeatPassword.value);
    // print(invitationCode.value);
    Register();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => Scaffold(
          appBar: AppBar(
            title: Text('用户注册'),
          ),
          body: Container(
              padding: EdgeInsets.only(top: 30, right: 20),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(100),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text("用户名",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: nickname,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: "用户名长度为4-12个字符",
                            ),
                            validator: (value) {
                              if (value.length < 4 || value.length > 12) {
                                return '用户名长度为4-12个字符';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(100),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text("账号",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: username,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: "请输入账号",
                            ),
                            validator: (value) {
                              if (value.length == 0) {
                                return '账号不能为空';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(100),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text("密码",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: password,
                            keyboardType: TextInputType.name,
                            decoration:
                                const InputDecoration(hintText: '请输入密码'),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '用户名长度为4-12个字符';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(100),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text("确认密码",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: repeatPassword,
                            keyboardType: TextInputType.name,
                            decoration:
                                const InputDecoration(hintText: '请确认密码'),
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '请确认密码';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(100),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text("成绩",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: yasiScore,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                                hintText: '雅思口语考试最高成绩未参加过填0'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return '请输入您的口语成绩';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(100),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text("邀请码",
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: invitationCode,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: "请输入您的邀请码",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return '请输入您的邀请码';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Center(
                        child: Text.rich(
                          TextSpan(text: '我已阅读并同意', children: [
                            TextSpan(
                                text: '用户隐私协议',
                                style: TextStyle(
                                  color: Color(0xFF00CED2),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('用户协议和隐私政策'),
                                            content:
                                                Text('sasasahjsahjiasjhsah'),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                          );
                                        });
                                  })
                          ]),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text('注册'),
                      onPressed: Register,
                    ),
                  ),
                ]),
              ))),
    );
  }
}
