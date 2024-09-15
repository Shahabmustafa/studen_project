import 'package:flutter/material.dart';
import 'package:local_service_finder/view/authentication/login/widget/button_button.dart';
import 'package:local_service_finder/view/authentication/login/widget/login_form.dart';
import 'package:local_service_finder/view/authentication/login/widget/remember_me.dart';
import 'package:local_service_finder/view/authentication/signup/signup_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              /// logo
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const Image(
                  image: AssetImage("assets/logo/logo.png"),
                  height: 200,
                  width: 200,
                ),
              ),
        
              const SizedBox(
                height: 20,
              ),
        
              /// Form
              LoginForm(),

              const SizedBox(
                height: 20,
              ),
        
              /// forget password and remember me
              const RememberMe(),

              const SizedBox(
                height: 20,
              ),
        
              /// go to login screen  to signup screen
              BottomButton(
                title: "Don't have any account?",
                subTitle: "SignUp",
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

