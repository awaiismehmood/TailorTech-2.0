import 'package:dashboard_new/Customer_views/Profile/order_content.dart';
import 'package:dashboard_new/Customer_views/measurements/showMeasure.dart';
import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/Customer_views/services/chatt/chat_home.dart';
import 'package:dashboard_new/view/support.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreenCustomer extends StatefulWidget {
  final Customer customer;
  const ProfileScreenCustomer({required this.customer, super.key});
  @override
  _ProfileScreenCustomerState createState() => _ProfileScreenCustomerState();
}

class _ProfileScreenCustomerState extends State<ProfileScreenCustomer> {
  var controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: redColor, // Red app bar background color
          elevation: 10, // Add elevation for drop shadow
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white70, // You can change the border color here
                  width: 2.0, // You can adjust the border width here
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
                    color: Colors.white, // Set the background color to white
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: widget.customer.profileImageUrl != " "
                            ? NetworkImage(widget.customer.profileImageUrl)
                            : null,
                        child: widget.customer.profileImageUrl == " "
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        widget.customer.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        widget.customer.email,
                        style: const TextStyle(fontSize: 14),
                      ),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.edit),
                      //   onPressed: () {
                      //     // EditProfileScreen(tailor: widget.tailor);
                      //   },
                      // ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
                  const SizedBox(height: 10), // Reduced the space
                  // New "View My History" section
                  Card(
                    color: whiteColor, // Set the background color to white
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
                        // Sample content for history can be added here
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
                        // ListTile(
                        //   title: Text(
                        //     'CNIC',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 14,
                        //     ),
                        //   ),
                        //   subtitle: Text(
                        //     widget.customer.cnic,
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //     ),
                        //   ),
                        // ),
                        ListTile(
                          title: const Text(
                            'Phone Number',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            widget.customer.phone,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        // ListTile(
                        //   title: Text(
                        //     'Rating',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 14,
                        //     ),
                        //   ),
                        //   subtitle: Row(
                        //     children: [
                        //       RatingBar(
                        //         rating: _rating,
                        //         onRatingChanged: (rating) {
                        //           setState(() {
                        //             _rating = rating;
                        //           });
                        //         },
                        //       ),
                        //       SizedBox(width: 10),
                        //       Text(
                        //         '$_rating',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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

                            // Add functionality for Chat
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
                            controller.signoutMethod(context);
                            controller.dispose();
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
