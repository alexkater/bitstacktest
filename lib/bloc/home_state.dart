abstract class HomeState {}

class BalanceLoading extends HomeState {}

class BalanceLoaded extends HomeState {
  final String balance;
  final String? balanceConverted;
  final String? price;

  BalanceLoaded({
    required this.balance,
    this.balanceConverted,
    this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceLoaded &&
          runtimeType == other.runtimeType &&
          balance == other.balance &&
          balanceConverted == other.balanceConverted &&
          price == other.price;

  @override
  int get hashCode =>
      balance.hashCode ^ balanceConverted.hashCode ^ price.hashCode;

  @override
  String toString() =>
      'BalanceLoaded { balance: $balance, balanceConverted: $balanceConverted, price: $price }';
}

class BalanceError extends HomeState {
  final String errorMessage;

  BalanceError({required this.errorMessage});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceError &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;

  @override
  String toString() => 'BalanceError { errorMessage: $errorMessage }';
}
