class CryptoCoin{
  final String name;
  final double price;
  final String? iconUrl;

  CryptoCoin({
    required this.name,
    required this.price,
    this.iconUrl,
  });
}