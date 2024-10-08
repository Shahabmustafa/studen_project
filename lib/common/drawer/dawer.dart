import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_service_finder/common/button/custom_button.dart';
import 'package:local_service_finder/utils/helper/helper.dart';
import 'package:local_service_finder/view/authentication/form/seller_form_screen.dart';
import 'package:local_service_finder/view/authentication/login/login_view.dart';
import 'package:local_service_finder/view/customer/drawer/appointment/appointment.dart';
import 'package:local_service_finder/view/customer/drawer/categories/categories.dart';
import 'package:local_service_finder/view/customer/drawer/favourite/favourite.dart';
import 'package:local_service_finder/view/customer/drawer/home/map.dart';
import 'package:local_service_finder/view/customer/drawer/notifiction/customer_notification_screen.dart';
import 'package:local_service_finder/view/customer/drawer/profile/profile.dart';
import 'package:local_service_finder/viewmodel/authentication/authentication_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../utils/constant/colors.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final changePassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUnreadNotificationCount();
  }

  int unreadCount = 0;

  // Fetch the unread appointment count from Firestore
  void _getUnreadNotificationCount() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('appotiment')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        unreadCount = snapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: TColors.primaryColor,
                  ),
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      imageUrl: data["profileImage"],
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: TColors.primaryColor,)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  accountName: Text(
                    data["userName"],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  accountEmail: Text(
                    data["email"],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Iconsax.home),
                  title: const Text("Home"),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MapScreen()),
                    );
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.category),
                  title: const Text("Categories"),
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text("Favourite"),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FavouriteScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.calendar),
                  title: const Text("Appointments"),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentScreen()));
                  },
                ),
                ListTile(
                  leading: Stack(
                    children: [
                      const Icon(Iconsax.notification),  // Base notification icon
                      if (unreadCount > 0)               // Show badge if there are unread notifications
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: const Text("Notification"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.person),
                  title: const Text("Profile"),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  },
                ),
                ExpansionTile(
                  leading: const Icon(Iconsax.setting),
                  title: const Text("Setting"),
                  children: [
                    ListTile(
                      leading: const Icon(Iconsax.password_check),
                      title: const Text("Password Change"),
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (context){
                            return Consumer<AuthenticationViewModel>(
                              builder: (context,value,child){
                                return AlertDialog(
                                  title: const Text("Change Password"),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: changePassword,
                                        decoration: const InputDecoration(
                                            hintText: "Change Passowrd"
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: (){
                                              if(changePassword.text.length < 8){
                                                THelper.toastMessage("Please Enter Minimum 8 Digits");
                                              }else{
                                                value.passwordChange(context, changePassword.text.trim());
                                              }
                                            },
                                            child: const Text("Change"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const ListTile(
                      leading: Icon(Iconsax.document),
                      title: Text("About us"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.help_outline),
                      title: Text("Help"),
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Iconsax.convert),
                  title: const Text("Switch to Seller"),
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: const Text("You Want Convert Account To Seller"),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomButton(
                                hint: "No",
                                width: 100,
                                height: 30,
                                color: Colors.red,
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                              CustomButton(
                                hint: "Yes",
                                width: 100,
                                height: 30,
                                color: Colors.green,
                                onTap: (){
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerFormScreen()));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.logout_1),
                  title: const Text("Logout"),
                  onTap: ()async{
                    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                      "status" : false,
                    });
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}
