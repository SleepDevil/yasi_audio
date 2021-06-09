import 'package:agora_flutter_quickstart/src/pages/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/dio.dart';
import '../utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  void login() async {
    print('-----------------');
    if ((_loginFormKey.currentState as FormState).validate()) {
      var success = await dio.post('/login',
          data: {'Username': username.text, 'Password': password.text});
      print('---------------');
      print('执行了');
      print(success.data['code']);
      if (success.data['code'] == 7) {
        showToast('登录失败');
      }
      if (success.data['code'] == 0) {
        var token = success.data['data']['token'];
        showToast('登录成功');
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        Navigator.pop(context, '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 120.0),
          child: Container(
            padding: EdgeInsets.only(top: 30, right: 20),
            child: Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text('用户名',
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
                              hintText: '请输入账号',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
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
                        width: 100,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Center(
                            child: Text('密码',
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
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: '请输入密码',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return '密码不能为空';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text.rich(TextSpan(text: '暂无账号？', children: [
                      TextSpan(
                          text: '立即注册',
                          style: TextStyle(color: Color(0xFF00CED2)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RegisterPage();
                              }));
                            })
                    ])),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: login,
                      child: Text('登录'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
