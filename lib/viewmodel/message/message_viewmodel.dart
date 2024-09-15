import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_service_finder/model/message.dart';

class MessageViewModel with ChangeNotifier{

  static final auth = FirebaseAuth.instance.currentUser;
  static final firestore = FirebaseFirestore.instance;


  static Future<void> addMessage({required String content,required String receiverId})async{
    final auth = FirebaseAuth.instance.currentUser;
    final Message message = Message(
      senderId: auth!.uid,
      receiverId: receiverId,
      content: content,
      sentTime: DateTime.now(),
    );
    await _addMessageToChat(receiverId,message);
  }

  static Future<void> _addMessageToChat(String receiverId,Message message)async{
    await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chat")
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("chat")
        .doc(receiverId).set({"receiverId" : receiverId,});

    await firestore
        .collection("users")
        .doc(receiverId)
        .collection("chat")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
        .add(message.toJson());

    await firestore
        .collection("users")
        .doc(receiverId)
        .collection("chat")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"receiverId" : auth!.uid,});
  }

  static Future<void> messageList(String id)async {

    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users").doc(id).get();

    var uid = FirebaseAuth.instance.currentUser!.uid;

    if ((doc.data() as dynamic)["messageList"].contains(uid)) {
      await FirebaseFirestore.instance.collection("users").doc(id).update({
        "messageList": FieldValue.arrayRemove([uid]),
      });
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "messageList": FieldValue.arrayRemove([id]),
      });
    }else {
      await FirebaseFirestore.instance.collection("users").doc(id).update({
        "messageList": FieldValue.arrayUnion([uid]),
      });
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "messageList": FieldValue.arrayUnion([id]),
      });
    }
  }

}