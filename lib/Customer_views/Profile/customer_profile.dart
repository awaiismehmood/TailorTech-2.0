import 'package:dashboard_new/Customer_views/Profile/order_content.dart';
import 'package:dashboard_new/Customer_views/measurements/showMeasure.dart';
import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_provider.dart';
import 'package:dashboard_new/Customer_views/services/chatt/chat_home.dart';
import 'package:dashboard_new/view/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreenCustomer extends ConsumerWidget {
  final Customer customer;
  const ProfileScreenCustomer({required this.customer, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        elevation: 10,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white70,
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'My Profile ',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: whiteColor,
          ),
          child: SafeArea(
            child: ListView(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: customer.profileImageUrl != " "
                          ? NetworkImage(customer.profileImageUrl)
                          : null,
                      child: customer.profileImageUrl == " "
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      customer.email,
                      style: const TextStyle(fontSize: 14),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: whiteColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        tileColor: redColor,
                        title: Text(
                          'View My History',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const customerOrderHistory()));
                        },
                        title: const Text(
                          'History Content',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        tileColor: redColor,
                        title: Text(
                          'Measurements',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: whiteColor),
                        ),
                      ),
                      ListTile(
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => showMeasure(
                                        id: currentUser!.uid,
                                        isCustomer: true,
                                      )));
                        }),
                        title: const Text(
                          "Click to View Measurements",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        tileColor: redColor,
                        title: Text(
                          'Account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: whiteColor),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          customer.phone,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        tileColor: redColor,
                        title: Text(
                          'Settings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: whiteColor),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.chat),
                        title: const Text(
                          'Chat',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => chatHome()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.question_mark_rounded),
                        title: const Text(
                          'Help and Support',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HelpAndSupportScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          ref.read(authProvider.notifier).signOut(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class RatingBar extends StatelessWidget {
//   final double rating;
//   final Function(double) onRatingChanged;
//   RatingBar({required this.rating, required this.onRatingChanged});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(Icons.star, color: rating >= 1 ? Colors.red : Colors.grey),
//         Icon(Icons.star, color: rating >= 2 ? Colors.red : Colors.grey),
//         Icon(Icons.star, color: rating >= 3 ? Colors.red : Colors.grey),
//         Icon(Icons.star, color: rating >= 4 ? Colors.red : Colors.grey),
//         Icon(Icons.star, color: rating == 5 ? Colors.red : Colors.grey),
//       ],
//     );
//   }
// }
