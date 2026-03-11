import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:dashboard_new/Tailor_views/order_confirmation/DetailScreen.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Orderr order;
  final Customer customer;
  final VoidCallback onRemoveClicked;
  final VoidCallback acceptOrder;
  final VoidCallback deleteOrder;

  const OrderCard({
    super.key,
    required this.order,
    required this.customer,
    required this.onRemoveClicked,
    required this.acceptOrder,
    required this.deleteOrder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to another screen when the card is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(order: order, getCustomer: customer),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        color: Colors.grey[300], // Greyish background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20,
          ), // Set the desired border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(20), // Adjust padding as needed
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: customer.profileImageUrl != " "
                      ? NetworkImage(customer.profileImageUrl)
                      : null,
                  child: customer.profileImageUrl == " "
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
              Text(customer.name, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text(order.tailorType, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150, // Set the desired width
                    child: ElevatedButton(
                      onPressed: () {
                        acceptOrder();
                        onRemoveClicked();
                        // Add accept order functionality
                        print('Accepted');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green.shade200, // Green accent color
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ), // Adjust padding as needed
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.black,
                        ), // Black text color
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150, // Set the desired width
                    child: ElevatedButton(
                      onPressed: () {
                        deleteOrder();
                        onRemoveClicked();
                        // Add decline order functionality
                        print('Declined');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red.shade200, // Red accent color
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ), // Adjust padding as needed
                      ),
                      child: const Text(
                        'Decline',
                        style: TextStyle(
                          color: Colors.black,
                        ), // Black text color
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
