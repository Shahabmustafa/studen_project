import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_service_finder/utils/helper/helper.dart';

class ProfileUpdateViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  File? image;
  ImagePicker imagePicker = ImagePicker();

  pickImage(BuildContext context, ImageSource source) async {
    var pick = await imagePicker.pickImage(source: source);
    if (pick!.path.isNotEmpty) {
      image = File(pick.path.toString());
      uploadImage(context);
      Navigator.pop(context);
      notifyListeners();
    } else {
      THelper.errorMessage(context, "Please Select Image");
    }
  }

  void uploadImage(BuildContext context) async {
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref('profileImage${FirebaseAuth.instance.currentUser!.uid}');
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newUrl = await storageRef.getDownloadURL();

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'profileImage': newUrl.toString(),
    }).then((value) {
      THelper.successMessage(context, 'Update Peofile');
      image = null;
    }).onError((error, stackTrace) {
      THelper.errorMessage(context, error.toString());
    });
  }

  /// calculate rating for stars
  Future<List?> calculateAverageRating(String userId) async {
    List<double> ratings = [];
    try {
      // Get the specific ratings collection inside the appointmentId documents
      var specificRatings = await FirebaseFirestore.instance
          .collection('ratings')
          .doc(userId)
          .collection('specificRating')
          .get()
          .then((value) {
        for (var ratingDoc in value.docs) {
          ratings.add(ratingDoc['rating value']); // Extract the rating value
        }
      });

      if (ratings.isNotEmpty) {
        double sum = ratings.reduce((a, b) => a + b);
        double averageRating = sum / ratings.length;
        print(averageRating);
        return [averageRating, ratings.length]; // Return average and count
      }
    } catch (error) {
      print("Error while calculating review stars: $error");
    }
    return [0.0, 0]; // Return default if no ratings found
  }
}
