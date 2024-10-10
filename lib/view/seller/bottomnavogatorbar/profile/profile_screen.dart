import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_service_finder/common/button/custom_button.dart';
import 'package:local_service_finder/view/authentication/login/login_view.dart';
import 'package:local_service_finder/view/customer/drawer/home/map.dart';
import 'package:local_service_finder/view/seller/bottomnavogatorbar/profile/profile_view_screen.dart';
import 'package:local_service_finder/view/seller/bottomnavogatorbar/profile/update_seller_profile.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodel/profileupdate/profile_update_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileUpdateViewModel profileUpdateViewModel =
  ProfileUpdateViewModel();
  List? ratingValue;
  final name = TextEditingController();
  final about = TextEditingController();


// Updated callRatingMethods
  void callRatingMethods() async {
    ratingValue = await profileUpdateViewModel.calculateAverageRating(FirebaseAuth.instance.currentUser!.uid);
    setState(() {}); // Update UI after getting the rating
  }

// Method to parse rating value
  double _parseRatingValue() {
    if (ratingValue != null && ratingValue!.isNotEmpty) {
      try {
        return double.parse(ratingValue![0].toString()); // Fetch average rating value
      } catch (e) {
        return 0.0; // Default value if parsing fails
      }
    }
    return 0.0; // Default value if no rating available
  }

// Method to parse the number of reviews
  int _parseReviewCount() {
    if (ratingValue != null && ratingValue!.isNotEmpty) {
      try {
        return int.parse(ratingValue![1].toString()); // Fetch review count
      } catch (e) {
        return 0; // Default value if parsing fails
      }
    }
    return 0; // Default value if no reviews available
  }
  @override
  void initState() {
    super.initState();
    callRatingMethods();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateSellerProfile(),
                ),
              );
            },
            icon: const Icon(
              Iconsax.edit,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Consumer<ProfileUpdateViewModel>(
                      builder: (context, value, child) {
                        return Center(
                            child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: value.image == null ?
                              CachedNetworkImage(
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                                imageUrl: data["profileImage"],
                                progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress), errorWidget: (context, url, error) => const Icon(Icons.error),
                              ) :
                              Image.file(
                                File(value.image!.path),
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover, // Adjust the fit as necessary
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const Text("Camera"),
                                          trailing:
                                              const Icon(Icons.arrow_forward_ios),
                                          onTap: () {
                                            value.pickImage(
                                                context, ImageSource.camera);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo),
                                          title: const Text("Gallery"),
                                          trailing:
                                              const Icon(Icons.arrow_forward_ios),
                                          onTap: () {
                                            value.pickImage(
                                                context, ImageSource.gallery);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      data["userName"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      data["type"],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    /// rating reviews
                    RatingBar.builder(
                      initialRating: _parseRatingValue(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemSize: 30,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 10,
                      ),
                      onRatingUpdate: (rating) {
                      },
                    ),
                    Text(
                      '${_parseRatingValue().toStringAsFixed(1)}/5 (${_parseReviewCount()} reviews)',
                      style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: ListView(
                      children: [
                        /// about section
                        Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              "About me",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              data["about"] ?? "abouet section",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        /// user email
                        Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              "Email",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              data["email"],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              "Phone",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              data["phoneNumber"],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              "CNIC",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              data["cnicNumber"],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        /// user Services
                        Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              "Services",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              data["selectService"].toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        /// user location
                        Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              "Location",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              data["location"],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        /// total likes
                        Card(
                          child: ListTile(
                            title: Text(
                              "likes",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              data["likes"].length.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        /// profile view
                        Card(
                          child: ListTile(
                            title: Text(
                              "Profile view",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              data["messageList"].length.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileViewScreen()));
                            },
                          ),
                        ),
                        /// edit profile
                        Card(
                          child: ListTile(
                            title: Text(
                              "Convert To Customer",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(Icons.edit, color: Colors.black54),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "You Want Convert Account To Customer"),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomButton(
                                          hint: "No",
                                          width: 100,
                                          height: 30,
                                          color: Colors.red,
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CustomButton(
                                          hint: "Yes",
                                          width: 100,
                                          height: 30,
                                          color: Colors.green,
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              "type": "Customer",
                                              "daySchedule": [],
                                              "timeSchedule": [],
                                              "cnicNumber": "",
                                              "selectService": "",
                                              "latitude": FieldValue.delete(),
                                              "longitude": FieldValue.delete(),
                                              "experience": "",
                                              "about": "",
                                            }).then((value) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MapScreen()));
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        /// logout buttton
                        Card(
                          child: ListTile(
                            title: Text(
                              "Logout",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(Icons.logout, color: Colors.black54),
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                "status" : false,
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()),
                                  (route) => false);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
