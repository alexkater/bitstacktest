extension CurrencyFormatting on double {
  String get bitcoinFormatted => '${toString()}₿';
  String get usdFormatted => '\$${toStringAsFixed(2)}';
}
