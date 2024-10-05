import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference {
  static MySharedPreference? _sharedPreferenceInst;

  static setBool(String key, bool value) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool(key, value);
  }

  static getBool(String key) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    return s.getBool(key);
  }

  static MySharedPreference? getinst() {
    if (_sharedPreferenceInst == null) {
      _sharedPreferenceInst = MySharedPreference();
    }

    return _sharedPreferenceInst;
  }
}
