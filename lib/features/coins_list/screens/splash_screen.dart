import 'dart:async';
import 'package:crypto_app/features/coins_list/repositories/coins_repository.dart';
import 'package:crypto_app/features/coins_list/screens/coins_list_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
  with SingleTickerProviderStateMixin{
    late AnimationController _controller;
    late Animation<double> _animation;

    @override
    void initState() {
      super.initState();

      _controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      )..repeat(reverse: true);

      _animation = Tween<double>(begin: 0.9, end: 1.2). animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _loadAndNavigate();
    }

    Future<void> _loadAndNavigate() async{
      final repository = CoinsRepository();
      final coins = await repository.getCoinsList("USD");

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => CoinsListScreen(),
            ),
        );
      }
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset('assets/images/bitcoin.png', width: 500),
            ),
          ),
      );
    }
  }