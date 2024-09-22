import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_service_finder/common/button/custom_button.dart';
import 'package:local_service_finder/utils/helper/helper.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:local_service_finder/view/authentication/signup/widget/select_city_dropdown.dart';
import 'package:local_service_finder/view/authentication/signup/widget/usertype_dropdown.dart';
import 'package:local_service_finder/viewmodel/authentication/authentication_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../utils/constant/colors.dart';
import '../login/widget/button_button.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController firstName = TextEditingController();

  TextEditingController lastName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confirmPassword = TextEditingController();

  late Position _currentPosition;

  ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier<bool>(true);

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<String> city = [
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

  String? selectCity;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    final tProvider = Provider.of<AuthenticationViewModel>(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              /// appbar height
              const SizedBox(
                height: kToolbarHeight,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Hi! Signup Your Account",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _key,
               child: Column(
                 children: [
                   Row(
                     children: [
                       Flexible(
                         child: TextFormField(
                           controller: firstName,
                           decoration: InputDecoration(
                             hintText: "First Name",
                             prefixIcon: const Icon(CupertinoIcons.person),
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                             ),
                           ),
                         ),
                       ),
                       const SizedBox(
                         width: 10,
                       ),
                       Flexible(
                         child: TextFormField(
                           controller: lastName,
                           decoration: InputDecoration(
                             hintText: "Last Name",
                             prefixIcon: const Icon(CupertinoIcons.person),
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(
                     height: 15,
                   ),
                   TextFormField(
                     controller: email,
                     validator: (value){
                       return value!.isEmpty ? 'Please Enter Your Email' : null;
                     },
                     decoration: InputDecoration(
                       hintText: "Email",
                       prefixIcon: const Icon(CupertinoIcons.mail),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                     ),
                   ),
                   const SizedBox(
                     height: 15,
                   ),
                   ValueListenableBuilder(
                     valueListenable: _obscurePassword,
                     builder: (context,value,child){
                       return TextFormField(
                         controller: password,
                         obscureText: _obscurePassword.value,
                         validator: (value){
                           return value!.isEmpty ? "Enter Password" :
                           value.length < 8 ? "Enter Password Minimum 8 Digits" : null;
                         },
                         decoration: InputDecoration(
                           hintText: "Password",
                           prefixIcon: const Icon(Iconsax.password_check),
                           suffixIcon: GestureDetector(
                             onTap: (){
                               _obscurePassword.value =! _obscurePassword.value;
                             },
                             child: Icon(
                               _obscurePassword.value ?
                                 Iconsax.key :
                               Iconsax.key1,
                             ),
                           ),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10),
                           ),
                         ),
                       );
                     },
                   ),
                   SizedBox(
                     height: 15,
                   ),
                   ValueListenableBuilder(
                     valueListenable: _obscureConfirmPassword,
                     builder: (context,value,child){
                       return TextFormField(
                         controller: confirmPassword,
                         obscureText: _obscureConfirmPassword.value,
                         validator: (value){
                           return value!.isEmpty ? "Enter Password" : password.text != confirmPassword.text ?
                           "Not Same Confirm Password" :
                           value.length < 8 ? "Enter Password Minimum 8 Digits" : null;
                         },
                         decoration: InputDecoration(
                           hintText: "Confirm Password",
                           prefixIcon: const Icon(Iconsax.password_check),
                           suffixIcon: GestureDetector(
                             onTap: (){
                               _obscureConfirmPassword.value =! _obscureConfirmPassword.value;
                             },
                             child: Icon(
                               _obscureConfirmPassword.value ?
                               Iconsax.key :
                               Iconsax.key1,
                             ),
                           ),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10),
                           ),
                         ),
                       );
                     },
                   ),
                 ],
               ),
             ),
              const SizedBox(
                height: 15,
              ),
              UserTypeDropDown(),
              const SizedBox(
                height: 15,
              ),
              Container(
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
                  value: selectCity,
                  isExpanded: true,
                  items: city.map((String cityName){
                    return DropdownMenuItem<String>(
                      value: cityName,
                      child: Text(cityName),
                    );
                  }).toList(),
                  onChanged: (String? value){
                    setState(() {
                      selectCity = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer<TProviderHelper>(
                builder: (context,provider,child){
                  return CustomButton(
                    hint: "Sign Up",
                    width: double.infinity,
                    height: 60,
                    loading: tProvider.loading,
                    onTap: (){
                     if(_key.currentState!.validate()){
                       tProvider.signUpAuth(
                         context,
                         "${firstName.text} ${lastName.text}",
                         email.text,
                         password.text,
                         provider.type.toString(),
                         selectCity.toString(),
                       );
                     }
                    },
                  );
                },
              ),
              const SizedBox(
                height: 50,
              ),
              BottomButton(
                title: "You have already account?",
                subTitle: "Login",
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

