


import 'package:flutter/material.dart';

class AppointementDetail extends StatefulWidget {
  const AppointementDetail({super.key});

  @override
  State<AppointementDetail> createState() => _AppointementDetailState();
}

class _AppointementDetailState extends State<AppointementDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointement Detail"),
      ),
    );
  }
}
