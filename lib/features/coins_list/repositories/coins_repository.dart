import 'package:crypto_app/features/coins_list/models/crypto_coin.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class CoinsRepository{
  Future<List<CryptoCoin>> getCoinsList(String currency) async {
    try {
      final pricesUrl = '${dotenv.env['CRYPTO_API_URL']}$currency';
      final iconsUrl = dotenv.env['COIN_LIST_URL'];
      final iconBaseUrl = dotenv.env['ICON_BASE_URL'];

      final pricesResponse = await Dio().get(pricesUrl);
      final iconsResponse = await Dio().get(iconsUrl!);


      final pricesData = pricesResponse.data as Map<String, dynamic>;
      final iconsData = iconsResponse.data['Data'] as Map<String, dynamic>;


      return pricesData.entries.map((entry) {
        final coinName = entry.key;
        final price = (entry.value as Map<String, dynamic>)[currency];
        final iconData = iconsData[coinName];
        final iconPath = iconsData[coinName]?['ImageUrl'];
        final iconUrl = iconPath != null ? '$iconBaseUrl$iconPath' : null;
        final symbol = iconData?['Symbol'] ?? '';

        return CryptoCoin(
          name: coinName, 
          price: price.toDouble(),
          iconUrl: iconUrl,
          symbol: symbol,
          );
      }).toList();
    } catch (e) {
    rethrow;
    }
  }
}
