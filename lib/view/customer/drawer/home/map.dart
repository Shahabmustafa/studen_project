import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_service_finder/common/drawer/dawer.dart';
import 'package:local_service_finder/utils/constant/colors.dart';

import '../../../../viewmodel/cureent_location_viewmodel.dart';
import '../categories/categories_seller_profile.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();


  Set<Marker> _markers = {};

  void fetchLocations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('users').get();
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>; // Get document data
      if (data.containsKey('latitude') && data.containsKey('longitude')) {
        double latitude = data['latitude'];
        double longitude = data['longitude'];
        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(latitude, longitude),
            onTap: () {
              customInfoWindowController.addInfoWindow!(
                Container(
                  height: 60,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        height: 45,
                        width: 45,
                        imageUrl: data["profileImage"],
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: TColors.primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    title: Text(data["userName"]),
                    subtitle: Text(data["selectService"]),
                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesSellerProfile(userId: doc.id)));
                    },
                  ),
                ),
                LatLng(latitude, longitude),
              );
            },
          ),
        );
        setState(() {
          // Update state after adding markers
        });
      }
    }
  }


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
    fetchLocations();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerScreen(),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            markers: Set<Marker>.of(_markers),
            initialCameraPosition: CameraPosition(
              target: LatLng(
                32.968600,
                70.630035,
              ),
              zoom: 4,
            ),
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onTap: (position){
              customInfoWindowController.hideInfoWindow!();
            },
            onMapCreated: (GoogleMapController controller) {
              customInfoWindowController.googleMapController = controller;
            },
            onCameraMove: (position){
              customInfoWindowController.onCameraMove!();
            },
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 80,
            width: 300,
            offset: 35,
          )
        ],
      ),
    );
  }

}

