

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/common/bottomnavigatorbar/bottom_navigator_bar.dart';
import 'package:local_service_finder/view/authentication/form/chose_location.dart';


class SellerFormViewModel extends ChangeNotifier{

  bool _loading = false;

  bool get loading => _loading;

  loadingIndicator(bool value){
    _loading = value;
    notifyListeners();
  }

    sellerForm(
      BuildContext context,
      String phoneNumber,
      String cnicNumber,
      String selectService,
      String experience,
      String about,
      List<dynamic> daySchedule,
      List<dynamic> timeSchedule,
      )async{

    List<String> daysLabels = daySchedule.map((item) => item.label.toString()).toList();
    List<String> timesLabels = timeSchedule.map((item) => item.label.toString()).toList();

    Map<String,dynamic> sellerForm = {
      "profileImage" : "https://i.pinimg.com/474x/ad/73/1c/ad731cd0da0641bb16090f25778ef0fd.jpg",
      "phoneNumber" : phoneNumber,
      "cnicNumber" : cnicNumber,
      "selectService" : selectService,
      "experience" : experience,
      "about" : about,
      "daySchedule" : daysLabels,
      "timeSchedule" : timesLabels,
      "form" : true,
      "type" : "Seller",
    };
    try{
      loadingIndicator(true);
      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(sellerForm).then((value) {
        print('??>>>>>>>>>>/////////// Seller Form Data is saved go to bottom navigator .>>>>>>>>>>>>>>>>///////');
        Navigator.push(context,MaterialPageRoute(builder: (context) => ChoseLocationScreen()));
        loadingIndicator(false);
      }).onError((error, stackTrace) {
        loadingIndicator(false);
        print('>>>>>?????>>>>>> error while updating seller account data from seller from from SellerFormViewModel ${error}');
      });
      // await TFirebaseFireStoreHelper.userUpdate(sellerForm);
    }on FirebaseException catch(e){
      loadingIndicator(false);
      print('>>>>>?????>>>>>> error while updating user data fro seller from from SellerFormViewModel ${e.message}');
    }
  }

}