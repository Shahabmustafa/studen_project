import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:provider/provider.dart';

class SelectCityDropDown extends StatelessWidget {
  SelectCityDropDown({
    super.key,
  }){
    city.sort();
  }

  List<String> city = [
    "All",
    "Karachi",
    "Lahore",
    "Islamabad",
    "Rawalpindi",
    "Faisalabad",
    "Multan",
    "Peshawar",
    "Quetta",
    "Gujranwala",
    "Sialkot",
    "Hyderabad",
    "Bahawalpur",
    "Sargodha",
    "Sukkur",
    "Larkana",
    "Sheikhupura",
    "Mirpur Khas",
    "Rahim Yar Khan",
    "Gujrat",
    "Mardan",
    "Kasur",
    "Mingora",
    "Dera Ghazi Khan",
    "Nawabshah",
    "Sahiwal",
    "Okara",
    "Wah",
    "Dera Ismail Khan",
    "Chiniot",
    "Kamoke",
    "Sadiqabad",
    "Burewala",
    "Jacobabad",
    "Muzaffargarh",
    "Muridke",
    "Jhelum",
    "Shikarpur",
    "Hafizabad",
    "Kohat",
    "Khanewal",
    "Dadu",
    "Gojra",
    "Mandi Bahauddin",
    "Tando Allahyar",
    "Daska",
    "Khairpur",
    "Chishtian",
    "Attock",
    "Vehari",
    "Nowshera",
    "Jalalpur",
    "Mianwali",
   "Nankana Sahib",
    "Kot Addu",
    "Bhakkar",
    "Toba Tek Singh",
    "Shakargarh",
    "Khuzdar",
    "Charsadda",
    "Qadirabad",
    "Chichawatni",
    "Jaranwala",
    'Gujranwala Cantonment',
    "Mansehra",
    "Kamalia",
    "Umerkot",
    "Kotli",
    "Bannu",
    "Loralai",
   "Dera Murad Jamali",
    "Shahr Sultan",
    "Gwadar",
    "Turbat",
    "Hangu",
    "Timargara",
    "Ghotki",
    "Sibi",
    "Jampur",
    "Kambar",
    "Badin",
    "Thatta",
    "Chakwal",
    "Khushab",
    "Kasur",
    "Mian Channu",
    "Samundri",
    "Pasrur",
    "Shujabad",
    "Rajanpur",
    "Mandi Bahauddin",
    "Kot Radha Kishan",
    "Dijkot",
    "Talagang",
    "Tando Adam",
    "Khairpur Nathan Shah",
    "Kabirwala",
    "Tank",
  ];


  @override
  Widget build(BuildContext context) {
    return Consumer<TProviderHelper>(
      builder: (context,provider,child){
        return Container(
          height: 60,
          width: double.infinity,
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: TColors.primaryColor,
            ),
          ),
          child: DropdownButton(
            dropdownColor: TColors.white,
            padding: EdgeInsets.symmetric(horizontal: 10),
            hint: Text("Select City"),
            iconEnabledColor: TColors.primaryColor,
            value: provider.selectCity,
            isExpanded: true,
            items: city.map((String cityName){
              return DropdownMenuItem<String>(
                value: cityName,
                child: Text(cityName),
              );
            }).toList(),
            onChanged: (String? value){
              provider.city(value!);
            },
          ),
        );
      },
    );
  }
}
