import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Customer_views/Profile/customer_profile.dart';
import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/consts/colors.dart';
import 'package:dashboard_new/consts/firebase_const.dart';
import 'package:dashboard_new/Customer_views/home_screen/home_screen.dart';
import 'package:dashboard_new/controllers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Customer? customer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        if (mounted) {
          setState(() {
            customer = Customer.fromFirestore(doc);
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        debugPrint('Customer not found.');
      }
    } catch (e) {
      debugPrint("Error fetching customer: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currNavIndex = ref.watch(customerHomeIndexProvider);

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

    if (isLoading || customer == null) {
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
        HomePage(customer: customer!),
        ProfileScreenCustomer(customer: customer!),
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
                ref.read(customerHomeIndexProvider.notifier).setIndex(value);
              },
            ),
          ),
        ),
      );
    }
  }
}
