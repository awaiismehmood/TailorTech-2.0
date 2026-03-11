//import 'package:dashboard_new/Permissions/Location_Perm.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/tailor_class.dart';
import 'package:dashboard_new/Tailor_views/Profile/tailor_profile_setup.dart';
//import 'package:dashboard_new/Tailor_views/Profile/tailor_profile_setup.dart';
import 'package:dashboard_new/Tailor_views/order_confirmation/Orders.dart';
import 'package:dashboard_new/Tailor_views/order_list/order_history.dart';
import 'package:dashboard_new/widgets_common/exercise_tile.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: camel_case_types
class HomePage_Tailor extends StatefulWidget {
  final Tailor tailor;
  const HomePage_Tailor({super.key, required this.tailor});

  @override
  State<HomePage_Tailor> createState() => _HomePageTailorState();
}

class _HomePageTailorState extends State<HomePage_Tailor> {
  bool profileSetup = false;
  Future<void> checkProfileSetup() async {
    // // Fetch the tailor document from Firestore
    // var snapshot = await FirebaseFirestore.instance
    //     .collection('tailors')
    //     .doc(currentUser?.uid) // Assuming you have an id field in your Tailor class
    //     .get();

    // // Get the value of profileSetup field
    // bool isProfileSetup = snapshot.get('profileSetup') ?? false;
    setState(() {
      profileSetup = widget.tailor.profileSetup;
    });
  }

  @override
  void initState() {
    checkProfileSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    if (!profileSetup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TailorProfileSetupPage(tailor: widget.tailor);
          },
        );
      });
    }
    return Scaffold(
      // Set the background color to transparent
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgo.png', // Replace with your asset image path
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        // Greeting row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi ${widget.tailor.name}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 250, // Adjust the height as needed
                          width: 300, // Adjust the width as needed
                          child: Lottie.network(
                            "https://lottie.host/fd284540-408b-4dca-9b6b-789aab683b3f/ZzPOpxSu1X.json",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        color: Colors.grey[200], // Adjust opacity as needed
                        child: Center(
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Menu",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Icon(Icons.more_horiz),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: ListView(
                                  children: [
                                    ExerciseTile(
                                      onpress: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const OrderHistory(),
                                          ),
                                        );
                                      },
                                      icon: Icons.list_alt,
                                      exerciseName: "Order List",
                                      numberOfExercises: 10,
                                      color: Colors.orange,
                                    ),
                                    ExerciseTile(
                                      onpress: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const OrderAcceptScreen(),
                                          ),
                                        );
                                      },
                                      icon: Icons.check_circle,
                                      exerciseName: "Order Confirmation",
                                      numberOfExercises: 10,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
