import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile View"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            // Get the list of user IDs from the snapshot data
            List<String> userIds = List<String>.from(data["messageList"]);

            // Create a stream to fetch user data for each user ID in userIds
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").where(FieldPath.documentId, whereIn: userIds).snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  var users = userSnapshot.data!.docs;
                  if (users.isNotEmpty) {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var userData = users[index].data();

                        return Card(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                imageUrl: userData['profileImage'].toString(),
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            title: Text(userData['userName'].toString()),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No users found."));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
