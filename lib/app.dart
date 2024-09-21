import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/helper/image_picker.dart';
import 'package:local_service_finder/utils/helper/provider_helper.dart';
import 'package:local_service_finder/utils/theme/theme.dart';
import 'package:local_service_finder/view/splash/splash_screen.dart';
import 'package:local_service_finder/viewmodel/authentication/authentication_viewmodel.dart';
import 'package:local_service_finder/viewmodel/profileupdate/profile_update_viewmodel.dart';
import 'package:local_service_finder/viewmodel/user/seller_form_viewmodel.dart';
import 'package:local_service_finder/viewmodel/user/user_viewmodel.dart';
import 'package:provider/provider.dart';
/// fast of all pahla ya page run hota ha

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TProviderHelper()),
        ChangeNotifierProvider(create: (_) => ImagePickerProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationViewModel()),
        ChangeNotifierProvider(create: (_) => SellerFormViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileUpdateViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()..getUsers()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Local Service Finder',
        theme: TTheme.lightTheme,
        home: SplashScreen(),
      ),
    );
  }
}
