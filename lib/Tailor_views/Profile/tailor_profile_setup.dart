import 'package:dashboard_new/Model_Classes/tailor_class.dart';
import 'package:dashboard_new/Tailor_views/Profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TailorProfileSetupPage extends StatelessWidget {
  final Tailor tailor;

  const TailorProfileSetupPage({super.key, required this.tailor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transparent container to intercept clicks outside the dialog
        GestureDetector(
          onTap: () {}, // Prevent clicks from propagating
          child: Container(
            color: Colors.black54, // Semi-transparent color
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Center the AlertDialog
        Center(
          child: AlertDialog(
            title: const Text('Setup Profile'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome ${tailor.name}!',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Please set up your profile',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Perform profile setup actions
                    Navigator.of(context).pop(); // Close the dialog
                    Get.off(() => const EditProfilePage());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // text color
                  ),
                  child: const Text('Setup Profile'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
