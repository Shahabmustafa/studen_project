import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_service_finder/common/button/custom_button.dart';
import 'package:local_service_finder/common/dropdown/skill_dropdown.dart';
import 'package:local_service_finder/utils/helper/helper.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:local_service_finder/utils/validation/validation.dart';
import 'package:local_service_finder/view/authentication/form/widget/dropdown_popup.dart';
import 'package:local_service_finder/viewmodel/user/seller_form_viewmodel.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

import '../../../utils/constant/colors.dart';

class SellerFormScreen extends StatefulWidget {
  const SellerFormScreen({super.key});

  @override
  State<SellerFormScreen> createState() => _SellerFormScreenState();
}

class _SellerFormScreenState extends State<SellerFormScreen> {

  GlobalKey<FormState> key = GlobalKey<FormState>();

  final MultiSelectController _controller = MultiSelectController();

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController cnicNumber = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController about = TextEditingController();
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
      appBar: AppBar(
        title: Text(
          "Seller Form",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              const SizedBox(
                height: kToolbarHeight,
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
                      controller: phoneNumber,
                      keyboardType: TextInputType.phone,
                      validator: (value){
                        return TValidator.validatePhoneNumber(value);
                      },
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                      ),
                      maxLength: 11,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: cnicNumber,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "CNIC-Number",
                      ),
                      maxLength: 13,
                      validator: (value){
                        return cnicNumber.text.isEmpty ? "Please Enter Your CNIC" : null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: TColors.white,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        hint: Text("Select Service"),
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
                            selectSkill = newValue;  // Ensure the value is updated correctly
                          });
                        },
                      ),
                    ),
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
                        return cnicNumber.text.isEmpty ? "Please Enter Your Experience" : null;
                      },
                      maxLength: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomMultiSelectDropDown(
                      hint: "Day Schedule",
                      dropdownHeight: 320,
                      onOptionSelected: (options){
                        // daySchedule.add(options.toString());
                        // print(options);
                        daySchedule = options;
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
                      disabledOptions: [],
                      maxItems: 7,

                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomMultiSelectDropDown(
                      hint: "Time Schedule",
                      maxItems: 3,
                      disabledOptions: [],
                      dropdownHeight: 200,
                      onOptionSelected: (options){
                        timeSchedule = options;
                      },
                      options: const <ValueItem>[
                        ValueItem(label: '9:00 AM to 5:00 PM', value: '1'),
                        ValueItem(label: '1:00 AM to 7:00 PM', value: '2'),
                        ValueItem(label: '11:00 AM to 3:00 PM', value: '3'),
                      ],
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
                          hint: "Continue",
                          width: double.infinity,
                          loading: controller.loading,
                          height: 60,
                            onTap: () async {
                              if (selectSkill == null || timeSchedule.isEmpty || daySchedule.isEmpty ||
                                  phoneNumber.text.isEmpty || cnicNumber.text.isEmpty ||
                                  experience.text.isEmpty || about.text.isEmpty) {
                                THelper.errorMessage(context, "Please Fill All TextField & DropDown");
                              } else {
                                await controller.sellerForm(
                                  context,
                                  phoneNumber.text,
                                  cnicNumber.text,
                                  selectSkill.toString(),
                                  experience.text,
                                  about.text,
                                  daySchedule,
                                  timeSchedule,
                                );
                                daySchedule.clear();
                                timeSchedule.clear();
                                setState(() {
                                  selectSkill = null; // Reset to null instead of an empty string
                                });
                              }
                            }
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
