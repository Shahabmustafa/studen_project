import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:local_service_finder/utils/helper/helper.dart';
import 'package:local_service_finder/viewmodel/message/message_viewmodel.dart';

import '../../../../common/bubble_message.dart';
import '../../../../utils/constant/colors.dart';
import '../../../../viewmodel/notification/firebase_notification_viewmodel.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.otherId,this.userName,this.status,this.profileImage,super.key});

  String? otherId;
  String? profileImage;
  String? userName;
  bool? status;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    // with WidgetsBindingObserver
{
  final sendMessage = TextEditingController();

  final notificationService = NotificationService();

  // void stateChange(bool status)async{
  //   await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
  //     "status" : status,
  //   });
  // }
  //
  // void didChangeAppLifeCycle(AppLifecycleState state){
  //   if(state == AppLifecycleState.resumed){
  //     stateChange(true);
  //   }else{
  //     stateChange(false);
  //   }
  // }
  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
    // stateChange(true);
  }
  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                imageUrl: widget.profileImage.toString(),
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: TColors.primaryColor,
                    )),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                widget.status == true ?
                const Text(
                "Online",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),
                ) :
                const Text(
                  "Offline",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [

          /// messages
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").
              doc(widget.otherId).collection("chat").
              doc(FirebaseAuth.instance.currentUser!.uid).
              collection("messages").orderBy("sentTime",descending: false).snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        Timestamp timestamp = snapshot.data!.docs[index]["sentTime"];
                        DateTime sendDate = timestamp.toDate();
                        String formattedDate = DateFormat('HH:mm').format(sendDate);
                        final isMe = widget.otherId != snapshot.data!.docs[index]["senderId"];
                        return MessageBubble(
                          isMe:  isMe,
                          content: snapshot.data!.docs[index]["content"].toString(),
                          timeStep: formattedDate.toString(),
                        );
                      }
                  );
                }else{
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ),
          /// textformfiell and send button
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: height * 0.08,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        controller: sendMessage,
                        decoration: InputDecoration(
                          hintText: "Aa",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade200
                        ),
                      )
                  ),
                 IconButton(
                   onPressed: ()async{
                    if(sendMessage.text.isEmpty){
                      THelper.toastMessage("Add Message");
                    }else{
                      await MessageViewModel.addMessage(
                        content: sendMessage.text,
                        receiverId: widget.otherId.toString(),
                      );
                      sendMessage.clear();
                    }
                   },
                   icon:  const Icon(Icons.near_me),
                 )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
