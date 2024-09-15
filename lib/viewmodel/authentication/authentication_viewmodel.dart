import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/common/bottomnavigatorbar/bottom_navigator_bar.dart';
import 'package:local_service_finder/utils/helper/helper.dart';
import 'package:local_service_finder/utils/helper/local_helper.dart';
import 'package:local_service_finder/view/authentication/form/seller_form_screen.dart';
import 'package:local_service_finder/view/customer/drawer/home/map.dart';
import 'package:local_service_finder/viewmodel/user/user_viewmodel.dart';

class AuthenticationViewModel extends ChangeNotifier{

  bool _loading = false;

  bool get loading => _loading;

  loadingIndicator(bool value){
    _loading = value;
    notifyListeners();
  }

  loginAuth(BuildContext context,String email,String password)async{
    loadingIndicator(true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) async {
        loadingIndicator(false);

        String token = await TLocalHelper.token();

        FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          "token" : token,
        });

        /// checking user form
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (userDoc.exists) {
          String userType = userDoc['type'];
          bool userForm = userDoc['form'];
          print(">>>>>>><<><><><type>>>>>>>>>>${userType}");
          print(
              ">>>>>>><<><><><type>>>>>>>>>>${userDoc["userName"].toString()}");
          userType == "Seller" ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>
            userForm
                ? BottomNavigatorBarScreen()
                : SellerFormScreen()),
                (Route<dynamic> route) => false,
          ) :  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MapScreen()),
                (Route<dynamic> route) => false,
          );
        }
      });
    }catch(e){
      THelper.errorMessage(context, e.toString());
      loadingIndicator(false);
    }
  }

  signUpAuth(BuildContext context,String userName,String email,String password,String type,String location)async{
    try{
      loadingIndicator(true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value){
        UserViewModel().addUserData(
          context,
          value.user!.uid,
          userName,
          email,
          type,
          location
        );
        type = "";
        location = "";
        loadingIndicator(false);
      });
      loadingIndicator(false);
    }on FirebaseException catch(e){
      THelper.errorMessage(context, e.toString());
      loadingIndicator(false);
    }
  }

  forgetPasswordAuth(BuildContext context,String email)async{
    try{
      loadingIndicator(true);
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      loadingIndicator(false);
      THelper.successMessage(context, "Please Check Gmail Send a Recover Password Link");
    }on FirebaseException catch(e){
      THelper.errorMessage(context, e.toString());
      loadingIndicator(false);
    }
  }

  passwordChange(context,String changePassword)async{
    try{
      loadingIndicator(true);
      await FirebaseAuth.instance.currentUser?.updatePassword(changePassword).then((value){
        THelper.successMessage(context, "Update Password");
        Navigator.pop(context);
      });
    }catch(e){
      THelper.errorMessage(context, e.toString());
      print(e.toString());
    }
  }
}