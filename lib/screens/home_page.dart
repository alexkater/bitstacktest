import 'package:bitstack/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: Color(0x00e5e5e5)),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 107),
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is BalanceLoading) {
                      return loadingView();
                    } else if (state is BalanceLoaded) {
                      return loadedView(state);
                    } else if (state is BalanceError) {
                      return errorView(context, state);
                    } else {
                      return defaultErrorView();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget defaultErrorView() {
    return const Center(
      child: Text(
        'Unknown error',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget errorView(BuildContext context, BalanceError state) {
    return Center(
      child: Column(
        children: [
          const Image(image: AssetImage('assets/images/bitcoin_error.jpg')),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(16),
            child: Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              context.read<HomeBloc>().add(FetchData());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget loadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget loadedView(BalanceLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        balanceView(state),
        priceView(state),
      ],
    );
  }

  Widget balanceView(BalanceLoaded state) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: boxDecoration(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.balance,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            state.balanceConverted ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget priceView(BalanceLoaded state) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(9.5),
      decoration: boxDecoration(190),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: const BoxDecoration(
                // border: Border.all(color: const Color(0x00dbe0f2)),
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Color.fromARGB(255, 255, 137, 52),
              ),
              child: const Text(
                "BITCOIN",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              )),
          if (state.price != null)
            Text(
              state.price ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          if (state.price == null) loadingView()
        ],
      ),
    );
  }

  BoxDecoration boxDecoration(double radius) {
    return BoxDecoration(
      // border: Border.all(color: const Color(0x00dbe0f2)),
      border: Border.all(color: Colors.blueGrey.shade200),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(35, 36, 46, 0.07),
          spreadRadius: 0,
          blurRadius: 34,
          offset: Offset(0, 0), // changes position of shadow
        ),
      ],
    );
  }
}
