
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_service_finder/common/button/custom_button.dart';
import 'package:local_service_finder/common/dropdown/skill_dropdown.dart';
import 'package:local_service_finder/utils/helper/helper.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:local_service_finder/utils/validation/validation.dart';
import 'package:local_service_finder/viewmodel/user/seller_form_viewmodel.dart';
import 'package:provider/provider.dart';

class UpdateSellerProfile extends StatefulWidget {
  const UpdateSellerProfile({super.key});


  @override
  State<UpdateSellerProfile> createState() => _UpdateSellerProfileState();
}

class _UpdateSellerProfileState extends State<UpdateSellerProfile> {

  GlobalKey<FormState> key = GlobalKey<FormState>();
  String? selectService;

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController cnicNumber = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController about = TextEditingController();
  TextEditingController userName = TextEditingController();
  List<dynamic> daySchedule = [];
  List<dynamic> timeSchedule = [];


  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SellerFormViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),

              /// seller form text

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Update Seller Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),

              /// seller form text field
              Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: userName,
                      keyboardType: TextInputType.name,
                      validator: (value){
                        return value!.isEmpty ? "Please Enter Your UserName" : null;
                      },
                      decoration: const InputDecoration(
                        hintText: "User Name",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phoneNumber,
                      keyboardType: TextInputType.phone,
                      validator: (value){
                        return phoneNumber.text.isEmpty ? "Please Enter Your Phone Number" : phoneNumber.text.length < 13 ? "Add 11 Digits" : null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: cnicNumber,
                      decoration: const InputDecoration(
                        hintText: "CNIC-Number",
                      ),
                      validator: (value){
                        return cnicNumber.text.isEmpty ? "Please Enter Your CNIC" : cnicNumber.text.length < 13 ? "Add 13 Digits" : null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SkillDropDown(),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: experience,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Experience",
                        helperText: "How many year experience on this field",
                      ),
                      validator: (value){
                        return experience.text.isEmpty ? "Please Enter Your Experience" : null;
                      },
                      maxLength: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: about,
                      decoration: const InputDecoration(
                        hintText: "About",
                      ),
                      maxLines: 5,
                      maxLength: 500,
                      validator: (value){
                        return about.text.isEmpty ? "Please Enter Your About" : null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<TProviderHelper>(
                      builder: (context,provider,child){
                        return CustomButton(
                          hint: "Update",
                          width: double.infinity,
                          loading: controller.loading,
                          height: 60,
                          onTap: (){
                            if(key.currentState!.validate()){
                              provider.loadingIndicator(true);
                              FirebaseFirestore.instance.
                              collection("users").
                              doc(FirebaseAuth.instance.currentUser!.uid).
                              update({
                                "userName" : userName.text,
                                "phoneNumber" : phoneNumber.text,
                                "cnicNumber" : cnicNumber.text,
                                "selectService" : provider.selectSkill.toString(),
                                "experience" : experience.text,
                                "about" : about.text,
                              }).then((value){
                                provider.loadingIndicator(false);
                                Navigator.pop(context);
                                THelper.successMessage(context, "Update Your Profile");
                              }).onError((error, stackTrace){
                                provider.loadingIndicator(false);
                                THelper.errorMessage(context, error.toString());
                              });
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
