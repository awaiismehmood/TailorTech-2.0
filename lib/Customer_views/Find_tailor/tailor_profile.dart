import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' hide CarouselController;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Customer_views/home_screen/home.dart';
import 'package:dashboard_new/Model_Classes/tailor_class.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class TailorShow extends StatefulWidget {
  final String orderId;
  final String tailorId;
  const TailorShow({super.key, required this.orderId, required this.tailorId});

  @override
  State<TailorShow> createState() => _TailorShowState();
}

class _TailorShowState extends State<TailorShow> {
  Tailor? tailor;
  final double coverHeight = 280;
  final double profileHeight = 144;
  final CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchDetails(widget.tailorId);
  }

  @override
  Widget build(BuildContext context) {
    return tailor == null
        ? const Scaffold(
            backgroundColor: whiteColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: whiteColor,
            body: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                buildTop(),
                buildContent(),
                const SizedBox(height: 70),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () {
                    _confirmOrder(widget.tailorId);
                    Get.offAll(() => const Home());
                  },
                  child: "Place Order"
                      .text
                      .color(whiteColor)
                      .fontFamily(bold)
                      .make(),
                ),
              ],
            ),
          );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Text(
          "${tailor?.name}",
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, fontFamily: bold),
        ),
        const SizedBox(height: 2),
        Text(
          "Type of tailor: ${tailor?.T_type}",
          style: TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.4)),
        ),
        const SizedBox(height: 16),
        buildAbout(),
        const SizedBox(height: 16),
        const Text(
          "Price Range:",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Min Price: \$${tailor?.minPrice.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16, fontFamily: semibold),
        ),
        const SizedBox(height: 8),
        Text(
          "Max Price: \$${tailor?.maxPrice.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16, fontFamily: semibold),
        ),
      ],
    );
  }

  Widget buildAbout() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Details",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                fontFamily: semibold),
          ),
          Text(
            tailor!.details,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
                fontFamily: semibold),
          ),
          const Text(
            "Ratings",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                fontFamily: semibold),
          ),
          const SizedBox(height: 10),
          ratings(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom), child: sliderImage()),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: whiteColor,
        backgroundImage: NetworkImage(tailor!.profile_url),
      );

  Widget sliderImage() {
    return CarouselSlider(
      items: tailor?.images
          .map((url) => Image.network(url, fit: BoxFit.contain))
          .toList(),
      carouselController: carouselController,
      options: CarouselOptions(
        scrollPhysics: const BouncingScrollPhysics(),
        autoPlay: true,
        aspectRatio: 1.5,
        autoPlayInterval: const Duration(seconds: 4),
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget ratings() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBar.builder(
            initialRating: tailor!.ratting.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: redColor),
            ignoreGestures: true,
            onRatingUpdate: (rating) {},
          ),
        ],
      ),
    );
  }

  void _confirmOrder(String tailorId) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .update({
      'expectedTailorId': tailorId,
      'status': "Pending",
    });
  }

  void fetchDetails(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(usersCollection1)
        .doc(id)
        .get();
    if (doc.exists) {
      setState(() {
        tailor = Tailor.fromFirestore1(doc);
      });
    } else {
      print('Tailor not found.');
    }
  }
}
