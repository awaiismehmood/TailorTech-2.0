import 'package:dashboard_new/consts/colors.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class VerifyUser extends StatelessWidget {
  const VerifyUser({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Please Verify",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "For security reasons, please verify your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => controller.signoutMethod(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: whiteColor,
                  backgroundColor: Colors.red, // Text color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
