// 提供五套可选主题色
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';
import 'Network.dart';

const _themes = <MaterialColor>[
  Colors.lightBlue,
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.lightGreen,
  Colors.green,
  Colors.red,
  Colors.yellow
];

class Global {
  static late SharedPreferences _prefs;
  static Profile profile = Profile();

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();

    // _prefs.remove("profile");

    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    } else {
      // 默认主题索引为0，代表蓝色
      profile = Profile()..theme = 0;
    }

    //初始化网络请求相关配置
    Network.init();
  }

  // 持久化Profile信息
  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));
}
