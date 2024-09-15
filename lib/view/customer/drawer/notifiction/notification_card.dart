import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class NotificationCardScreen extends StatelessWidget {
  final String senderOrReciverId;
  final String? appotimentStatus;
  final Timestamp? appotimentDate;
  final bool? isRead;
  NotificationCardScreen({super.key, required this.senderOrReciverId, this.appotimentStatus, this.appotimentDate,this.isRead});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(senderOrReciverId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }

        // Convert Timestamp to DateTime
        DateTime? dateTime;
        if (appotimentDate != null) {
          dateTime = appotimentDate!.toDate();
        }

        // Format the DateTime to String
        String formattedDate = dateTime != null ? DateFormat.yMMMd().add_jm().format(dateTime) : '';

        return Card(
          color: isRead == false ? Colors.blue.shade100 : Colors.white,
          child: ListTile(
            minVerticalPadding: 6,

            /// user image avatar
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(snapshot.data!.data()!['profileImage']),
              backgroundColor: TColors.primaryColor,
            ),

            /// customer name and notification time
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  snapshot.data!.data()!['userName'].toString(),
                  style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w700),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: size.width * 0.03, color: isRead == false ? TColors.black : TColors.gray),
                ),
              ],
            ),

            /// notifiaction descripition
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.data!.data()!['type'] == "Seller"
                      ? appotimentStatus == 'pinding'
                      ? "You Placed new Appointment"
                      : appotimentStatus == 'accepted'
                      ? "Your Appointment is Accepted"
                      : "Your Appointment is Declined"
                      : appotimentStatus == 'pinding'
                      ? "You got new Appointment"
                      : appotimentStatus == 'accepted'
                      ? "Appointment Accepted"
                      : "Appointment Declined",
                  style: TextStyle(fontSize: 14, color:  isRead == false ? TColors.black : TColors.gray),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}