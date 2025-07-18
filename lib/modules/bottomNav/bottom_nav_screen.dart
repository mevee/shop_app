import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app/modules/bottomNav/controller/bottom_nav_controller.dart';
import 'package:shop_app/modules/calendar/calendar_screen.dart';
import 'package:shop_app/modules/home/home_screen.dart';
import 'package:shop_app/modules/shop_master/shop_master_screen.dart';
// import 'package:shop_app/screens/schedule/schedule_screen.dart';

class BottomNavScreen extends GetView<BotomNavController> {
  BottomNavScreen({super.key});

  final List<Widget> _screens = [
    const HomeScreen(),
    const CalendarScreen(),
    // const ScheduleScreen(),
    const ShopMasterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _screens[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.currentIndex.value = index;
            controller.currentIndex.refresh();
          },
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.schedule),
            //   label: 'Schedule',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Shop Master',
            ),
          ],
        ),
      ),
    );
  }
}
