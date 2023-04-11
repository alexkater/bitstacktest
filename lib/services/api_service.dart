import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bitstack/models/balance.dart';
import 'package:bitstack/models/price.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class ApiService {
  final http.Client client;

  final String _baseUrl = 'https://coding-challenge-m237lr2nza-ew.a.run.app';

  ApiService(this.client);

  // I can assume that this data will come for each user and it
  // should be saved in the keychain/keystore
  // on the other side, assuming this is saved in the app code
  // we can use a environment file and load it in the app,
  //this file should not be added to Git never.
  Map<String, String> get headers => {
        "API_KEY": "b76f08a4-ed71-4605-a18e-b3f2fcdd7b91",
      };

  Future<Price> getPrice() async {
    final response = await retry(
      // Make a GET request
      () => client
          .get(Uri.parse('$_baseUrl/price'), headers: headers)
          .timeout(const Duration(seconds: 2)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (response.statusCode == 200) {
      return Price.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get price');
    }
  }

  Future<Balance> getBalance() async {
    final response = await retry(
      // Make a GET request
      () => client
          .get(Uri.parse('$_baseUrl/balance'), headers: headers)
          .timeout(const Duration(milliseconds: 60)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (response.statusCode == 200) {
      return Balance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get balance');
    }
  }
}
