import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Customer_views/home_screen/home.dart';
import 'package:dashboard_new/Model_Classes/order_class.dart';
import 'package:dashboard_new/consts/colors.dart' show redColor, whiteColor;
import 'package:dashboard_new/consts/firebase_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';

class RatingScreen extends StatefulWidget {
  final String tailorId;
  final Orderr order;

  const RatingScreen({super.key, required this.tailorId, required this.order});

  @override
  // ignore: library_private_types_in_public_api
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 0.0;
  // final TextEditingController _commentController = TextEditingController();

  @override
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
                  'Rate Your Tailor ',
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
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(usersCollection1)
              .doc(widget.tailorId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('Tailor not found'));
            }
            var tailorData = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      shadowColor: redColor.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                tailorData['ProfileImageurl'],
                              ),
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              tailorData['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 40,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.red),
                      onRatingUpdate: (rating) {
                        _rating = rating;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Leave a comment...",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(fontFamily: "Poppins"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        updateRatting();
                        Get.offAll(() => const Home());
                        updateTailorRating();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void updateRatting() async {
    await firestore.collection('orders').doc(widget.order.id).update({
      'ratting': _rating,
    });
  }

  void updateTailorRating() async {
    var ordersSnapshot = await firestore
        .collection('orders')
        .where('tailorId', isEqualTo: widget.tailorId)
        .get();
    double totalRating = 0;
    int count = 0;

    for (var doc in ordersSnapshot.docs) {
      var orderData = doc.data();
      totalRating += orderData['ratting'];
      count++;
    }

    double avgRating = count > 0 ? totalRating / count : 0;

    await firestore.collection(usersCollection1).doc(widget.tailorId).update({
      'ratting': avgRating,
    });
  }
}
