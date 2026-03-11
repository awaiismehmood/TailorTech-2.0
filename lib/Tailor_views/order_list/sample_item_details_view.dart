import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Customer_views/home_screen/home.dart';
import 'package:dashboard_new/Customer_views/measurements/showMeasure.dart';
import 'package:dashboard_new/Customer_views/services/chatt/chat_home.dart';
import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:dashboard_new/Tailor_views/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class SampleItemDetailsView extends StatefulWidget {
  final Orderr order;
  final bool isTailor;

  const SampleItemDetailsView(
      {super.key, required this.order, required this.isTailor});

  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  late Customer getCustomer;
  bool _isLoading = true;

  @override
  void initState() {
    getCustomerData(widget.order.customerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: redColor,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading == true
            ? const SpinKitPulse(
                color: Colors.red,
                size: 100.0,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserProfile(),
                  const SizedBox(height: 20.0),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Set width to screen width
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
                                _buildDetailItem(
                                    'Customer Name', getCustomer.name),
                                const SizedBox(height: 10.0),
                                _buildDetailItem(
                                    'Details of Order', widget.order.details),
                                const SizedBox(height: 10.0),
                                _buildDetailItem(
                                    'Tailor Type', widget.order.tailorType),
                                const SizedBox(height: 10.0),
                                _buildDetailItem(
                                    'Price', widget.order.price.toString()),
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
                            color:
                                redColor.withOpacity(0.1), // Set shadow color
                            spreadRadius: 4,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 2), // changes position of shadow
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
                            _buildImageSection(widget.order.clothesImageUrls),
                            const SizedBox(height: 20.0),
                            const Text(
                              'Designed Images:',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            _buildImageSection(widget.order.designImageUrls),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     SizedBox(
                  //       width: 150,
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           deleteOrder(widget.order);
                  //         },
                  //         child: Text(
                  //           'Decline',
                  //           style: TextStyle(fontSize: 16.0),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 150,
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           // Handle button tap
                  //         },
                  //         child: Text(
                  //           'Chat',
                  //           style: TextStyle(fontSize: 16.0),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 10.0),
                  button(),
                ],
              ),
      ),
    );
  }

  Widget button() {
    if (widget.isTailor == true) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  CompleteOrder(widget.order.expId, widget.order);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: whiteColor,
                  side: const BorderSide(color: redColor),
                ),
                child: const Text(
                  'Complete',
                  style: TextStyle(fontSize: 16.0, color: redColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => showMeasure(
                              id: widget.order.customerId, isCustomer: false)));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: whiteColor,
                  side: const BorderSide(color: redColor),
                ),
                child: const Text(
                  'View Mesaurements',
                  style: TextStyle(fontSize: 16.0, color: redColor),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // Assuming you have the tailor's ID available
                    String? tailorId = widget.order.tailorId;
                    // Get the current customer's ID
                    String customerId = currentUser!.uid;
                    // Add tailor's ID to the customer's chat list
                    log("customer ID $customerId");
                    log("tailorid $tailorId");
                    await addToChatList(customerId, tailorId!);
                    // Navigate to the chat page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => chatHome()));
                  } catch (e) {
                    print("Error: $e");
                    // Handle error
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: whiteColor,
                  side: const BorderSide(color: redColor),
                ),
                child: const Text(
                  'Chat',
                  style: TextStyle(fontSize: 16.0, color: redColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  deleteOrder(widget.order);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: redColor,
                  side: const BorderSide(color: whiteColor),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16.0, color: whiteColor),
                ),
              ),
            ),
          ),
        ],
      );
    }
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
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: const TextStyle(fontSize: 16.0),
        ),
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
        return Dialog(
          child: Image.network(imageUrl),
        );
      },
    );
  }

  Future<void> getCustomerData(String customerId) async {
    try {
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(customerId)
          .get();

      if (customerSnapshot.exists) {
        // If customer exists, update the state with the retrieved data
        setState(() {
          getCustomer = Customer.fromFirestore(customerSnapshot);
          _isLoading = false; // Set loading flag to false
        });
      } else {
        throw Exception('Customer not found');
      }
    } catch (e) {
      // Handle exception if customer not found or any other error occurs
      print(e.toString());
    }
  }

  Future<void> CompleteOrder(String tailorId, Orderr order) async {
    String orderId =
        order.getDocumentId() ?? ''; // Retrieve the document ID from Orderr
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': 'completed',
    });

    Get.offAll(() => const Home_Tailor());
  }

  Future<void> deleteOrder(Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    Get.offAll(() => const Home());
  }

  Future<void> addToChatList(String customerId, String tailorId) async {
    try {
      log("in chat list");
      // Get the current chat list of the customer
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(customerId)
          .get();

      if (customerSnapshot.exists) {
        log("in if");
        // Extract chatList and cast it to List<String>
        List<String> currentChatList = List<String>.from(
            (customerSnapshot.data() as Map<String, dynamic>?)?['chatlist']
                    ?.cast<String>() ??
                []);

        log("curr $currentChatList");

        // Add tailor's ID only if it's not already in the list
        if (!currentChatList.contains(tailorId)) {
          currentChatList.add(tailorId);

          log("current $currentChatList");

          // Update the document with the modified chat list
          await FirebaseFirestore.instance
              .collection(usersCollection)
              .doc(customerId)
              .update({'chatlist': currentChatList});

          addToTailorChatList(customerId, tailorId);
          log("current chat list$currentChatList");
        }
      } else {
        throw Exception('Customer not found');
      }
    } catch (e) {
      print(e.toString());
      rethrow; // Re-throw the exception for handling in calling function
    }
  }

  Future<void> addToTailorChatList(String customerId, String tailorId) async {
    try {
      // Get the current chat list of the customer
      DocumentSnapshot TailorSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection1)
          .doc(tailorId)
          .get();

      if (TailorSnapshot.exists) {
        // Extract chatList and cast it to List<String>
        List<String> currentChatList = List<String>.from(
            (TailorSnapshot.data() as Map<String, dynamic>?)?['chatlist']
                    ?.cast<String>() ??
                []);

        log("current chat list");

        // Add tailor's ID only if it's not already in the list
        if (!currentChatList.contains(customerId)) {
          currentChatList.add(customerId);

          // Update the document with the modified chat list
          await FirebaseFirestore.instance
              .collection(usersCollection1)
              .doc(tailorId)
              .update({'chatlist': currentChatList});
        }
      } else {
        throw Exception('Customer not found');
      }
    } catch (e) {
      print(e.toString());
      rethrow; // Re-throw the exception for handling in calling function
    }
  }
}
