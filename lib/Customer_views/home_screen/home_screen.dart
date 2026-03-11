import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/Customer_views/measurements/measurements.dart';
import 'package:dashboard_new/Customer_views/Find_tailor/order_place.dart';
import 'package:dashboard_new/widgets_common/exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  final Customer customer;
  const HomePage({required this.customer, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgo.png', // Replace with your asset image path
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        //greeting row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi ${widget.customer.name}", //greeting,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),

                        // search bar

                        const SizedBox(
                          height: 25,
                        ),

                        SizedBox(
                          height: 250, // Adjust the height as needed
                          width: 300, // Adjust the width as needed
                          child: Lottie.network(
                            "https://lottie.host/20f2c37a-0579-49b9-993c-1a59c2d1c75c/9EiI0vKj7O.json",
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        // 4 different
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        color: Colors.grey[200],
                        child: Center(
                          child: Column(
                            children: [
                              //Exercises
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Menu",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Icon(Icons.more_horiz),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //list view of exercises
                              Expanded(
                                child: ListView(
                                  children: [
                                    ExerciseTile(
                                      onpress: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MeasurementScreen()));
                                      },
                                      icon: Icons.miscellaneous_services,
                                      exerciseName: "Measurements",
                                      numberOfExercises: 10,
                                      color: Colors.orange,
                                    ),
                                    ExerciseTile(
                                      onpress: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TailorInfoScreen()));
                                      },
                                      icon: Icons.more,
                                      exerciseName: "find tailor",
                                      numberOfExercises: 10,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
