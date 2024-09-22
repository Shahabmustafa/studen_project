import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/common/drawer/dawer.dart';
import 'package:local_service_finder/common/dropdown/skill_dropdown.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:local_service_finder/view/authentication/signup/widget/select_city_dropdown.dart';
import 'package:local_service_finder/view/customer/drawer/categories/categories_seller_profile.dart';
import 'package:local_service_finder/view/customer/drawer/categories/widget/user_card.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TProviderHelper>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      drawer: DrawerScreen(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: SkillDropDown(),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: SelectCityDropDown(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                stream: getUserStream(controller.selectCity, controller.selectSkill),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var userDoc = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                      // Check for the existence of the field "selectService"
                      String serviceText = userDoc.containsKey("selectService") ? userDoc["selectService"] : "Service not specified";

                      return UserCard(
                        userName: userDoc["userName"] ?? "Unknown",
                        imageUrl: userDoc["profileImage"] ?? "",
                        location: userDoc["location"] ?? "Unknown location",
                        serviceText: serviceText, // Use the safe serviceText value
                        likes: userDoc.containsKey("likes") ? userDoc["likes"].length.toString() : "0",
                        icon: userDoc["likes"]?.contains(FirebaseAuth.instance.currentUser!.uid) == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesSellerProfile(userId: userDoc["userId"]),
                            ),
                          );
                          FirebaseFirestore.instance.collection('users').doc(userDoc["userId"]).update({
                            "messageList": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                          });
                        },
                        onPressed: () {
                          liked(userDoc["userId"]);
                        },
                      );
                    },
                  );

                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getUserStream(String? selectedCity, String? selectedSkill) {
    var query = FirebaseFirestore.instance.collection("users").where("type", isEqualTo: "Seller");

    if (selectedCity != null && selectedCity != "All") {
      query = query.where("location", isEqualTo: selectedCity);
    }
    if (selectedSkill != null && selectedSkill != "All") {
      query = query.where("selectService", isEqualTo: selectedSkill);
    }

    return query.snapshots();
  }

  void liked(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users").doc(id).get();
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if ((doc.data() as dynamic)["likes"].contains(uid)) {
      await FirebaseFirestore.instance.collection("users").doc(id).update({
        "likes": FieldValue.arrayRemove([uid]),
      });
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "likes": FieldValue.arrayRemove([id]),
      });
    } else {
      await FirebaseFirestore.instance.collection("users").doc(id).update({
        "likes": FieldValue.arrayUnion([uid]),
      });
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "likes": FieldValue.arrayUnion([id]),
      });
    }
  }

  void addFavourite(String sellerUserId) {
    FirebaseFirestore.instance.collection("favourite").doc(FirebaseAuth.instance.currentUser!.uid).set({
      "userId": sellerUserId,
    });
  }

  void deleteFavourite(String sellerUserId) {
    FirebaseFirestore.instance.collection("favourite").doc(FirebaseAuth.instance.currentUser!.uid).delete();
  }
}