import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:local_service_finder/utils/api/firebase/firebase_api.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:local_service_finder/utils/helper/helper.dart';

class AppotimentViewModel {

  final _auth = FirebaseAuth.instance;

  /// place appotiment
  void placeAppotiment(
      BuildContext context,
      DateTime appotimentDate,
      appotimentMessage,
      appotimentReciverId,
      ) async {
    try {
      /// first save in seller account and then in sender account.
      var appointmentId =  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection('appotiment').doc();
      await TFirebaseApi.user
          .doc(appotimentReciverId)
          .collection('appotiment')
          .add({
        'appotimentId' : appointmentId.id,
        "senderId": FirebaseAuth.instance.currentUser!.uid,
        "appotimentDate": appotimentDate,
        "appotimentMessage": appotimentMessage,
        "appotimentStatus": 'pinding',
        "placeDate": DateTime.now(),
        "isRead" : false,
      }).then((value) {
        TFirebaseApi.user.doc(FirebaseAuth.instance.currentUser!.uid).collection('appotiment').doc(value.id).set({
          "reviverId": appotimentReciverId,
          "appotimentDate": appotimentDate,
          "appotimentMessage": appotimentMessage,
          "appotimentStatus": 'pinding',
          "placeDate": DateTime.now(),
          'appotimentId': value.id,
          'isCustomer' : true,
          "isRead" : false,
        });
        THelper.successMessage(context, "Appotimet placed successfully :)");
        FirebaseFirestore.instance.collection('users').doc(appotimentReciverId).collection('ratings').get().then((value) {

        //   bool docExists = value.docs.any((doc) => doc.id == _auth.currentUser!.uid);
        //   if(docExists){
        //     Navigator.pop(context);
        //   }else{
        //     ratingBarAlert(context,appotimentReciverId);
        //   }
        });
      });
    } catch (error) {
      print("error whiel placing appotiment >>> $error");
    }
  }


  /// accept appotiment
  void acceptAppotiment(BuildContext context, String senderappotimetId, appotimentId) async {
    try{
      await TFirebaseApi.user.doc(senderappotimetId).collection('appotiment').doc(appotimentId).update({
        "appotimentStatus" : "accepted" ,
      }).then((value) {
        TFirebaseApi.user.doc(FirebaseAuth.instance.currentUser!.uid).collection('appotiment').doc(appotimentId).update({
          "appotimentStatus" : "accepted" ,
        });
        THelper.successMessage(context, "Appotimet Accepted");
      });
    }catch(error){
      print('Error while accepting appotiment from AppotimentViewModel $error');
    }
  }

  /// declined appotiment
  void declinedAppotiment(BuildContext context, String senderappotimetId, appotimentId) async {
    try{
      await TFirebaseApi.user.doc(senderappotimetId).collection('appotiment').doc(appotimentId).update({
        "appotimentStatus" : "declined" ,
      }).then((value) {
        TFirebaseApi.user.doc(FirebaseAuth.instance.currentUser!.uid).collection('appotiment').doc(appotimentId).update({
          "appotimentStatus" : "declined" ,
        });
        THelper.successMessage(context, "Appotimet declined");
      });
    }catch(error){
      print('Error while accepting appotiment from AppotimentViewModel $error');
    }
  }


  /// rating bar alert method
  Future ratingBarAlert(BuildContext context,String sellerId,String appointmentId) async {
    double raatingValue = 1.5;
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Rate My Work"),
            content: RatingBar.builder(
                initialRating:1.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                glowColor: Colors.white,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context,_) => Icon(Icons.star,color: Colors.yellow,),
                onRatingUpdate: (value) {
                  raatingValue = value;
                }),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Not Now",style: TextStyle(color: Colors.white),),
                    style: TextButton.styleFrom(
                        backgroundColor: TColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      saveCustomerRating(context, sellerId, raatingValue,appointmentId);
                    },
                    child: Text("Submit",style: TextStyle(color: Colors.white),),
                    style: TextButton.styleFrom(
                        backgroundColor: TColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  /// save customer rating
  Future<void> saveCustomerRating(BuildContext context, String sellerId , double ratingValue,String appointmentId) async {
    try {
      // Reference to the current user's rating document
      DocumentReference ratingDoc = FirebaseFirestore.instance
          .collection('ratings')
          .doc(sellerId)
          .collection('specificRating')
          .doc(appointmentId);

      // Check if the rating already exists
      DocumentSnapshot ratingSnapshot = await ratingDoc.get();

      if (ratingSnapshot.exists) {
        // User has already rated this seller
        THelper.errorMessage(context, "You have already rated this Appointment");
      } else {
        // Save the new rating since no previous rating exists
        await ratingDoc.set({
          "rating value": ratingValue,
          "date": DateTime.now(),
        });

        THelper.successMessage(context, "Rating is saved");
        // Navigate back
        Navigator.pop(context);
      }
    } catch (error) {
      print("Error while saving customer rating: $error");
    }
  }


}