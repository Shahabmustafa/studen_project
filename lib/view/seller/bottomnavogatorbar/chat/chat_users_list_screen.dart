import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:local_service_finder/view/seller/bottomnavogatorbar/chat/chat_screen.dart';

class ChatUsersListScreen extends StatelessWidget {
  const ChatUsersListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging List'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("chat").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> chatIds = snapshot.data!.docs.map((doc) => doc.id).toList();
            return ListView.builder(
              itemCount: chatIds.length,
              itemBuilder: (context, index) {
                String chatId = chatIds[index];
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").
                  doc(chatId).snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                              profileImage: data["profileImage"],
                              userName: data["userName"],
                              status: data["status"],
                              otherId:  data["userId"].toString(),
                            )));
                          },
                          leading: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  imageUrl: data["profileImage"].toString(),
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: TColors.primaryColor,
                                      )),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                              Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: data["status"] ? TColors.green : TColors.gray,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ],
                          ),
                          title: Text(data["userName"],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                          subtitle: Text(data["type"],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: TColors.gray),),
                          trailing: IconButton(
                            onPressed: ()async{
                              await FirebaseFirestore.instance.collection("users").
                              doc(FirebaseAuth.instance.currentUser!.uid).collection("chat").
                              doc(data["userId"]).delete();
                              await FirebaseFirestore.instance.collection("users").
                              doc(data["userId"]).collection("chat").
                              doc(FirebaseAuth.instance.currentUser!.uid).delete();
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    }else{
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            );
          }else{
            return const Center(child: CircularProgressIndicator());
          }

        },
      ),
    );
  }
}
