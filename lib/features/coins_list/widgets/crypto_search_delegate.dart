import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/features/coins_list/models/crypto_coin.dart';
import 'package:crypto_app/features/coin_detail/screens/coin_detail_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CryptoSearchDelegate extends SearchDelegate {
  final List<CryptoCoin> coins;
  final String currency;

  CryptoSearchDelegate(this.coins, this.currency);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: Dio().get(
        dotenv.env['CRYPTO_API_URL_EMPTY']!,
        queryParameters: {
          'fsym': query.toUpperCase(),
          'tsyms': currency.toUpperCase(),
        },
      ), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data?.data == null) {
          return const Center(child: Text('Монета не найден, попробуйте использовать другую аббревиатуру.'));
        }
        final priceRaw = snapshot.data!.data[currency.toUpperCase()];

        if (priceRaw == null) {
          return Center(child: Text('Цена для указанной Вами валюты "$query" недоступна.'));

        }
        final coin = CryptoCoin(
          name: query.toUpperCase(), 
          price: priceRaw.toDouble(),
          symbol: query.toUpperCase(), 
          iconUrl: null,
          );

        return CoinDetailScreen(
          coin: coin,
          currency: currency,
          );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = coins
        .where((coin) =>
            coin.symbol.toLowerCase().contains(query.toLowerCase()) ||
            coin.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final coin = suggestions[index];
        return ListTile(
          leading: coin.iconUrl != null
              ? Image.network(coin.iconUrl!, width: 32, height: 32)
              : const Icon(Icons.monetization_on),
          title: Text(coin.name),
          subtitle: Text(coin.symbol),
          onTap: () {
            query = coin.symbol;
            showResults(context);
          },
        );
      },
    );
  }
}
