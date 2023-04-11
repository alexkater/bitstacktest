import 'package:bitstack/extensions/double_extensions.dart';
import 'package:bitstack/services/api_service.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._apiService) : super(BalanceLoading()) {
    on<FetchData>((event, emit) => _onFetchData(emit));
    on<ReloadData>((event, emit) => _onReloadData(emit));
  }

  final ApiService _apiService;

  Future<void> _onFetchData(Emitter<HomeState> emit) async {
    emit(BalanceLoading());
    double? balance;
    try {
      final balanceResponse = await _apiService.getBalance();
      balance = balanceResponse.balance;

      emit(BalanceLoaded(balance: balance.bitcoinFormatted));

      final priceResponse = await _apiService.getPrice();

      final price = priceResponse.price;

      final balanceConverted = (balance * price).usdFormatted;
      emit(BalanceLoaded(
          balance: balance.bitcoinFormatted,
          balanceConverted: balanceConverted,
          price: price.usdFormatted));
      _reloadData();
    } catch (e) {
      emit(BalanceError(errorMessage: e.toString()));
    }
  }

  Future<void> _onReloadData(Emitter<HomeState> emit) async {
    try {
      final balanceResponse = await _apiService.getBalance();
      final balance = balanceResponse.balance;

      final priceResponse = await _apiService.getPrice();
      final price = priceResponse.price;
      final balanceConverted = (balance * price).usdFormatted;

      emit(BalanceLoaded(
          balance: balance.bitcoinFormatted,
          balanceConverted: balanceConverted,
          price: price.usdFormatted));

      _reloadData();
    } catch (e) {
      _reloadData();
    }
  }

  Future _reloadData() {
    return Future.delayed(const Duration(seconds: 1), () {
      add(ReloadData());
    });
  }
}
