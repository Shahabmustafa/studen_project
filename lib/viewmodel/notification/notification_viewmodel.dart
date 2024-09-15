import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationViewmodel{


  reject(String appointmentId,String customerId,String notificationId){
    FirebaseFirestore.instance.collection("users").doc(customerId).collection("appointment").doc(appointmentId).update({
      "appointmentStatus" : "rejected",
    });
    addNotification(customerId, "rejected",appointmentId);
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).
    collection("appointment").doc(appointmentId).delete();
    deleteNotification(notificationId);
  }

  accept(String appointmentId,String customerId,String notificationId)async{
   await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).
    collection("appointment").doc(appointmentId).update({
      "appointmentStatus" : "accept",
    });
    FirebaseFirestore.instance.collection("users").doc(customerId).collection("appointment").doc(appointmentId).update({
      "appointmentStatus" : "accept",
    });
    addNotification(customerId, "accept",appointmentId);
    deleteNotification(notificationId);
  }


  
  addNotification(String reciverId,String message,String appointmentId){
    FirebaseFirestore.instance.collection("notification").doc(reciverId).collection("showNotification").add({
      "senderId" : FirebaseAuth.instance.currentUser!.uid,
      "reciverId" : reciverId,
      "sendDate" : DateTime.now(),
      "message" : message,
      "appointmentId" : appointmentId,
    });
  }

  deleteNotification(String notification){
    FirebaseFirestore.instance.collection("notification").doc(FirebaseAuth.instance.currentUser!.uid).
    collection("showNotification").doc(notification).delete();
  }

}