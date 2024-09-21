import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../viewmodel/appotiment/appotiment_view_model.dart';

class AppointmentButton extends StatefulWidget {
  AppointmentButton({
    required this.days,
    required this.time,
    this.onPressed,
    this.icon,
    this.pendingAppointement = false,
    this.acceptOnTap,
    this.declainOnTap,
    this.isCustomer = false,
    this.userId,
    this.placeDate,
    this.appointmentId,
    this.onDelete,
    this.bgColor,
    super.key,
  });
  String days;
  String time;
  VoidCallback? onPressed;
  IconData? icon;
  bool pendingAppointement;
  bool isCustomer;
  final String? userId;
  final void Function()? acceptOnTap;
  final void Function()? declainOnTap;
  final String? placeDate;
  final String? appointmentId;
  VoidCallback? onDelete;
  Color? bgColor;

  @override
  State<AppointmentButton> createState() => _AppointmentButtonState();
}

class _AppointmentButtonState extends State<AppointmentButton> {

  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots(),
        builder: (context , snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: Text('....'),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: CircularProgressIndicator(color: TColors.primaryColor,),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: GestureDetector(
              onTap: (){
                widget.pendingAppointement == false ?
                widget.isCustomer == true ? AppotimentViewModel().ratingBarAlert(context, widget.userId.toString(),widget.appointmentId.toString()) : SizedBox() :
                SizedBox();
              },
              child: Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  height: 60,
                                  width: 60,
                                  imageUrl: snapshot.data!.data()!['profileImage'],
                                  fit: BoxFit.cover,
                                  // imageUrl: "https://i.pinimg.com/75x75_RS/e6/d8/0f/e6d80f3b128101d848e5639c27096e11.jpg",
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: TColors.primaryColor,)),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.data()!['userName'].toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  snapshot.data!.data()!['selectService'] == null || snapshot.data!.data()!['selectService'].toString().isEmpty  ? const SizedBox.shrink() : Text(
                                    snapshot.data!.data()!['selectService'] ?? "",
                                    style: GoogleFonts.poppins(
                                      fontSize: size.width * 0.03,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.data()!['location'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          widget.pendingAppointement ? SizedBox() : Text(
                            "${widget.placeDate}",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: widget.placeDate == "Expired" ? TColors.red : TColors.green,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: snapshot.data!.data()!['selectService'].toString().isEmpty ? 2 : 16,),
                      widget.placeDate == "Expired" ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height * 0.04,
                            width: size.width * 0.28,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                widget.days,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: size.height * 0.04,
                            width: size.width * 0.28,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child:  Center(
                              child: Text(
                                widget.time,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: widget.onDelete,
                            child: Container(
                              height: size.height * 0.04,
                              width: size.width * 0.28,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child:  Center(
                                child: Text(
                                  "Delete",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height * 0.04,
                            width: size.width * 0.40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                widget.days,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: size.height * 0.04,
                            width: size.width * 0.40,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child:  Center(
                              child: Text(
                                widget.time,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          // GestureDetector(
                          //   onTap: widget.onDelete,
                          //   child: Container(
                          //     height: size.height * 0.04,
                          //     width: size.width * 0.28,
                          //     decoration: BoxDecoration(
                          //       color: Colors.red,
                          //       borderRadius: BorderRadius.circular(50),
                          //     ),
                          //     child:  Center(
                          //       child: Text(
                          //         "Delete",
                          //         style: GoogleFonts.poppins(
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.w800,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 12,),

                      /// accept and decline buttons
                      widget.isCustomer ? const SizedBox() : !widget.pendingAppointement ? const SizedBox() : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// accept button
                          InkWell(
                            onTap: widget.acceptOnTap,
                            child: Container(
                              height: size.height * 0.04,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: TColors.green,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  'Accept',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          /// decline button
                          InkWell(
                            onTap: widget.declainOnTap,
                            child: Container(
                              height: size.height * 0.04,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: TColors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  'Decline',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}