import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum DBKey { price, balance }

abstract class DBService {
  save(Map map, DBKey key);
  Future<Map<String, dynamic>> getValue(DBKey key);
}

class DBServiceImpl implements DBService {
  static late SharedPreferences _sharedPrefs;

  static final DBServiceImpl _instance = DBServiceImpl._internal();

  factory DBServiceImpl() => _instance;

  DBServiceImpl._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  @override
  save(Map map, DBKey key) async {
    String mapString = json.encode(map);
    _sharedPrefs.setString(key.toString(), mapString);
  }

  @override
  Future<Map<String, dynamic>> getValue(DBKey key) async {
    String? mapString = _sharedPrefs.getString(key.toString());
    if (mapString != null) return json.decode(mapString);
    return {};
  }
}
