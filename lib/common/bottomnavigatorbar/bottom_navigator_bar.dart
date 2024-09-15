import 'package:flutter/material.dart';
import 'package:local_service_finder/view/seller/bottomnavogatorbar/chat/chat_users_list_screen.dart';
import 'package:local_service_finder/view/seller/bottomnavogatorbar/profile/profile_screen.dart';
import '../../view/customer/drawer/notifiction/customer_notification_screen.dart';
import '../../view/seller/bottomnavogatorbar/home/home_screen.dart';

class BottomNavigatorBarScreen extends StatefulWidget {
  const BottomNavigatorBarScreen({super.key});

  @override
  State<BottomNavigatorBarScreen> createState() => _BottomNavigatorBarScreenState();
}

class _BottomNavigatorBarScreenState extends State<BottomNavigatorBarScreen> {

  final List screens = [
    HomeScreen(),
    ChatUsersListScreen(),
    NotificationScreen(),
    ProfileScreen()
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          selectedIndex = index;
          setState(() {

          });
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat),label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications),label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'Profile'),
        ],
      ),
    );
  }
}
