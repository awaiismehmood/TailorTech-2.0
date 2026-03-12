import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/order_provider.dart';
import 'package:dashboard_new/widgets_common/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class OrderAcceptScreen extends ConsumerWidget {
  const OrderAcceptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
        backgroundColor: Colors.red,
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.6,
              child: SizedBox(
                width: 300,
                height: 300,
                child: Image.asset(
                  'assets/images/order_vector.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const OrderList(),
        ],
      ),
    );
  }
}

class OrderList extends ConsumerWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersStreamProvider(currentUser?.uid ?? ''));

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text("No orders found"));
        }
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return FutureBuilder<Customer>(
              future: getCustomerData(order.customerId),
              builder: (context, customerSnapshot) {
                if (customerSnapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitPulse(
                    color: Colors.red,
                    size: 50.0,
                  );
                }
                if (customerSnapshot.hasError) {
                  return Text('Error: ${customerSnapshot.error}');
                }
                final customer = customerSnapshot.data!;

                return OrderCard(
                  order: order,
                  customer: customer,
                  onRemoveClicked: () {
                    // Riverpod will handle updates via stream
                  },
                  acceptOrder: () {
                    ref.read(orderActionsProvider).acceptOrder(currentUser!.uid, order);
                  },
                  deleteOrder: () {
                    FirebaseFirestore.instance
                        .collection('orders')
                        .doc(order.getDocumentId())
                        .delete();
                  },
                );
              },
            );
          },
        );
      },
      loading: () => const Center(
        child: SpinKitPulse(
          color: Colors.red,
          size: 100.0,
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Future<Customer> getCustomerData(String customerId) async {
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
}
