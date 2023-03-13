import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin SharedPreferenceUtil {

  static const String module_setting_source = "moduleSettingSource#";
  static const String module_setting_target = "moduleSettingTarget#";


  Future<bool> saveSharedString(String key, String data) async {
    try {
      var shared = await SharedPreferences.getInstance();
      var res = await shared.setString(key, data);
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<String> getSharedString(String key) async {
    try {
      var shared = await SharedPreferences.getInstance();
      var res = shared.getString(key);
      return res ?? "";
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }
}
