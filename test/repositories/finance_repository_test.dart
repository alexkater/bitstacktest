import 'package:bitstack/models/balance.dart';
import 'package:bitstack/models/price.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:bitstack/%20repositories/finance_repository.dart';
import 'package:bitstack/services/api_service.dart';
import 'package:bitstack/services/db_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ApiService, DBService])
import 'finance_repository_test.mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late MockApiService mockApiService;
  late MockDBService mockDBService;
  late FinanceRepository financeRepository;

  group('Finance repository', () {
    setUp(() {
      mockApiService = MockApiService();
      mockDBService = MockDBService();
      financeRepository = FinanceRepository(mockApiService, mockDBService);
    });

    test('get price without cache', () async {
      final price = Price(1, "USD");
      when(mockDBService.getValue(DBKey.price)).thenAnswer((_) async => {});

      when(mockApiService.getPrice()).thenAnswer((_) async => price);

      expect(financeRepository.getPrice(), emitsInOrder([price, emitsDone]));
    });

    test('get price with cache', () async {
      final price1 = Price(1, "USD");
      final price2 = Price(2, "USD");
      when(mockDBService.getValue(DBKey.price))
          .thenAnswer((_) async => price1.toJson());

      when(mockApiService.getPrice()).thenAnswer((_) async => price2);

      expect(
          financeRepository.getPrice(),
          emitsInOrder([
            predicate<Price>((value) {
              expect(value.price, 1);
              expect(value.currency, "USD");
              return true;
            }),
            price2,
            emitsDone
          ]));
    });

    test('get balance without cache', () async {
      final balance = Balance(1, "USD");
      when(mockDBService.getValue(DBKey.balance)).thenAnswer((_) async => {});

      when(mockApiService.getBalance()).thenAnswer((_) async => balance);

      expect(
          financeRepository.getBalance(), emitsInOrder([balance, emitsDone]));
    });

    test('get balance with cache', () async {
      final balance1 = Balance(1, "USD");
      final balance2 = Balance(2, "USD");
      when(mockDBService.getValue(DBKey.balance))
          .thenAnswer((_) async => balance1.toJson());

      when(mockApiService.getBalance()).thenAnswer((_) async => balance2);

      expect(
          financeRepository.getBalance(),
          emitsInOrder([
            predicate<Balance>((value) {
              expect(value.balance, 1);
              expect(value.currency, "USD");
              return true;
            }),
            balance2,
            emitsDone
          ]));
    });
  });
}
