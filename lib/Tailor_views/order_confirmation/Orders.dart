import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/order_controller.dart';
import 'package:dashboard_new/widgets_common/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class OrderAcceptScreen extends StatefulWidget {
  const OrderAcceptScreen({super.key});

  @override
  State<OrderAcceptScreen> createState() => _OrderAcceptScreenState();
}

class _OrderAcceptScreenState extends State<OrderAcceptScreen> {
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  'Orders',
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

          backgroundColor:
              Colors.red, // Set the background color of the app bar
          elevation: 10, // Adjust the elevation to add drop shadow
          shadowColor:
              Colors.grey.withOpacity(0.5), // Set the color of the drop shadow
        ),
        body: Stack(
          children: [
            // Background image
            Center(
              child: Opacity(
                opacity: 0.6, // Adjust the opacity level as needed
                child: SizedBox(
                  width: 300, // Set the width of the image
                  height: 300, // Set the height of the image
                  child: Image.asset(
                    'assets/images/order_vector.jpg', // Path to your background image asset
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Order list
            const OrderList(),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('expectedTailorId', isEqualTo: currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Center(
              child: SpinKitPulse(
                color: Colors.red,
                size: 100.0,
              ),
            ),
          );
        }
        // Extract orders from the snapshot
        List<Orderr> orders = snapshot.data!.docs
            .map((doc) => Orderr.fromDocument(doc))
            .where((order) => order.expId == currentUser?.uid)
            .toList();
        print(orders);
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return FutureBuilder<Customer>(
              future: getCustomerData(orders[index].customerId),
              builder: (context, customerSnapshot) {
                if (customerSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SpinKitPulse(
                    color: Colors.red,
                    size: 100.0,
                  );
                }
                if (customerSnapshot.hasError) {
                  return Text('Error: ${customerSnapshot.error}');
                }
                Customer customer = customerSnapshot.data!;
                log("Cleared till now");

                return OrderCard(
                  order: orders[index],
                  customer: customer,
                  onRemoveClicked: () {
                    // Remove the clicked card from the list
                    setState(() {
                      orders.removeAt(index);
                    });
                  },
                  acceptOrder: () {
                    acceptOrder(orders[index].expId, orders[index]);
                  },
                  deleteOrder: () {
                    deleteOrder(orders[index]);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Customer> getCustomerData(String customerId) async {
    log("iam in getCustomer DAta");
    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(customerId)
        .get();

    if (customerSnapshot.exists) {
      return Customer.fromFirestore(customerSnapshot);
    } else {
      throw Exception('Customer not found');
    }
  }

  Future<void> acceptOrder(String tailorId, Orderr order) async {
    String orderId =
        order.getDocumentId() ?? ''; // Retrieve the document ID from Orderr
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'tailorId': tailorId,
      'status': 'Running',
      'expectedTailorId': "",
    });
  }

  Future<void> deleteOrder(Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
  }
}
