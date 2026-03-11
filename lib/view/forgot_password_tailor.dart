import 'package:dashboard_new/consts/colors.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class ForgotPassword_t extends StatefulWidget {
  const ForgotPassword_t({super.key});

  @override
  State<ForgotPassword_t> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword_t> {
  final _email = TextEditingController();
  final _auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        elevation: 10,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Reset Password',
                style: TextStyle(
                  color: whiteColor,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image with low opacity
          Opacity(
            opacity: 0.4, // Adjust opacity as needed
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/forgot.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Enter Your E-mail",
                    style: TextStyle(
                      color: redColor,
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Colors.red.withOpacity(0.8)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String email = _email.text.trim();
                    if (email.isNotEmpty) {
                      try {
                        await _auth.sendPasswordReset(email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Password reset email sent to $email',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    backgroundColor: redColor,
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                  child: const Text(
                    'Send E-mail',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
