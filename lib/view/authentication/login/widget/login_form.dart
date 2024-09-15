import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_service_finder/utils/helper/helper.dart';
import 'package:local_service_finder/utils/validation/validation.dart';
import 'package:local_service_finder/viewmodel/authentication/authentication_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../common/button/custom_button.dart';

class LoginForm extends StatefulWidget {
  LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthenticationViewModel>(context);
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Email textField
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
          restorationId: "asasas",
            validator: (value){
              return TValidator.validateEmail(value);
            },
            decoration: InputDecoration(
              hintText: "Email",
              hintFadeDuration: Duration(seconds: 1),
              prefixIcon: const Icon(CupertinoIcons.mail),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          /// password textField
          ValueListenableBuilder<bool>(
              valueListenable: _obscurePassword,
              builder: (context, value, _) {
                return TextFormField(
                  controller: password,
                  obscureText: _obscurePassword.value,
                  autofocus: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value){
                    return value!.isEmpty ? "Enter Password" :
                    value.length < 8 ? "Enter Password Minimum 8 Digits" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintFadeDuration: Duration(seconds: 1),
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
                  onChanged: (value){
                    setState(() {

                    });
                  },
                );
              }
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            hint: "Login",
            width: double.infinity,
            height: 60,
            loading: provider.loading,
            onTap: (){
              if(_key.currentState!.validate()){
                provider.loginAuth(
                  context,
                  email.text,
                  password.text,
                );
              }
            },
          ),

        ],
      ),
    );
  }
}
