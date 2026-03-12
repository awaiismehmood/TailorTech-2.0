import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:dashboard_new/consts/colors.dart';
import 'package:dashboard_new/consts/styles.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends ConsumerWidget {
  final Orderr order;
  final Customer getCustomer;

  const DetailScreen({
    super.key,
    required this.order,
    required this.getCustomer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
        backgroundColor: Colors.red,
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.5),
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
                      ),
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
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: redColor.withOpacity(0.1),
                      spreadRadius: 4,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
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
                  acceptOrder(context, order.expId, order);
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
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  deleteOrder(context, order);
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

  Future<void> acceptOrder(BuildContext context, String tailorId, Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'tailorId': tailorId,
      'status': 'Running',
      'expectedTailorId': "",
    });

    if (context.mounted) {
      context.go(AppRoutes.tailorHome);
    }
  }

  Future<void> deleteOrder(BuildContext context, Orderr order) async {
    String orderId = order.getDocumentId() ?? '';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    if (context.mounted) {
      context.go(AppRoutes.tailorHome);
    }
  }
}
