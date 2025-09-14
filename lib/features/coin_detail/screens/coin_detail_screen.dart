import 'package:flutter/material.dart';
import 'package:crypto_app/features/coins_list/models/crypto_coin.dart';

class CoinDetailScreen extends StatelessWidget {
  final CryptoCoin coin;
  final String currency;

  const CoinDetailScreen({
    super.key, 
    required this.coin,
    required this.currency,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            coin.iconUrl != null
                ? Image.network(
                    coin.iconUrl!,
                    width: 64,
                    height: 64,
                  )
                : const Icon(Icons.monetization_on, size: 64),
            const SizedBox(height: 16),
            Text(
              coin.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Цена: ${coin.price.toStringAsFixed(2)} $currency',
              style: const TextStyle(fontSize: 20),
            ),
            if (coin.symbol.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Символ: ${coin.symbol.toUpperCase()}'),
            ],
          ],
        ),
      ),
    );
  }
}
