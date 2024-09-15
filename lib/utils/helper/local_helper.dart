import 'package:local_service_finder/utils/api/firebase/firebase_api.dart';

class TLocalHelper{

  TLocalHelper._();

  static token()async{
     final token = await TFirebaseApi.firebaseMessaging.getToken();
     return token;
  }

}