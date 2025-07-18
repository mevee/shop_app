import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:shop_app/modules/schedule/controller/schedule_controller.dart';

class ShopMasterScreen extends GetView<ScheduleController> {
  const ShopMasterScreen({super.key});

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