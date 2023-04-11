import 'package:bitstack/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('DB service', () {
    test('Save and get working properly', () async {
      SharedPreferences.setMockInitialValues({});
      await DBServiceImpl().init();

      const map = {"key": "value"};
      DBServiceImpl().save(map, DBKey.balance);
      var expectedValue = await DBServiceImpl().getValue(DBKey.balance);

      expect(expectedValue, map);
    });
  });
}
