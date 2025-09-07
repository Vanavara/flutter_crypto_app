class CryptoCoin{
  final String name;
  final double price;
  final String? iconUrl;
  final String symbol;

  CryptoCoin({
    required this.name,
    required this.price,
    this.iconUrl,
    required this.symbol,
  });
}