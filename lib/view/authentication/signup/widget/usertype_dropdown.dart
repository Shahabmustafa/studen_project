


import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:provider/provider.dart';

class UserTypeDropDown extends StatelessWidget {
  const UserTypeDropDown({
    super.key,
  });


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
              color: TColors.primaryColor,
            ),
          ),
          child: DropdownButton(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            hint: const Text("Select your type"),
            iconEnabledColor: TColors.primaryColor,
            value: provider.type,
            isExpanded: true,
            dropdownColor:TColors.white,
            isDense: false,
            items: const [
              DropdownMenuItem(
                value: "Seller",
                child: Text("Seller"),
              ),
              DropdownMenuItem(
                value: "Customer",
                child: Text("Customer"),
              ),
            ],
            onChanged: (String? value){
              provider.selectType(value!);
            },
          ),
        );
      },
    );
  }
}