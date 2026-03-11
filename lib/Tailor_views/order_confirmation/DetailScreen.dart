import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:dashboard_new/Tailor_views/home_screen/home.dart';
import 'package:dashboard_new/consts/colors.dart';
import 'package:dashboard_new/consts/styles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DetailScreen extends StatelessWidget {
  final Orderr order;
  final Customer getCustomer;

  const DetailScreen({
    super.key,
    required this.order,
    required this.getCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Add the back arrow icon
          onPressed: () {
            Navigator.of(context).pop(); // Handle the back button press
          },
        ),
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
                'Order Details',
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

        backgroundColor: Colors.red, // Set the background color of the app bar
        elevation: 10, // Adjust the elevation to add drop shadow
        shadowColor: Colors.grey.withOpacity(
          0.5,
        ), // Set the color of the drop shadow
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),
            const SizedBox(height: 20.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: redColor.withOpacity(0.1),
                            spreadRadius: 4,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ), // Set background color to light red
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailItem('Customer Name', getCustomer.name),
                          const SizedBox(height: 10.0),
                          _buildDetailItem('Details of Order', order.details),
                          const SizedBox(height: 10.0),
                          _buildDetailItem('Tailor Type', order.tailorType),
                          const SizedBox(height: 10.0),
                          _buildDetailItem('Price', order.price.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white, // Set background color to white
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: redColor.withOpacity(0.1), // Set shadow color
                      spreadRadius: 4,
                      blurRadius: 2,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Clothes Images:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      _buildImageSection(order.clothesImageUrls),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Designed Images:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      _buildImageSection(order.designImageUrls),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  acceptOrder(order.expId, order);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: whiteColor,
                  side: const BorderSide(color: redColor),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(fontSize: 16.0, color: redColor),
                ),
              ),
            ),

            const SizedBox(height: 10.0),

            SizedBox(
              width: double.infinity, //150,
              child: ElevatedButton(
                onPressed: () {
                  deleteOrder(order);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: redColor,
                  side: const BorderSide(color: whiteColor),
                ),
                child: const Text(
                  'Decline',
                  style: TextStyle(fontSize: 16.0, color: whiteColor),
                ),
              ),
            ),

            // SizedBox(
            //   width: 150,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       showDialog(
            //           context: context,
            //           builder: (BuildContext context) {
            //             return AlertDialog(
            //               title: Text("Message Tailor"),
            //               content: Text(
            //                   "Only customers can message tailors first."),
            //               actions: [
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.of(context)
            //                         .pop(); // Close the dialog
            //                   },
            //                   child: Text("OK"),
            //                 ),
            //               ],
            //             );
            //           });
            //     },
            //     child: Text(
            //       'Chat',
            //       style: TextStyle(fontSize: 16.0),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: getCustomer.profileImageUrl != " "
                ? NetworkImage(getCustomer.profileImageUrl)
                : null,
            child: getCustomer.profileImageUrl == " "
                ? const Icon(Icons.person)
                : null,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          getCustomer.name,
          style: const TextStyle(fontSize: 26.0, fontFamily: bold),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Text(value, style: const TextStyle(fontSize: 16.0)),
      ],
    );
  }

  Widget _buildImageSection(List<String> imageUrls) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showImageDialog(context, imageUrls[index]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrls[index],
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: Image.network(imageUrl));
      },
    );
  }

  Future<void> acceptOrder(String tailorId, Orderr order) async {
    String orderId =
        order.getDocumentId() ?? ''; // Retrieve the document ID from Orderr
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'tailorId': tailorId,
      'status': 'Running',
      'expectedTailorId': "",
    });

    Get.offAll(() => const Home_Tailor());
  }

  Future<void> deleteOrder(Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    Get.offAll(() => const Home_Tailor());
  }
}
