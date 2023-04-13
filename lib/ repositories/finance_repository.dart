import 'dart:developer';

import 'package:bitstack/services/api_service.dart';
import 'package:bitstack/services/db_service.dart';

import '../models/balance.dart';
import '../models/price.dart';

class FinanceRepository {
  final ApiService _apiService;
  final DBService _dbService;

  FinanceRepository(this._apiService, this._dbService);

  Stream<Price> getPrice() async* {
    try {
      Map<String, dynamic> dbPriceJson = await _dbService.getValue(DBKey.price);
      Price dbPrice = Price.fromJson(dbPriceJson);
      yield dbPrice;
    } catch (e) {
      log('Cannot get price from DB');
    }

    Price apiPrice = await _apiService.getPrice();
    _dbService.save(apiPrice.toJson(), DBKey.price);
    yield apiPrice;
  }

  Stream<Balance> getBalance() async* {
    try {
      Map<String, dynamic> dbBalanceJson =
          await _dbService.getValue(DBKey.balance);
      Balance dbBalance = Balance.fromJson(dbBalanceJson);
      yield dbBalance;
    } catch (e) {
      log('Cannot get price from DB');
    }

    Balance apiBalance = await _apiService.getBalance();
    _dbService.save(apiBalance.toJson(), DBKey.balance);
    yield apiBalance;
  }
}
