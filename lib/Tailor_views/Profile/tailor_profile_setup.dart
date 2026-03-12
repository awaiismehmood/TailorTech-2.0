import 'package:dashboard_new/Model_Classes/tailor_class.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TailorProfileSetupPage extends ConsumerWidget {
  final Tailor tailor;

  const TailorProfileSetupPage({super.key, required this.tailor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            color: Colors.black54,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
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
                    Navigator.of(context).pop();
                    context.go(AppRoutes.tailorEditProfile);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
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
