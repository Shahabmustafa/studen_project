import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_service_finder/utils/constant/colors.dart';

class THelper{
  THelper._();

  /// successMessage
  static successMessage(context,String message){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ListTile(
          leading: Icon(
            CupertinoIcons.checkmark_alt_circle_fill,
            color: TColors.green,
          ),
          title: Text(
            "Success",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: TColors.white,
        dismissDirection: DismissDirection.horizontal,
        elevation: 5,
        shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }


  /// errorMessage
  static errorMessage(context,String message){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ListTile(
          leading: Icon(
            CupertinoIcons.clear_circled_solid,
            color: TColors.red,
          ),
          title: Text(
            "Error",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: TColors.white,
        dismissDirection: DismissDirection.horizontal,
        elevation: 5,
        shape: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static dialogAlert(context,VoidCallback onTapForGallery,VoidCallback onTapForCamera){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text("Pick Image",),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Iconsax.camera),
                title: Text(
                  "Camera",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Pick Image to Camera",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: onTapForCamera,
              ),
              ListTile(
                leading: const Icon(Iconsax.gallery),
                title: Text(
                  "Gallery",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Pick Image to Gallery",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: onTapForGallery,
              ),
            ],
          ),
        );
      },
    );
  }


  static toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}