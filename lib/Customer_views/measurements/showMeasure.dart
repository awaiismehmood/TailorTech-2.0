// ignore_for_file: library_private_types_in_public_api, camel_case_types, duplicate_ignore, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Customer_views/home_screen/home.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'measurement_class.dart';

// ignore: camel_case_types
class showMeasure extends StatefulWidget {
  final String id;
  final bool isCustomer;
  const showMeasure({super.key, required this.id, required this.isCustomer});

  @override
  // ignore: library_private_types_in_public_api
  _showMeasureState createState() => _showMeasureState();
}

// ignore: camel_case_types
class _showMeasureState extends State<showMeasure> {
  CustomerMeasurements? customerMeasurements;
  bool isEditing = false;
  Future<void> gettingMeasure() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(widget.id)
        .collection('measurements')
        .doc(widget.id)
        .get();
    setState(() {
      customerMeasurements = CustomerMeasurements.fromFirebase(doc);
    });
  }

  @override
  void initState() {
    super.initState();
    gettingMeasure();
  }

  @override
  Widget build(BuildContext context) {
    return customerMeasurements == null
        ? const Scaffold(
            backgroundColor: whiteColor,
            body: Center(
              child: Center(
                child: SpinKitPulse(
                  color: Colors.red,
                  size: 100.0,
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: redColor, // Red app bar background color
              elevation: 10, // Add elevation for drop shadow
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors
                          .white70, // You can change the border color here
                      width: 2.0, // You can adjust the border width here
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      'My Measurements',
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
            backgroundColor: whiteColor,
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      widget.isCustomer
                          ? IconButton(
                              icon: Icon(
                                isEditing ? Icons.done : Icons.edit,
                                color: redColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                              },
                            )
                          : const Icon(Icons.accessible_forward_rounded),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(bottom: 20.0),
                  //   child: const Text(
                  //     'wahab',
                  //     style: TextStyle(
                  //       fontSize: 24.0,
                  //       fontWeight: FontWeight.bold,
                  //       color: Color.fromARGB(255, 255, 255, 255),
                  //     ),
                  //   ),
                  // ),
                  _buildMeasurementContainer(
                      'Height', customerMeasurements?.height ?? 0.00),
                  _buildMeasurementContainer(
                      'Waist', customerMeasurements?.waist ?? 0.00),
                  _buildMeasurementContainer(
                      'Belly', customerMeasurements?.belly ?? 0.00),
                  _buildMeasurementContainer(
                      'Chest', customerMeasurements?.chest ?? 0.00),
                  _buildMeasurementContainer(
                      'Wrist', customerMeasurements?.wrist ?? 0.00),
                  _buildMeasurementContainer(
                      'Neck', customerMeasurements?.neck ?? 0.00),
                  _buildMeasurementContainer(
                      'Arm', customerMeasurements?.arm ?? 0.00),
                  _buildMeasurementContainer(
                      'Thigh', customerMeasurements?.thigh ?? 0.00),
                  _buildMeasurementContainer(
                      'Shoulder', customerMeasurements?.shoulder ?? 0.00),
                  _buildMeasurementContainer(
                      'Hips', customerMeasurements?.hips ?? 0.00),
                ],
              ),
            ),
            floatingActionButton: widget.isCustomer
                ? FloatingActionButton(
                    onPressed: () {
                      Get.offAll(const Home());
                      customerMeasurements?.saveToFirestore();

                      // setState(() {
                      //   customerMeasurements.saveToFirestore();
                      // });
                      // Save measurements to profile or perform any other action here
                      print('Measurements saved: $customerMeasurements');
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Measurements saved!'),
                      ));
                    },
                    backgroundColor: Colors.white, // White background color
                    foregroundColor: Colors.red, // Red icon color
                    child: const Icon(Icons.save),
                  )
                : FloatingActionButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    backgroundColor: Colors.white, // White background color
                    foregroundColor: Colors.red, // Red icon color
                    child: const Icon(Icons.home_filled),
                  ));
  }

  Widget _buildMeasurementContainer(String label, double value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color.fromARGB(
            255, 255, 255, 255), // Set container color to light red
        boxShadow: [
          BoxShadow(
            color: redColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.linear_scale),
          const SizedBox(width: 8.0),
          Text(label,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(width: 20.0),
          if (isEditing)
            Expanded(
              child: TextFormField(
                initialValue: value.toString(),
                onChanged: (newValue) {
                  setState(() {
                    // Update the corresponding measurement value
                    if (label == 'Height') {
                      customerMeasurements?.height = double.parse(newValue);
                    } else if (label == 'Waist') {
                      customerMeasurements?.waist = double.parse(newValue);
                    } else if (label == 'Belly') {
                      customerMeasurements?.belly = double.parse(newValue);
                    } else if (label == 'Chest') {
                      customerMeasurements?.chest = double.parse(newValue);
                    } else if (label == 'Wrist') {
                      customerMeasurements?.wrist = double.parse(newValue);
                    } else if (label == 'Neck') {
                      customerMeasurements?.neck = double.parse(newValue);
                    } else if (label == 'Arm') {
                      customerMeasurements?.arm = double.parse(newValue);
                    } else if (label == 'Thigh') {
                      customerMeasurements?.thigh = double.parse(newValue);
                    } else if (label == 'Shoulder') {
                      customerMeasurements?.shoulder = double.parse(newValue);
                    } else if (label == 'Hips') {
                      customerMeasurements?.hips = double.parse(newValue);
                    }
                  });
                },
              ),
            )
          else
            Text(value.toString()),
        ],
      ),
    );
  }
}
