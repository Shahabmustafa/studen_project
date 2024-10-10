import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_service_finder/common/drawer/dawer.dart';
import 'package:local_service_finder/utils/api/firebase/firebase_api.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:local_service_finder/view/customer/drawer/categories/categories_seller_profile.dart';
import 'package:local_service_finder/view/customer/drawer/categories/widget/user_card.dart';
import 'package:local_service_finder/viewmodel/authentication/authentication_viewmodel.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  List<dynamic> likesIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLikesList();
  }

  void getLikesList() async {
    try{
      await TFirebaseApi.user.doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        likesIds = value.data()?['likes'];
        AuthenticationViewModel().loadingIndicator(true);
      }).onError((error, stackTrace) {
        AuthenticationViewModel().loadingIndicator(false);
        print('error while  get likes list >>>>>>>');
      });
    }catch(error){
      print('error while  get likes list catch error >>>>>>> $error');
      AuthenticationViewModel().loadingIndicator(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite"),
      ),
      drawer: const DrawerScreen(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context , snapshot) {
          /// loading while wating for data
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: TColors.primaryColor,),);
          }

          /// errer descripiton if ancase of any error
          if(snapshot.hasError) {
            return Center(
              child: Text(
                "Unable to show Favourite data \nPlesae check your Internet\nConnection",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: TColors.primaryColor
                ),
              ),
            );
          }

        return AuthenticationViewModel().loading ? const CircularProgressIndicator() : likesIds.isEmpty ? const Center(child: Text('No Favourite sellers',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)) : ListView.builder(
          itemCount: snapshot.data!.docs.length,
            itemBuilder: (context , index) {
              return likesIds.contains(snapshot.data?.docs[index].id) ? UserCard(
                userName: snapshot.data!.docs[index]["userName"],
                imageUrl: snapshot.data!.docs[index]["profileImage"],
                location: snapshot.data!.docs[index]["location"],
                serviceText: snapshot.data!.docs[index]["selectService"],
                likes: snapshot.data!.docs[index]["likes"].length.toString(),
                icon: snapshot.data!.docs[index]["likes"].contains(FirebaseAuth.instance.currentUser!.uid) ? Icons.favorite : Icons.favorite_border,
                onTap: (){
                  print(snapshot.data!.docs[index]["userId"]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesSellerProfile(userId: snapshot.data!.docs[index]["userId"])));
                  FirebaseFirestore.instance.collection('users').doc(snapshot.data!.docs[index]["userId"]).update({
                    "messageList" : FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                  });
                },
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: const Text("Do You Want Un Favourite"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: ()async{
                                    await liked(snapshot.data!.docs[index]["userId"]);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("UnFavourite"),
                                ),
                                ElevatedButton(
                                  onPressed: (){
                                     Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ) : const SizedBox();
        });
      },)
    );
  }

  liked(String id)async {

    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users")
        .doc(id)
        .get();
    var uid = FirebaseAuth.instance.currentUser!.uid;
    if ((doc.data() as dynamic)["likes"].contains(uid)) {
      await FirebaseFirestore.instance.collection("users").doc(id).update({
        "likes": FieldValue.arrayRemove([uid]),
      });
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "likes": FieldValue.arrayRemove([id]),
      });
    }else {
      await FirebaseFirestore.instance.collection("users").doc(id).update({
        "likes": FieldValue.arrayUnion([uid]),
      });
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "likes": FieldValue.arrayUnion([id]),
      });
    }
  }

}
