import 'package:flutter/material.dart';

class ShopMasterScreen extends StatefulWidget {
  const ShopMasterScreen({super.key});

  @override
  State<ShopMasterScreen> createState() => _ShopMasterScreenState();
}

class _ShopMasterScreenState extends State<ShopMasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Master'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
        
      ),
      body: const Center(
        child: Text(
          'Shop Master Screen - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} 