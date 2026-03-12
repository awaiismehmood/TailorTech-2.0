import 'package:dashboard_new/Model_Classes/customer_class.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:dashboard_new/widgets_common/exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class HomePage extends ConsumerWidget {
  final Customer customer;
  const HomePage({required this.customer, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgo.png',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hi ${customer.name}",
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
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 250,
                          width: 300,
                          child: Lottie.network(
                            "https://lottie.host/20f2c37a-0579-49b9-993c-1a59c2d1c75c/9EiI0vKj7O.json",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
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
                              Expanded(
                                child: ListView(
                                  children: [
                                    ExerciseTile(
                                      onpress: () {
                                        context.push(AppRoutes.customerMeasurements);
                                      },
                                      icon: Icons.miscellaneous_services,
                                      exerciseName: "Measurements",
                                      numberOfExercises: 10,
                                      color: Colors.orange,
                                    ),
                                    ExerciseTile(
                                      onpress: () {
                                        context.push(AppRoutes.tailorInfo);
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
