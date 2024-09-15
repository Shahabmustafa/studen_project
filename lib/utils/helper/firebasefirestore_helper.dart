import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_service_finder/utils/api/firebase/firebase_api.dart';

class TFirebaseFireStoreHelper{

  TFirebaseFireStoreHelper._();

  static userSet(Map<String,dynamic> data,String userId){
    return TFirebaseApi.user.doc(userId).set(data);
  }

  static userUpdate(Map<String,dynamic> data){
    return TFirebaseApi.user.doc(FirebaseAuth.instance.currentUser!.uid).update(data);
  }
}