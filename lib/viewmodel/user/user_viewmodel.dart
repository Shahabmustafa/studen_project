import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_service_finder/model/usermodel/user_model.dart';
import 'package:local_service_finder/utils/helper/firebasefirestore_helper.dart';
import 'package:local_service_finder/view/authentication/form/seller_form_screen.dart';

import '../../utils/helper/local_helper.dart';
import '../../view/customer/drawer/home/map.dart';

class UserViewModel with ChangeNotifier{


  addUserData(context,String userId,String userName,String email,String type,String location)async{
    try{

      String token = await TLocalHelper.token();

      UserModel userModel = UserModel(
        userId: userId,
        email: email,
        profileImage: "https://i.pinimg.com/474x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg",
        createAccount: DateTime.now(),
        status: true,
        token: token,
        userName: userName,
        likes: [],
        favourite: [],
        type: type,
        location: location,
        messageList: [],
        form: type == 'Seller' ? false : true,
      );

      await TFirebaseFireStoreHelper.userSet(userModel.toJson(),userId);
      if(type == "Seller"){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerFormScreen()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
      }
    }on FirebaseException {

    }
  }

  List<UserModel> userModels = [];

  Future<void> getUsers() async {
    final res = await FirebaseFirestore.instance.collection("users").get();
    userModels = res.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    notifyListeners();
  }

  void initState(){
    getUsers();
  }
}