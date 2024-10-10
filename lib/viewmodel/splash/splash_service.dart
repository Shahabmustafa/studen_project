import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/common/bottomnavigatorbar/bottom_navigator_bar.dart';
import 'package:local_service_finder/view/authentication/form/seller_form_screen.dart';
import 'package:local_service_finder/view/authentication/login/login_view.dart';
import 'package:local_service_finder/view/customer/drawer/home/map.dart';

class SplashService{

  void checkUserType(BuildContext context) async {

    if (FirebaseAuth.instance.currentUser == null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()),);
      });
    } else {
      // User is signed in, fetch user type
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        String userType = userDoc['type'];
        bool userForm = userDoc['form'];
        if (userType == 'Seller') {
         Timer(const Duration(seconds: 3), () {
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => userForm ? const BottomNavigatorBarScreen() : const SellerFormScreen()),
           );
         });
        } else if(userType == "Customer"){
          Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MapScreen()),
            );
          });
        }
      } else {
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()),);
        });
      }
    }
  }
}