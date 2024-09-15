import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.hint,
    required this.width,
    required this.height,
    this.loading = false,
    required this.onTap,
    this.color,
    super.key});

  final String hint;
  final double height;
  final double width;
  final bool loading;
  final Color? color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? TColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: loading ?
        Center(child: CircularProgressIndicator(color: Colors.white,)) :
        Center(
          child: Text(
            hint,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: TColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
