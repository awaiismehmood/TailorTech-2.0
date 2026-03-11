import 'package:dashboard_new/Model_Classes/tailor_class.dart';
import 'package:dashboard_new/Tailor_views/Profile/edit_profile.dart';
import 'package:dashboard_new/Tailor_views/chat/chat_home.dart';
import 'package:dashboard_new/consts/colors.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/view/support.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  final Tailor tailor;

  const EditProfileScreen({required this.tailor, super.key});
  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.put(AuthController());

  final PageController _controller = PageController();
  double _currentPosition = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPosition = _controller.page!.round() as double;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  'My-Profile',
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
          foregroundColor: whiteColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white70),
            child: ListView(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: widget.tailor.profile_url != " "
                          ? NetworkImage(widget.tailor.profile_url)
                          : null,
                      child: widget.tailor.profile_url == " "
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      widget.tailor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.tailor.email,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
                const SizedBox(height: 10), // Reduced the space
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        tileColor: redColor,
                        title: Text(
                          'Catalog',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: PageView.builder(
                                controller: _controller,
                                itemCount: widget.tailor.images.length,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    widget.tailor.images[index],
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 1),
                            Center(
                              child: DotsIndicator(
                                dotsCount: widget.tailor.images.length,
                                position: _currentPosition,
                                decorator: const DotsDecorator(
                                  color: Colors.grey,
                                  activeColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        tileColor: redColor,
                        title: Text(
                          'Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'CNIC',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          widget.tailor.cnic,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          widget.tailor.phone,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Rating',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            RatingBar(
                              rating: widget.tailor.ratting,
                              onRatingChanged: (double ratting) {},
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.tailor.ratting.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        tileColor: redColor,
                        title: Text(
                          'Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: whiteColor,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.chat),
                        title: const Text(
                          'Chat',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => chatHomeT(),
                            ),
                          );
                          // Add functionality for Chat
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.question_mark_rounded),
                        title: const Text(
                          'Help and Support',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HelpAndSupportScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          controller.signoutMethod(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;
  const RatingBar({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: rating >= 1 ? Colors.red : Colors.grey),
        Icon(Icons.star, color: rating >= 2 ? Colors.red : Colors.grey),
        Icon(Icons.star, color: rating >= 3 ? Colors.red : Colors.grey),
        Icon(Icons.star, color: rating >= 4 ? Colors.red : Colors.grey),
        Icon(Icons.star, color: rating == 5 ? Colors.red : Colors.grey),
      ],
    );
  }
}
