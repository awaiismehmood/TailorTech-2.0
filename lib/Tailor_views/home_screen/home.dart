import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/tailor_class.dart';
// import 'package:dashboard_new/Tailor_views/Profile/profilepage.dart';
import 'package:dashboard_new/Tailor_views/home_screen/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/Tailor_views/Profile/profile.dart';
//import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import '../../controllers/home_controller.dart';

// ignore: camel_case_types
class Home_Tailor extends StatefulWidget {
  const Home_Tailor({super.key});

  @override
  State<Home_Tailor> createState() => _Home_TailorState();
}

class _Home_TailorState extends State<Home_Tailor> {
  late Tailor tailor;
  var controller = Get.put(AuthController());
  // final Location _locationController = Location();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    getLocationUpdates();
  }

  void fetchData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(usersCollection1)
        .doc(currentUser!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        tailor = Tailor.fromFirestore1(doc);
        isLoading = false;
        print("Location:");
        print(tailor.latitude);
      });
    } else {
      isLoading = false;
      print('Tailor not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController1());
    var navBarItem = [
      const GButton(
        icon: Icons.dashboard,
        text: "Dashboard",
      ),
      const GButton(
        icon: Icons.person_off_outlined,
        text: "Profile",
      ),
    ];

    if (isLoading) {
      // Show loading indicator while data is being fetched
      return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/iconWhite.jpeg', width: 60, height: 60),
            // Loading indicator overlay
            if (isLoading)
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(
                  child: SpinKitPulse(
                    color: redColor,
                    size: 100.0,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      var navBody = [
        HomePage_Tailor(
          tailor: tailor,
        ),
        EditProfileScreen(
          tailor: tailor,
        ),
      ];
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Obx(() => Expanded(
                  child: navBody.elementAt(controller.currNavIndex.value),
                ))
          ],
        ),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 30, color: Colors.black.withOpacity(0.3))
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 2),
              child: GNav(
                rippleColor: redColor,
                hoverColor: Colors.white,
                tabBorderRadius: 30,
                selectedIndex: controller.currNavIndex.value,
                color: Colors.black,
                tabs: navBarItem,
                gap: 8,
                backgroundColor: Colors.transparent,
                // tabMargin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                activeColor: Colors.black,
                padding: const EdgeInsets.all(16),
                tabBackgroundColor: Colors.black.withOpacity(0.02),
                tabShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                  )
                ],
                onTabChange: (value) {
                  controller.currNavIndex.value = value;
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> getLocationUpdates() async {
    try {
      log("in try");

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log("Location services are disabled.");
        return;
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      log("Permission status: $permission");

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        log("Permission status after request: $permission");
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      try {
        Position initialLocation = await Geolocator.getCurrentPosition();
        log("Initial location: $initialLocation");
      } catch (e) {
        log("Error getting initial location: $e");
        // Handle error accordingly...
      }
      // Listen for location changes
      Geolocator.getPositionStream().listen((Position currentLocation) async {
        log("Location update received: $currentLocation");
        // ignore: unnecessary_null_comparison
        if (currentLocation.latitude != null &&
            // ignore: unnecessary_null_comparison
            currentLocation.longitude != null) {
          CollectionReference collection =
              FirebaseFirestore.instance.collection(usersCollection1);
          await collection.doc(currentUser!.uid).update({
            'longitude': currentLocation.longitude,
            'latitude': currentLocation.latitude,
          });
        }
      });
    } catch (e) {
      log("Error getting location: $e");
      // Handle error accordingly...
    }
  }
}
