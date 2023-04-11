import 'package:bitstack/screens/home_page.dart';
import 'package:bitstack/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'bloc/home_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: BlocProvider(
        create: (context) =>
            HomeBloc(ApiService(http.Client())), // ..add(FetchData()),
        child: const HomePage(),
      ),
    );
  }
}
