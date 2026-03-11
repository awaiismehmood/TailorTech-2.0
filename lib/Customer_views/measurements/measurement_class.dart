// measurement_class.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/consts/consts.dart';

class CustomerMeasurements {
  double height;
  double waist;
  double belly;
  double chest;
  double wrist;
  double neck;
  double arm;
  double thigh;
  double shoulder;
  double hips;
  bool saved; // Indicates whether measurements are saved or not

  CustomerMeasurements({
    required this.height,
    required this.waist,
    required this.belly,
    required this.chest,
    required this.wrist,
    required this.neck,
    required this.arm,
    required this.thigh,
    required this.shoulder,
    required this.hips,
    this.saved = false,
  });

  Future<void> saveToFirestore() async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a reference to the specific document
      DocumentReference docRef = firestore
          .collection(usersCollection)
          .doc(currentUser!.uid)
          .collection('measurements')
          .doc(currentUser!.uid); // Specify the document ID here

      // Set the data of the document
      await docRef.set({
        'height': height,
        'waist': waist,
        'belly': belly,
        'chest': chest,
        'wrist': wrist,
        'neck': neck,
        'arm': arm,
        'thigh': thigh,
        'shoulder': shoulder,
        'hips': hips,
        'saved': true, // Mark as saved
      });

      // Update the saved field
      saved = true;
    } catch (e) {
      print('Error saving measurements: $e');
    }
  }

  factory CustomerMeasurements.fromFirebase(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CustomerMeasurements(
      height: data['height'] ?? 0.0,
      waist: data['waist'] ?? 0.0,
      belly: data['belly'] ?? 0.0,
      chest: data['chest'] ?? 0.0,
      wrist: data['wrist'] ?? 0.0,
      neck: data['neck'] ?? 0.0,
      arm: data['arm'] ?? 0.0,
      thigh: data['thigh'] ?? 0.0,
      shoulder: data['shoulder'] ?? 0.0,
      hips: data['hips'] ?? 0.0,
      saved: data['saved'] ?? false,
    );
  }
}
