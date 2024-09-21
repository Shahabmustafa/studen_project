import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/app.dart';

import 'firebase_options.dart';

void main()async{
  /// initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    App(),
  );
}




