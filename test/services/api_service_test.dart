import 'package:bitstack/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  group('Api Service', () {
    test('getPrice returns parsed JSON response', () async {
      final mockClient = MockClient((request) async =>
          http.Response('{"price": 27947.0, "currency": "USD"}', 200));
      final service = ApiService(mockClient);

      final response = await service.getPrice();
      expect(response.price, equals(27947.0));
      expect(response.currency, equals('USD'));
    });

    test('getBalance returns parsed JSON response', () async {
      final mockClient = MockClient((request) async =>
          http.Response('{ "balance": 0.05555555, "currency": "BTC" }', 200));
      final service = ApiService(mockClient);

      final response = await service.getBalance();
      expect(response.balance, equals(0.05555555));
      expect(response.currency, equals('BTC'));
    });
  });
}
