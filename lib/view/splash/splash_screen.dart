import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_service_finder/viewmodel/splash/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  /// yaha mana splash controller leya ha jo viewmodel ma ha
  SplashService splashService = SplashService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /// yaha initstate ma ya check karta ha ka konse screen per jaye
    /// jab wo seller ho to seller screen pa jaye ga
    splashService.checkUserType(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/logo/logo.png",
              height: 200,
              width: 200,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Local Services Finder",
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
