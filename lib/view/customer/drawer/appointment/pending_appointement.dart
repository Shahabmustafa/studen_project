import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:local_service_finder/view/customer/drawer/appointment/widget/appointment_button.dart';
import 'package:local_service_finder/viewmodel/appotiment/appotiment_view_model.dart';

import '../../../../utils/api/firebase/firebase_api.dart';
import '../../../../utils/constant/colors.dart';

class PendingAppointment extends StatefulWidget {
  PendingAppointment({this.appotimentId,super.key});
  String? appotimentId;
  @override
  State<PendingAppointment> createState() => _PendingAppointmentState();
}

class _PendingAppointmentState extends State<PendingAppointment> {

  final AppotimentViewModel appotimentViewModel = AppotimentViewModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: TFirebaseApi.user.doc(FirebaseAuth.instance.currentUser!.uid).collection('appotiment').orderBy("placeDate",descending: true).snapshots(),
        builder: (context , snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            Center(
              child: CircularProgressIndicator(color: TColors.primaryColor,),
            );
          }
          if(snapshot.hasError){
            const Center(
              child: Column(
                children: [
                  Text('error'),
                  CircularProgressIndicator(color: Colors.red,)
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('0 Pending appointments' , style: TextStyle(fontSize: 18),),
            );
          }

          int pendingCount = snapshot.data!.docs.where((doc) => doc['appotimentStatus'] == 'pinding').length;

          if (pendingCount == 0) {
            return const Center(
              child: Text('0 Pending appointments' , style: TextStyle(fontSize: 18),),
            );
          }

          // dynamic appotimentdata = snapshot.data?.docs;
          return ListView.builder(

            itemCount: snapshot.data != null ? snapshot.data!.docs.length : 0,
            itemBuilder: (context,index){
              Timestamp firebaseTimestamp = snapshot.data!.docs[index]['placeDate'] as Timestamp;
              DateTime dateTime = firebaseTimestamp.toDate();
              String formattedTime = DateFormat('hh:mm a').format(dateTime);
              String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
              return snapshot.data?.docs[index]['appotimentStatus'] == 'pinding' ?
              AppointmentButton(
                days: formattedDate,
                time: formattedTime.toString(),
                bgColor: snapshot.data!.docs[index]['appotimentId'] == widget.appotimentId ? Colors.blue.shade100 : Colors.white,
                icon: Iconsax.close_circle,
                isCustomer: snapshot.data!.docs[index].data().containsKey('isCustomer') ? snapshot.data!.docs[index]['isCustomer'] : false,
                pendingAppointement: true,
                onPressed: (){

                },
                acceptOnTap: () {
                  appotimentViewModel.acceptAppotiment(context, snapshot.data?.docs[index]['senderId'], snapshot.data?.docs[index].id);
                },
                declainOnTap: (){
                  appotimentViewModel.declinedAppotiment(context, snapshot.data?.docs[index]['senderId'], snapshot.data?.docs[index].id);
                },
                userId: snapshot.data!.docs[index].data().containsKey('reviverId') ? snapshot.data!.docs[index]['reviverId'] : snapshot.data!.docs[index]['senderId'],
              ) : const SizedBox();
            },
          );
        });
  }
}