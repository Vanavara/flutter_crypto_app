import 'package:crypto_app/features/coins_list/models/crypto_coin.dart';
import 'package:crypto_app/features/coins_list/repositories/coins_repository.dart';
import 'package:flutter/material.dart';

class CoinsListScreen extends StatefulWidget {
  const CoinsListScreen({super.key});

  @override
  State<CoinsListScreen> createState() => _CoinsListScreenState();
}


class _CoinsListScreenState extends State<CoinsListScreen> {
  final _repository = CoinsRepository();
  List<CryptoCoin>? _coins;
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isHovering = false;


  String _selectedCurrency = 'USD';
  final List<String> _currencies = ['RUB', 'USD', 'EUR'];

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    setState(() {
      _isLoading = true;
      _isRefreshing = true;
    });

    try {
      final coins = await _repository.getCoinsList(_selectedCurrency);
      setState(() {
        _coins = coins;
      });
    } catch (e) {

    } finally {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Цена крипты'),
        actions: [
          DropdownButton<String> (
            value: _selectedCurrency,
            dropdownColor: Colors.grey[900],
            style: const TextStyle(color: Colors.white),
            items: _currencies.map((currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
            );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCurrency = value);
                _loadCoins();
              }
            },
          ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _coins?.length ?? 0, 
              separatorBuilder: (_, __) => const Divider(), 
              itemBuilder: (context, index) {
                final coin = _coins![index];
                return ListTile(
                  leading: coin.iconUrl != null
                      ? Image.network(
                          coin.iconUrl!,
                          width: 32,
                          height: 32,
                          errorBuilder: (_, __, ___) => 
                              const Icon(Icons.monetization_on),
                      )
                    : const Icon(Icons.monetization_on),
                  title: Text(coin.name),
                  subtitle: Text(
                        '${coin.price.toStringAsFixed(2)} $_selectedCurrency'),
                  );
                },
              ),


              floatingActionButton: MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true), 
                onExit: (_) => setState(() => _isHovering = false),
                child: FloatingActionButton(
                  backgroundColor: _isHovering
                      ? Colors.orangeAccent
                      : Theme.of(context).colorScheme.secondary,
                  tooltip: 'Обновить цены',
                  onPressed: _isRefreshing ? null : _loadCoins,
                  child: _isRefreshing
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                      : const Icon(Icons.refresh),
                  ),


              ),
            );
          }
        }


// class CoinsListScreen extends StatefulWidget{
//   const CoinsListScreen({super.key});

//   @override
//   State<CoinsListScreen> createState() => _CoinsListScreenState();
// }

// class _CoinsListScreenState extends State<CoinsListScreen> {
//   final _repository = CoinsRepository();
//   List<CryptoCoin>? _coins;
//   bool _isLoading = true;

//   String _selectedCurrency = 'USD';
//   final List<String> _currencies = ['USD', 'EUR', 'RUB'];

  // @override
  // void initState() {
  //     super.initState();
  //     _loadCoins();
  //   }

  //   Future<void> _loadCoins() async {
  //     setState(() => _isLoading = true);
  //     try {
  //       final coins = await _repository.getCoinsList(_selectedCurrency);
  //       setState(() {
  //         _coins = coins;
  //         _isLoading = false;
  //       });
  //     } catch (e) {
  //       setState(() => _isLoading = false); 
  //     }
  //   }

//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Crypto Prices'),
//           actions: [
//             DropdownButton<String>(
//               value: _selectedCurrency,
//               dropdownColor: Colors.grey[900],
//               style: const TextStyle(color: Colors.white),
//               items: _currencies.map((currency) {
//                 return DropdownMenuItem<String>(
//                   value: currency,
//                   child: Text(currency),
//               );
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() => _selectedCurrency = value);
//                   _loadCoins();
//                 }
//               },
//             ),
//           ],
//           ),
//         body: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.separated(
//               itemCount: _coins?.length ?? 0,
//               separatorBuilder: (context, index) => const Divider(),
//               itemBuilder: (context, index) {
//                 final coin = _coins![index];
//                 return ListTile(
//                   leading: coin.iconUrl != null
//                       ? Image.network(
//                         coin.iconUrl!,
//                         width: 32,
//                         height: 32,
//                         errorBuilder: (_, __, ___) => const Icon(Icons.monetization_on),
//                       )
//                       : const Icon(Icons.monetization_on),
//                   title: Text(coin.name),
//                   subtitle: Text('${coin.price.toStringAsFixed(2)} $_selectedCurrency'),
//                   // onTap: () {
//                   //   Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //       builder: (_) => CointDetailsScreen(coin:coin),
//                   //     ),
//                   //   );
//                   // },
//                 );
//               },
//             ),
//       );
//     }
//   }
