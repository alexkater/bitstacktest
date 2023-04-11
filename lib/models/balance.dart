import 'package:equatable/equatable.dart';

class Balance extends Equatable {
  late double balance;
  late String currency;
  DateTime dateTime = DateTime.now();

  @override
  List<Object> get props => [balance, currency, dateTime];

  Balance(this.balance, this.currency);

  Balance.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['currency'] = currency;
    return data;
  }
}
