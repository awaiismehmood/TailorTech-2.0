import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:dashboard_new/consts/colors.dart';
import 'package:dashboard_new/consts/firebase_const.dart';
import 'package:dashboard_new/consts/styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'sample_item_details_view.dart';

enum OrderStatus { all, completed, Running }

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderStatus _selectedStatus = OrderStatus.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
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
        backgroundColor: redColor,
        actions: const [
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     // Navigator.restorablePushNamed(context, SettingsView.routeName);
          //   },
          // ),
        ],
      ),
      body: Stack(
        children: [
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterButton('All', OrderStatus.all),
                    _buildFilterButton('Completed', OrderStatus.completed),
                    _buildFilterButton('In Process', OrderStatus.Running),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .snapshots(),
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<Orderr> orders = snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                              return Orderr.fromDocument(document);
                            })
                            .where(
                              (orders) => orders.tailorId == currentUser?.uid,
                            )
                            .toList();

                        List<Orderr> filteredOrders = _filterOrders(orders);

                        return ListView.builder(
                          itemCount: filteredOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            final order = filteredOrders[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  'Order ID: ${order.getDocumentId()}',
                                ),
                                subtitle: Text(order.details),
                                trailing: Text('Status: ${order.status}'),
                                onTap: () {
                                  if (order.status != 'completed') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SampleItemDetailsView(
                                              isTailor: true,
                                              order: order,
                                            ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Orderr> _filterOrders(List<Orderr> orders) {
    if (_selectedStatus == OrderStatus.all) {
      return orders;
    } else {
      return orders
          .where((order) => order.status == _statusToString(_selectedStatus))
          .toList();
    }
  }

  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.Running:
        return 'Running';
      default:
        return '';
    }
  }

  Widget _buildFilterButton(String label, OrderStatus status) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedStatus == status ? redColor : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _selectedStatus == status ? whiteColor : redColor,
          fontFamily: semibold,
        ),
      ),
    );
  }
}
