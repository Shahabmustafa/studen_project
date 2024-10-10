import 'package:flutter/cupertino.dart';
import 'package:local_service_finder/utils/constant/colors.dart';

class ImageAvatar extends StatelessWidget {
  const ImageAvatar({
    super.key,
    required this.onTap,
    required this.image,
  });
  final VoidCallback onTap;
  final ImageProvider<Object> image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image,
            ),
            color: TColors.blueAccentShade200,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: TColors.primaryColor,
              width: 4,
            ),
          ),
        ),
      ),
    );
  }
}
