import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TFirebaseApi{
  TFirebaseApi._();

  /// FirebaseAuth instance

  // static FirebaseAuth auth = FirebaseAuth.instance;
  //
  // static User? currentUser = FirebaseAuth.instance.currentUser;
  //
  // static String userId = FirebaseAuth.instance.currentUser!.uid;

  /// FirebaseFirestore instance

  static final user = FirebaseFirestore.instance.collection("users");


  /// Firebase Messaging instance
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

}