

import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:provider/provider.dart';

class SkillDropDown extends StatelessWidget {
  SkillDropDown({
    super.key,
  }){
    skills.sort();
  }

  final List<String> skills = [
    "All",
    "Computer and Mobile Repair",
    "Dentist",
    "Doctor",
    "Lawyer",
    "Mobile App Developer",
    "Property Dealer",
    "Professional Office Consultant",
    "Referral Service",
    "Restaurant Delivery Service",
    "Softwere Enginering",
    "Teacher",
    "Web Developer",
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<TProviderHelper>(
      builder: (context,provider,child){
        return Container(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: DropdownButton(
            dropdownColor: TColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            hint: const Text("Select Service"),
            iconEnabledColor: TColors.primaryColor,
            value: provider.selectSkill,
            isExpanded: true,
            items: skills.map((String cityName){
              return DropdownMenuItem<String>(
                value: cityName,
                child: Text(cityName),
              );
            }).toList(),
            onChanged: (String? value){
              provider.skill(value!);
            },
          ),
        );
      },
    );
  }
}
