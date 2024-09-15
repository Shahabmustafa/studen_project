import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import '../../../customer/drawer/appointment/accept_appointment.dart';
import '../../../seller/bottomnavogatorbar/home/home_screen.dart';
import 'notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Notification'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('appotiment').orderBy("placeDate",descending: true).snapshots(),
        builder: (context , snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(color: TColors.primaryColor,),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String senderOrReciverId = snapshot.data!.docs[index].data().containsKey("senderId") ? snapshot.data!.docs[index]['senderId'].toString() : snapshot.data!.docs[index]['reviverId'].toString();
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                          HomeScreen(initialIndex: snapshot.data!.docs[index]["appotimentStatus"] == "accepted" ? 0 : 1,),
                      ));
                      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("appotiment").doc(snapshot.data!.docs[index].id).update({
                        "isRead" : true,
                      });
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        NotificationCardScreen(
                          senderOrReciverId: senderOrReciverId.toString(),
                          appotimentStatus: snapshot.data!.docs[index]['appotimentStatus'].toString(),
                          appotimentDate: snapshot.data!.docs[index]['placeDate'],
                          isRead: snapshot.data!.docs[index]["isRead"],
                        ),
                        snapshot.data!.docs[index]["isRead"] == false ?
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: TColors.red,
                            borderRadius: BorderRadius.circular(100)
                          ),
                        ) :
                        SizedBox(),
                      ],
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}