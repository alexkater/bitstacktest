import 'package:bitstack/bloc/home_bloc.dart';
import 'package:bitstack/bloc/home_event.dart';
import 'package:bitstack/bloc/home_state.dart';
import 'package:bitstack/extensions/double_extensions.dart';
import 'package:bitstack/models/balance.dart';
import 'package:bitstack/models/price.dart';
import 'package:bitstack/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ApiService])
import 'balance_bloc_test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late HomeBloc homeBloc;

  setUp(() {
    mockApiService = MockApiService();
    homeBloc = HomeBloc(mockApiService);
  });

  group('Balance bloc', () {
    test('Fetch data succeed', () {
      final balance = Balance(1, "BTC");
      final price = Price(1, "USD");

      when(mockApiService.getBalance())
          .thenAnswer((realInvocation) async => balance);
      when(mockApiService.getPrice())
          .thenAnswer((realInvocation) async => price);

      homeBloc.add(FetchData());

      expect(
          homeBloc.stream,
          emitsInAnyOrder([
            isA<BalanceLoading>(),
            predicate<BalanceLoaded>((value) {
              expect(value,
                  BalanceLoaded(balance: balance.balance.bitcoinFormatted));
              return true;
            }),
            predicate<BalanceLoaded>((value) {
              expect(
                  value,
                  BalanceLoaded(
                      balance: balance.balance.bitcoinFormatted,
                      balanceConverted:
                          (balance.balance * price.price).usdFormatted,
                      price: price.price.usdFormatted));
              return true;
            }),
          ]));
    });

    test('Fetch get balance succeed and price failed', () {
      final balance = Balance(1, "BTC");

      when(mockApiService.getBalance())
          .thenAnswer((realInvocation) async => balance);
      when(mockApiService.getPrice())
          .thenThrow(Exception('Something went wrong'));

      homeBloc.add(FetchData());

      expect(
          homeBloc.stream,
          emitsInAnyOrder([
            isA<BalanceLoading>(),
            predicate<BalanceLoaded>((value) {
              expect(value,
                  BalanceLoaded(balance: balance.balance.bitcoinFormatted));
              return true;
            }),
            isA<BalanceError>(),
          ]));
    });

    test('Fetch get balance failed', () {
      when(mockApiService.getBalance())
          .thenThrow(Exception('Something went wrong'));

      homeBloc.add(FetchData());

      expect(homeBloc.stream,
          emitsInAnyOrder([isA<BalanceLoading>(), isA<BalanceError>()]));
    });

    test('Fetch data succeed and reload update price', () {
      final balance = Balance(1, "BTC");
      final price1 = Price(1, "USD");
      final price2 = Price(2, "USD");

      var prices = [price1, price2];

      when(mockApiService.getBalance())
          .thenAnswer((realInvocation) async => balance);
      when(mockApiService.getPrice())
          .thenAnswer((realInvocation) async => prices.removeAt(0));

      homeBloc.add(FetchData());

      expect(
          homeBloc.stream,
          emitsInAnyOrder([
            isA<BalanceLoading>(),
            predicate<BalanceLoaded>((value) {
              expect(value,
                  BalanceLoaded(balance: balance.balance.bitcoinFormatted));
              return true;
            }),
            predicate<BalanceLoaded>((value) {
              expect(
                  value,
                  BalanceLoaded(
                      balance: balance.balance.bitcoinFormatted,
                      balanceConverted:
                          (balance.balance * price1.price).usdFormatted,
                      price: price1.price.usdFormatted));
              return true;
            }),
            predicate<BalanceLoaded>((value) {
              expect(
                  value,
                  BalanceLoaded(
                      balance: balance.balance.bitcoinFormatted,
                      balanceConverted:
                          (balance.balance * price2.price).usdFormatted,
                      price: price2.price.usdFormatted));
              return true;
            }),
          ]));
    });
  });
}
