import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:local_service_finder/common/drawer/dawer.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodel/profileupdate/profile_update_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      drawer: DrawerScreen(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
            Timestamp timestamp = data["createAccount"];
            DateTime date = timestamp.toDate();
            String formattedDate = DateFormat('yyyy-MM-dd').format(date);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Consumer<ProfileUpdateViewModel>(
                      builder: (context,value,child){
                        return Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: value.image == null
                                      ? CachedNetworkImage(
                                    height: 130,
                                    width: 130,
                                    imageUrl: data["profileImage"],
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  )
                                      : Image.file(
                                    File(value.image!.path),
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,  // Adjust the fit as necessary
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.camera_alt),
                                                title: Text("Camera"),
                                                trailing: Icon(Icons.arrow_forward_ios),
                                                onTap: (){
                                                  value.pickImage(context, ImageSource.camera);
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.photo),
                                                title: Text("Photo"),
                                                trailing: Icon(Icons.arrow_forward_ios),
                                                onTap: (){
                                                  value.pickImage(context, ImageSource.gallery);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: TColors.primaryColor,
                                    child: Icon(CupertinoIcons.camera,color: Colors.white,),
                                  ),
                                ),
                              ],
                            )
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data["userName"],
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: userName,
                                        decoration: InputDecoration(
                                          hintText: "Change UserName",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: (){
                                              FirebaseFirestore.instance.collection("users")
                                                  .doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                "userName" : userName.text.trim(),
                                              }).then((value) => Navigator.pop(context));
                                            },
                                            child: Text("update"),
                                          ),
                                          ElevatedButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: Text("cancel"),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Iconsax.edit),
                        )
                      ],
                    ),
                    Text(
                      data["type"],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),


                  ],
                ),
                const SizedBox(
                  height: kToolbarHeight,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: ListView(
                      children: [
                        SizedBox(height: height * 0.02,),
                        ListTile(
                          title: Text(
                            "Id",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Text(
                            data["userId"],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Email",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Text(
                            data["email"],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Create Account",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Text(
                            formattedDate,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}
