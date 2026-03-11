import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Customer_views/auth_screen/login_screen.dart';
import 'package:dashboard_new/Customer_views/home_screen/home.dart';
import 'package:dashboard_new/Tailor_views/auth_screen/login_screen.dart';
import 'package:dashboard_new/Tailor_views/home_screen/home.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/widgets_common/icon_button.dart';
import 'package:dashboard_new/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  void checkUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Check in usersCollection (Customers)
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // User is a Customer
          Get.offAll(() => const Home());
        } else {
          // If not found in usersCollection, check in usersCollection1 (Tailors)
          DocumentSnapshot tailorDoc = await FirebaseFirestore.instance
              .collection(usersCollection1)
              .doc(user.uid)
              .get();

          if (tailorDoc.exists) {
            // User is a Tailor
            Get.offAll(() => const Home_Tailor());
          } else {
            // User document does not exist in either collection
            print("User document does not exist in both collections");
            displaySplashScreen();
          }
        }
      } catch (e) {
        // Handle error in fetching user document
        print("Error fetching user document: $e");
        displaySplashScreen();
      }
    } else {
      // If no user is logged in, continue displaying the splash screen
      displaySplashScreen();
    }
  }

  void displaySplashScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            60.heightBox,
            applogoWidget(),
            40.heightBox,
            greeting1.text
                .fontFamily(bold)
                .white
                .fontWeight(FontWeight.bold)
                .size(30)
                .make(),
            greeting2.text
                .fontFamily(bold)
                .white
                .fontWeight(FontWeight.bold)
                .size(30)
                .make(),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButtonn(
                  tit: "Tailor",
                  tit2: "Welcome aboard! Pleasure to have you on our team!",
                  img: tailor,
                  onPress: () {
                    Get.to(() => const LoginScreen_Tailor(type: "Tailor"));
                  },
                ).box.make(),
                20.widthBox,
                IconButtonn(
                  tit: "Customer",
                  tit2: "Welcome! Honored to serve our valued customers!",
                  img: customer,
                  onPress: () {
                    Get.to(() => const LoginScreen(
                          type: "Customer",
                        ));
                  },
                ),
              ],
            ),
            const Spacer(),
            appversion.text.white.fontFamily(semibold).make(),
            30.heightBox,
          ],
        ),
      ),
    );
  }
}
