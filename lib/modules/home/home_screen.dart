import 'package:flutter/material.dart';
import 'package:shop_app/modules/home/home_dashboard.dart';
import 'package:shop_app/screens/calendar/calendar_screen.dart';
import 'package:shop_app/screens/schedule/schedule_screen.dart';
import 'package:shop_app/screens/shop_master/shop_master_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboard(),
    const CalendarScreen(),
    const ScheduleScreen(),
    const ShopMasterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Shop Master',
          ),
        ],
      ),
    );
  }
}
