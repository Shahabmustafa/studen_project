import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_service_finder/utils/api/firebase/firebase_api.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:local_service_finder/view/customer/drawer/appointment/widget/appointment_button.dart';

class AcceptAppointment extends StatefulWidget {
  AcceptAppointment({this.appotimentId,Key? key}) : super(key: key);

  String? appotimentId;

  @override
  _AcceptAppointmentState createState() => _AcceptAppointmentState();
}

class _AcceptAppointmentState extends State<AcceptAppointment> {

  String _formatTimeLeft(DateTime appointmentDate) {
    final now = DateTime.now();
    final difference = appointmentDate.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} days left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes left';
    } else {
      return 'Expired';
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: TFirebaseApi.user.doc(FirebaseAuth.instance.currentUser!.uid).collection('appotiment').orderBy("placeDate",descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: TColors.primaryColor));
        }
        if (snapshot.hasError) {
          return const Center(
              child: Column(children: [
                Text('Error'),
                CircularProgressIndicator(color: Colors.red)
              ]));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text('No appointments found.',
                  style: TextStyle(fontSize: 18)));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            Timestamp firebaseTimestamp =
            snapshot.data!.docs[index]['appotimentDate'] as Timestamp;
            DateTime dateTime = firebaseTimestamp.toDate();
            String formattedTime = DateFormat('hh:mm a').format(dateTime);
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            String timeLeft = _formatTimeLeft(dateTime);
            print('Time left for appointment: $timeLeft');
            final minutesLeft = dateTime.difference(DateTime.now()).inMinutes;
            print('Minutes left: $minutesLeft');
            return snapshot.data!.docs[index]['appotimentStatus'] == 'accepted' ?
            AppointmentButton(
              days: formattedDate,
              time: formattedTime,
              bgColor: snapshot.data!.docs[index]['appotimentId'] == widget.appotimentId ? Colors.blue.shade100 : Colors.white,
              icon: null,
              isCustomer: snapshot.data!.docs[index].data().containsKey('isCustomer') ? snapshot.data!.docs[index]['isCustomer'] : false,
              pendingAppointement: false,
              userId: snapshot.data!.docs[index].data().containsKey('reviverId') ? snapshot.data!.docs[index]['reviverId'] : snapshot.data!.docs[index]['senderId'],
              placeDate: timeLeft.toString(),
              onDelete: () {
                FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("appotiment").doc(snapshot.data!.docs[index].id).delete();
              },
              appointmentId: snapshot.data!.docs[index].id.toString(),
            ) :
            SizedBox();
          },
        );
      },
    );
  }
}