import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/constant/colors.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    required this.location,
    required this.serviceText,
    required this.imageUrl,
    required this.userName,
    required this.likes,
    this.onPressed,
    this.onTap,
    this.icon,
    super.key,
  });

  final String location;
  final String serviceText;
  final String imageUrl;
  final String userName;
  final String likes;
  final IconData? icon;
  final void Function()? onPressed;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: CachedNetworkImage(
            height: 50,
            width: 50,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(child: CircularProgressIndicator(color: TColors.primaryColor,)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(userName,style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600),),
        subtitle: Text(
          serviceText,
          style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400),
        ),
        trailing: Column(
          children: [
            GestureDetector(
              onTap: onPressed,
              child: Icon(icon,color: TColors.primaryColor,),
            ),
            Text(likes),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
