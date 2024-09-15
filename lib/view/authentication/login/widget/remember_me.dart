import 'package:flutter/material.dart';
import 'package:local_service_finder/utils/constant/colors.dart';

import '../../forget/forgetpassword_view.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPassword()));
          },
          child: const Text(
            "Forget Password",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16
            ),
          ),
        )
      ],
    );
  }
}
