import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_service_finder/common/button/custom_button.dart';

import '../../../common/bottomnavigatorbar/bottom_navigator_bar.dart';

class ChoseLocationScreen extends StatefulWidget {
  const ChoseLocationScreen({super.key});

  @override
  State<ChoseLocationScreen> createState() => _ChoseLocationScreenState();
}

class _ChoseLocationScreenState extends State<ChoseLocationScreen> {
  late LatLng _markerPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markerPosition = LatLng(32.968600, 70.630035); // Default position
    _markers.add(
      Marker(
        markerId: MarkerId('default_marker'),
        position: _markerPosition,
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _markerPosition = position.target;
      _markers.clear(); // Clear existing markers
      _markers.add(
        Marker(
          markerId: MarkerId('default_marker'),
          position: _markerPosition,
        ),
      );
    });
  }

  void _showMarkerPosition() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Marker Position'),
          content: Text('Latitude: ${_markerPosition.latitude}\nLongitude: ${_markerPosition.longitude}'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>${_markerPosition.longitude} .>>>>>> ${_markerPosition.longitude}");
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _markerPosition,
                zoom: 8,
              ),
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: CustomButton(
              hint: "Show Location",
              width: double.infinity,
              height: 50,
              onTap: ()async{
                FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                  "longitude" : _markerPosition.longitude,
                  "latitude" : _markerPosition.latitude,
                });
                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigatorBarScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
