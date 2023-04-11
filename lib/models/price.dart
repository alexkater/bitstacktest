import 'package:equatable/equatable.dart';

class Price extends Equatable {
  late double price;
  late String currency;
  DateTime dateTime = DateTime.now();

  @override
  List<Object> get props => [price, currency, dateTime];

  Price(this.price, this.currency);

  Price.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['currency'] = currency;
    return data;
  }
}
