import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'measurement_class.dart';

// ignore: camel_case_types
class measurementsShow extends ConsumerStatefulWidget {
  final Map<String, dynamic> responseData;
  final String height;
  const measurementsShow(
      {super.key, required this.responseData, required this.height});

  @override
  ConsumerState<measurementsShow> createState() => _measurementsShowState();
}

// ignore: camel_case_types
class _measurementsShowState extends ConsumerState<measurementsShow> {
  late CustomerMeasurements customerMeasurements;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    customerMeasurements = CustomerMeasurements(
      height: double.tryParse(widget.height) ?? 0.0,
      waist: widget.responseData['waist'],
      belly: widget.responseData['belly'],
      chest: widget.responseData['chest'],
      wrist: widget.responseData['wrist'],
      neck: widget.responseData['neck'],
      arm: widget.responseData['arm length'],
      thigh: widget.responseData['thigh'],
      shoulder: widget.responseData['shoulder width'],
      hips: widget.responseData['hips'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'My Measurements',
                    style: TextStyle(
                      fontFamily: bold,
                      color: whiteColor,
                      fontSize: 30,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.done : Icons.edit,
                    color: whiteColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            _buildMeasurementContainer('Height', customerMeasurements.height),
            _buildMeasurementContainer('Waist', customerMeasurements.waist),
            _buildMeasurementContainer('Belly', customerMeasurements.belly),
            _buildMeasurementContainer('Chest', customerMeasurements.chest),
            _buildMeasurementContainer('Wrist', customerMeasurements.wrist),
            _buildMeasurementContainer('Neck', customerMeasurements.neck),
            _buildMeasurementContainer('Arm', customerMeasurements.arm),
            _buildMeasurementContainer('Thigh', customerMeasurements.thigh),
            _buildMeasurementContainer(
                'Shoulder', customerMeasurements.shoulder),
            _buildMeasurementContainer('Hips', customerMeasurements.hips),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          customerMeasurements.saveToFirestore();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Measurements saved!'),
            ));
            context.go(AppRoutes.customerHome);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
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
            color: const Color.fromARGB(122, 209, 200, 200).withOpacity(0.4),
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
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(width: 20.0),
          if (isEditing)
            Expanded(
              child: TextFormField(
                initialValue: value.toString(),
                onChanged: (newValue) {
                  setState(() {
                    // Update the corresponding measurement value
                    if (label == 'Height') {
                      customerMeasurements.height = double.parse(newValue);
                    } else if (label == 'Waist') {
                      customerMeasurements.waist = double.parse(newValue);
                    } else if (label == 'Belly') {
                      customerMeasurements.belly = double.parse(newValue);
                    } else if (label == 'Chest') {
                      customerMeasurements.chest = double.parse(newValue);
                    } else if (label == 'Wrist') {
                      customerMeasurements.wrist = double.parse(newValue);
                    } else if (label == 'Neck') {
                      customerMeasurements.neck = double.parse(newValue);
                    } else if (label == 'Arm') {
                      customerMeasurements.arm = double.parse(newValue);
                    } else if (label == 'Thigh') {
                      customerMeasurements.thigh = double.parse(newValue);
                    } else if (label == 'Shoulder') {
                      customerMeasurements.shoulder = double.parse(newValue);
                    } else if (label == 'Hips') {
                      customerMeasurements.hips = double.parse(newValue);
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
