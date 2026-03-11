import 'package:dashboard_new/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: redColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ContactUs(
              dividerColor: redColor,
              logo: const AssetImage('assets/iconWhite.png'),
              email: 'awaiismehmood69@gmail.com',
              companyName: 'TailorTech',
              phoneNumber: '03185444845',
              linkedinURL: 'https://www.linkedin.com/company/tailortech',
              tagLine: 'DRESS TO IMPRESS',
              cardColor: redColor,
              companyColor: Colors.blue,
              companyFontSize: 24,
              textColor: whiteColor,
              dividerThickness: 2,
              taglineColor: redColor,
            ),
          ),
          Container(
            width: double.infinity,
            color: redColor,
            child: TextButton(
              onPressed: () {
                showAboutUsDialog(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'About Us',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Us'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'TailorTech is dedicated to providing high-quality tailoring services.'),
                SizedBox(height: 10),
                Text(
                    'Our mission is to ensure you look your best with perfectly tailored outfits.'),
                SizedBox(height: 10),
                Text('Contact us for more information and support.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
