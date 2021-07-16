import 'package:agora_flutter_quickstart/src/utils/dio.dart';
import 'package:agora_flutter_quickstart/src/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Object> getUserInfo() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.getString('token') == null) {
    showToast('请先登录');
    return null;
  }
  var res =
      await dio.post('/checktoken', data: {'token': prefs.getString('token')});
  await prefs.setString('nickname', res.data['data']['nickName']);
  await prefs.setString(
      'username', res.data['data']['userName']); // username为账号
  await prefs.setString('headerimg', res.data['data']['headerImg']);
  await prefs.setString('oralscore', res.data['data']['oralscore']);
  var userInfo = res.data['data'];
  return userInfo;
}

Future<String> getUserIdentity(String username) async {
  var res = await dio.post('/getidentity', data: {'username': username});
  return res.data['data'];
}

Future<List> getQuestions(String topic_id) async {
  var res = await dio.post('/getquestions', data: {'topicId': topic_id});
  return res.data['data'];
}

Future<String> getTopic(String part) async {
  var res = await dio.post('/gettopic', data: {'part': part});
  return res.data['data']['topicName'];
}
