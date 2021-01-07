import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  save(String key, String key2, double lat, double lon) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, lat);
    prefs.setDouble(key2, lon);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}