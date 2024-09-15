import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_service_finder/view/customer/drawer/appointment/accept_appointment.dart';

import '../../../../viewmodel/cureent_location_viewmodel.dart';
import '../../../customer/drawer/appointment/pending_appointement.dart';
import '../../../customer/drawer/home/map.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.initialIndex = 0,super.key});
  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with WidgetsBindingObserver{


  void stateChange(bool status)async{
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "status" : status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    // TODO: implement didChangeAppLifecycleState
    if(state == AppLifecycleState.resumed){
      stateChange(true);
    }else{
      stateChange(false);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
    stateChange(true);
  }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Appointments"),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Text("Accepted"),
              ),
              Tab(
                icon: Text("Pending"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AcceptAppointment(),
            PendingAppointment(),
          ],
        ),
      ),
    );
  }
}