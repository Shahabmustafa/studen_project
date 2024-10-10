import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_service_finder/common/button/custom_button.dart';
import 'package:local_service_finder/utils/helper/helper.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:local_service_finder/viewmodel/user/seller_form_viewmodel.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constant/colors.dart';
import '../../../authentication/form/widget/dropdown_popup.dart';

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

  List<String> skills = [
    "Computer and Mobile Repair",
    "Dentist",
    "Doctor",
    "Lawyer",
    "Mobile App Developer",
    "Property Dealer",
    "Professional Office Consultant",
    "Referral Service",
    "Restaurant Delivery Service",
    "Software Engineering",
    "Teacher",
    "Web Developer",
  ];

  String? selectSkill;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SellerFormViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              const SizedBox(height: kToolbarHeight),

              /// Seller form title
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
              const SizedBox(height: 20),

              /// Seller form
              Form(
                key: key,
                child: Column(
                  children: [
                    // User name field
                    TextFormField(
                      controller: userName,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        return value!.isEmpty ? "Please Enter Your UserName" : null;
                      },
                      decoration: const InputDecoration(
                        hintText: "User Name",
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Phone number field
                    TextFormField(
                      controller: phoneNumber,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      validator: (value) {
                        return phoneNumber.text.isEmpty
                            ? "Please Enter Your Phone Number"
                            : phoneNumber.text.length < 11
                            ? "Add 11 Digits"
                            : null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                      ),
                    ),
                    const SizedBox(height: 10),

                    // CNIC number field
                    TextFormField(
                      controller: cnicNumber,
                      decoration: const InputDecoration(
                        hintText: "CNIC-Number",
                      ),
                      maxLength: 13,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return cnicNumber.text.isEmpty
                            ? "Please Enter Your CNIC"
                            : cnicNumber.text.length < 13
                            ? "Add 13 Digits"
                            : null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Select skill dropdown
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: TColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        hint: const Text("Select Service"),
                        iconEnabledColor: TColors.primaryColor,
                        value: selectSkill,
                        isExpanded: true,
                        items: skills.map((String skill) {
                          return DropdownMenuItem<String>(
                            value: skill,
                            child: Text(skill),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectSkill = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Experience field
                    TextFormField(
                      controller: experience,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Experience",
                        helperText: "How many year experience on this field",
                      ),
                      validator: (value) {
                        return experience.text.isEmpty
                            ? "Please Enter Your Experience"
                            : null;
                      },
                      maxLength: 2,
                    ),
                    const SizedBox(height: 10),

                    // Day schedule dropdown
                    CustomMultiSelectDropDown(
                      hint: "Day Schedule",
                      dropdownHeight: 320,
                      onOptionSelected: (options) {
                        daySchedule = options.map((option) => (option).label).toList();
                      },
                      options: const <ValueItem>[
                        ValueItem(label: 'Monday', value: '1'),
                        ValueItem(label: 'Tuesday', value: '2'),
                        ValueItem(label: 'Wednesday', value: '3'),
                        ValueItem(label: 'Thursday', value: '4'),
                        ValueItem(label: 'Friday', value: '5'),
                        ValueItem(label: 'Saturday', value: '6'),
                        ValueItem(label: 'Sunday', value: '7'),
                      ],
                      disabledOptions: const [],
                      maxItems: 7,
                    ),
                    const SizedBox(height: 10),

                    // Time schedule dropdown
                    CustomMultiSelectDropDown(
                      hint: "Time Schedule",
                      maxItems: 3,
                      disabledOptions: const [],
                      dropdownHeight: 200,
                      onOptionSelected: (options) {
                        timeSchedule = options.map((option) => (option).label).toList();
                      },
                      options: const <ValueItem>[
                        ValueItem(label: '9:00 AM to 5:00 PM', value: '1'),
                        ValueItem(label: '1:00 AM to 7:00 PM', value: '2'),
                        ValueItem(label: '11:00 AM to 3:00 PM', value: '3'),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // About field
                    TextFormField(
                      controller: about,
                      decoration: const InputDecoration(
                        hintText: "About",
                      ),
                      maxLines: 5,
                      maxLength: 500,
                      validator: (value) {
                        return about.text.isEmpty
                            ? "Please Enter Your About"
                            : null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Update button
                    Consumer<TProviderHelper>(
                      builder: (context, provider, child) {
                        return CustomButton(
                          hint: "Update",
                          width: double.infinity,
                          loading: controller.loading,
                          height: 60,
                          onTap: () {
                            if (key.currentState!.validate()) {
                              provider.loadingIndicator(true);
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "userName": userName.text,
                                "phoneNumber": phoneNumber.text,
                                "cnicNumber": cnicNumber.text,
                                "selectService": selectSkill.toString(),
                                "experience": experience.text,
                                "about": about.text,
                                "timeSchedule": timeSchedule, // List of strings
                                "daySchedule": daySchedule,   // List of strings
                              }).then((value) {
                                provider.loadingIndicator(false);
                                Navigator.pop(context);
                                THelper.successMessage(context, "Update Your Profile");
                              }).onError((error, stackTrace) {
                                provider.loadingIndicator(false);
                                THelper.errorMessage(context, error.toString());
                              });
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
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
