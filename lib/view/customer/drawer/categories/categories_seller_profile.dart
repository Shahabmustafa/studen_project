import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_service_finder/common/button/custom_button.dart';
import 'package:local_service_finder/view/customer/drawer/categories/appointment.dart';
import 'package:local_service_finder/view/seller/bottomnavogatorbar/chat/chat_screen.dart';
import 'package:local_service_finder/viewmodel/profileupdate/profile_update_viewmodel.dart';

import '../../../../utils/constant/colors.dart';

class CategoriesSellerProfile extends StatefulWidget {
  CategoriesSellerProfile({super.key, required this.userId});
  String userId;
  @override
  State<CategoriesSellerProfile> createState() =>
      _CategoriesSellerProfileState();
}

class _CategoriesSellerProfileState extends State<CategoriesSellerProfile> {
  final ProfileUpdateViewModel profileUpdateViewModel = ProfileUpdateViewModel();
  List? ratingValue;

  void callRatingMethods() async {
    ratingValue = await profileUpdateViewModel.calculateAverageRating(widget.userId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callRatingMethods();
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(widget.userId.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        imageUrl: data["profileImage"],
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              color: TColors.primaryColor,
                                            )),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          color: data["status"] ? TColors.green : TColors.gray,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  data["userName"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
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
                              ],
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: _parseRatingValue(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            ignoreGestures: true,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemSize: 30,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 10,
                            ),
                            onRatingUpdate: (rating) {
                            },
                          ),
                          Text(
                            '${_parseRatingValue().toStringAsFixed(1)}/5 (${_parseReviewCount()} reviews)',
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                          ),
                          Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                "About me",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                data["about"],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: Text(
                                "Phone Number",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
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
                            child: ListTile(
                              title: Text(
                                "CNIC Number",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
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
                          Card(
                            child: ListTile(
                              title: Text(
                                "Experience",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Text(
                                data["experience"],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: Text(
                                "Location",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
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
                          Card(
                            child: ListTile(
                              title: Text(
                                "Time Scheduler",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Text(
                                (data["timeSchedule"] != null && data["timeSchedule"].isNotEmpty)
                                    ? data["timeSchedule"][0]
                                    : "Null", // Check if the list is not empty before accessing the first element
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  child: Text(
                                    "Days Scheduler",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Wrap(
                                spacing: MediaQuery.sizeOf(context).width * 0.07,
                                runSpacing: MediaQuery.sizeOf(context).width * 0.04,
                                runAlignment: WrapAlignment.spaceBetween,
                                alignment: WrapAlignment.center,
                                children: List.generate(data["daySchedule"].length, (index) => Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${data["daySchedule"][index]}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ))
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: CustomButton(
                            hint: "Appointment",
                            width: double.infinity,
                            height: 60,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Appointment(
                                        scheduletTime:
                                        data["timeSchedule"][0].toString(),
                                        daysSchedular: data["daySchedule"],
                                        sellerId: data['userId'],
                                        sellerName: data['userName'],
                                        sellerLocation: data['location'],
                                        sellerService: data['selectService'],
                                      )));
                            },
                          ),
                        ),
                    SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      onPressed: (){
                        Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userName: data['userName'],
                            profileImage: data["profileImage"],
                            otherId: data["userId"],
                            status: data["status"],
                          ),
                        ),
                        );
                      },
                      child: Icon(Icons.chat),
                    )
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
