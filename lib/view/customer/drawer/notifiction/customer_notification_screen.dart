import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';

import '../../../../common/bottomnavigatorbar/bottom_navigator_bar.dart';
import '../../../seller/bottomnavogatorbar/home/home_screen.dart';
import 'notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String userType = '';

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  // Fetch the current user's type from Firestore
  Future<void> _getUserType() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      setState(() {
        // Assuming there's a field 'userType' in the document
        userType = userDoc['type'] ?? 'Unknown';
      });
    } catch (e) {
      print('Error fetching user type: $e');
    }
  }
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
                      userType == "Seller" ?
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigatorBarScreen(
                            initialIndex: snapshot.data!.docs[index]["appotimentStatus"] == "accepted" ? 0 : 1,
                            appotimentId: snapshot.data!.docs[index]["appotimentId"],
                          ),
                        ),
                      ) :
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          HomeScreen(initialIndex: snapshot.data!.docs[index]["appotimentStatus"] == "accepted" ? 0 : 1,appotimentId: snapshot.data!.docs[index]["appotimentId"],),
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
                        const SizedBox(),
                      ],
                    ),
                  );
                }),
          );
        },
      ),
    );
  }}