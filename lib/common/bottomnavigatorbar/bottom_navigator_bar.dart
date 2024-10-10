import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/view/seller/bottomnavogatorbar/chat/chat_users_list_screen.dart';
import 'package:local_service_finder/view/seller/bottomnavogatorbar/profile/profile_screen.dart';

import '../../view/customer/drawer/notifiction/customer_notification_screen.dart';
import '../../view/seller/bottomnavogatorbar/home/home_screen.dart';

class BottomNavigatorBarScreen extends StatefulWidget {
  final int initialIndex;
  final String? appotimentId;
  const BottomNavigatorBarScreen({super.key, this.initialIndex = 0,this.appotimentId});
  @override
  State<BottomNavigatorBarScreen> createState() => _BottomNavigatorBarScreenState();
}

class _BottomNavigatorBarScreenState extends State<BottomNavigatorBarScreen> {


  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUnreadNotificationCount();
  }

  int unreadCount = 0;

  // Fetch the unread appointment count from Firestore
  void _getUnreadNotificationCount() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('appotiment')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        unreadCount = snapshot.docs.length;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomeScreen(appotimentId: widget.appotimentId,initialIndex: widget.initialIndex,),
          const ChatUsersListScreen(),
          const NotificationScreen(),
          const ProfileScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          selectedIndex = index;
          setState(() {

          });
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,

        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.chat),label: 'Chat'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Notification',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'Profile'),
        ],
      ),
    );
  }
}
