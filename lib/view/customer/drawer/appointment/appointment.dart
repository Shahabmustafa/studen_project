import 'package:flutter/material.dart';
import 'package:local_service_finder/common/drawer/dawer.dart';
import 'package:local_service_finder/view/customer/drawer/appointment/accept_appointment.dart';
import 'package:local_service_finder/view/customer/drawer/appointment/pending_appointement.dart';

class AppointmentScreen extends StatefulWidget {
  AppointmentScreen({this.appotimentId,super.key});
  String? appotimentId;
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Appointments"),
          bottom: const TabBar(
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
        drawer: DrawerScreen(),
        body: TabBarView(
          children: [
            AcceptAppointment(appotimentId: widget.appotimentId,),
            PendingAppointment(appotimentId: widget.appotimentId,),
          ],
        ),
      ),
    );
  }
}