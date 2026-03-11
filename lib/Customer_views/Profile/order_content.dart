import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:dashboard_new/Tailor_views/order_list/sample_item_details_view.dart';
import 'package:dashboard_new/widgets_common/rating.dart';
import 'package:flutter/material.dart';

import '../../consts/consts.dart';

enum OrderStatus {
  all,
  completed,
  Running,
  Pending,
}

class customerOrderHistory extends StatefulWidget {
  const customerOrderHistory({super.key});

  @override
  State<customerOrderHistory> createState() => _customerOrderHistoryState();
}

class _customerOrderHistoryState extends State<customerOrderHistory> {
  OrderStatus _selectedStatus = OrderStatus.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                'Order History ',
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterButton('All', OrderStatus.all),
                    _buildFilterButton('Completed', OrderStatus.completed),
                    _buildFilterButton('In Process', OrderStatus.Running),
                    _buildFilterButton("Pending", OrderStatus.Pending),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('orders').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Orderr> orders = snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        return Orderr.fromDocument(document);
                      })
                      .where((orders) => orders.customerId == currentUser?.uid)
                      .toList();

                  List<Orderr> filteredOrders = _filterOrders(orders);

                  return ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (BuildContext context, int index) {
                      final order = filteredOrders[index];
                      return Card(
                        child: ListTile(
                          title: Text('Order ID: ${order.getDocumentId()}'),
                          subtitle: Text(order.details),
                          trailing: Text('Status: ${order.status}'),
                          onTap: () {
                            if (order.status != 'completed') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SampleItemDetailsView(
                                            isTailor: false,
                                            order: order,
                                          )));
                            } else {
                              if (order.ratting == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RatingScreen(
                                              tailorId:
                                                  order.tailorId.toString(),
                                              order: order,
                                            )));
                              }
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
      case OrderStatus.Pending:
        return 'Pending';
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
        backgroundColor: _selectedStatus == status ? redColor : whiteColor,
        side: const BorderSide(color: redColor),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: _selectedStatus == status ? whiteColor : redColor,
            fontFamily: semibold),
      ),
    );
  }
}
