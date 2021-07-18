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
  bool isEye = true;

  void login() async {
    print('-----------------');
    // ignore: unnecessary_cast
    if ((_loginFormKey.currentState as FormState).validate()) {
      var success = await dio.post('/login',
          data: {'Username': username.text, 'Password': password.text});
      print(success);
      // print(success.data['code']);
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
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assets/login_bgc.jpg'),
                fit: BoxFit.cover)),
        padding: EdgeInsets.all(40.0),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 140.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: TextFormField(
                          controller: username,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: '请输入账号',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 21,
                                  color: Color(0xff666666),
                                ),
                                onPressed: () {
                                  setState(() {
                                    username.text = '';
                                  });
                                },
                              )),
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: TextFormField(
                        controller: password,
                        obscureText: isEye,
                        decoration: InputDecoration(
                            hintText: '请输入密码',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                size: 21,
                                color: Color(0xff666666),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEye = !isEye;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0))),
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
                margin: EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35))),
                    ),
                    child: Text('登录', style: TextStyle(fontSize: 18.0)),
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
