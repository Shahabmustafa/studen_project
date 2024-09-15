import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  final String title;
  final String subTitle;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: TColors.primaryColor,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: TColors.black,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onPressed: onPressed,
          child: Text(subTitle),
        )
      ],
    );
  }
}
