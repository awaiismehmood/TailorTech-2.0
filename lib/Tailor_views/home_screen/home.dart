import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/tailor_class.dart';
import 'package:dashboard_new/Tailor_views/home_screen/home_screen.dart';
import 'package:dashboard_new/controllers/home_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/Tailor_views/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:geolocator/geolocator.dart';

class Home_Tailor extends ConsumerStatefulWidget {
  const Home_Tailor({super.key});

  @override
  ConsumerState<Home_Tailor> createState() => _Home_TailorState();
}

class _Home_TailorState extends ConsumerState<Home_Tailor> {
  Tailor? tailor;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    getLocationUpdates();
  }

  void fetchData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(usersCollection1)
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        if (mounted) {
          setState(() {
            tailor = Tailor.fromFirestore1(doc);
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        debugPrint('Tailor not found.');
      }
    } catch (e) {
      debugPrint("Error fetching tailor: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currNavIndex = ref.watch(tailorHomeIndexProvider);

    const navBarItem = [
      GButton(
        icon: Icons.dashboard,
        text: "Dashboard",
      ),
      GButton(
        icon: Icons.person_off_outlined,
        text: "Profile",
      ),
    ];

    if (isLoading || tailor == null) {
      return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/iconWhite.jpeg', width: 60, height: 60),
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
      final navBody = [
        HomePage_Tailor(tailor: tailor!),
        EditProfileScreen(tailor: tailor!),
      ];

      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Expanded(
              child: navBody.elementAt(currNavIndex),
            )
          ],
        ),
        bottomNavigationBar: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 2),
            child: GNav(
              rippleColor: redColor,
              hoverColor: Colors.white,
              tabBorderRadius: 30,
              selectedIndex: currNavIndex,
              color: Colors.black,
              tabs: navBarItem,
              gap: 8,
              backgroundColor: Colors.transparent,
              activeColor: Colors.black,
              padding: const EdgeInsets.all(16),
              tabBackgroundColor: Colors.black.withOpacity(0.02),
              tabShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                )
              ],
              onTabChange: (value) {
                ref.read(tailorHomeIndexProvider.notifier).setIndex(value);
              },
            ),
          ),
        ),
      );
    }
  }

  Future<void> getLocationUpdates() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Geolocator.getPositionStream().listen((Position currentLocation) async {
        if (mounted) {
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
    }
  }
}
