import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'measurement_class.dart';

// ignore: camel_case_types
class showMeasure extends ConsumerStatefulWidget {
  final String id;
  final bool isCustomer;
  const showMeasure({super.key, required this.id, required this.isCustomer});

  @override
  ConsumerState<showMeasure> createState() => _showMeasureState();
}

// ignore: camel_case_types
class _showMeasureState extends ConsumerState<showMeasure> {
  CustomerMeasurements? customerMeasurements;
  bool isEditing = false;
  Future<void> gettingMeasure() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(widget.id)
        .collection('measurements')
        .doc(widget.id)
        .get();
    if (mounted) {
      setState(() {
        customerMeasurements = CustomerMeasurements.fromFirebase(doc);
      });
    }
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
              backgroundColor: redColor,
              elevation: 10,
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
                                if (mounted) {
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                }
                              },
                            )
                          : const Icon(Icons.accessible_forward_rounded),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                      customerMeasurements?.saveToFirestore();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Measurements saved!'),
                        ));
                        context.go(AppRoutes.customerHome);
                      }
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    child: const Icon(Icons.save),
                  )
                : FloatingActionButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
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
