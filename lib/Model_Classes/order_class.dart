import 'package:cloud_firestore/cloud_firestore.dart';

class Orderr {
  String? id;
  String? tailorId;
  String tailorType;
  List<String> clothesImageUrls;
  List<String> designImageUrls;
  String details;
  String expId;
  String customerId;
  String status;
  double ratting;
  double price;

  Orderr({
    this.id,
    required this.tailorId,
    required this.tailorType,
    required this.clothesImageUrls,
    required this.designImageUrls,
    required this.details,
    required this.expId,
    required this.customerId,
    required this.status,
    required this.ratting,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'tailorId': tailorId,
      'tailorType': tailorType,
      'clothesImageUrls': clothesImageUrls,
      'designImageUrls': designImageUrls,
      'details': details,
      'expectedTailorId': expId,
      'customerId': customerId,
      'status': status,
      'ratting': ratting,
      'price': price,
    };
  }

  factory Orderr.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Orderr(
      tailorId: data['tailorId'] ?? "",
      tailorType: data['tailorType'],
      clothesImageUrls: List<String>.from(data['clothesImageUrls']),
      designImageUrls: List<String>.from(data['designImageUrls']),
      details: data['details'],
      expId: data['expectedTailorId'],
      customerId: data['customerId'],
      status: data['status'] ?? "",
      id: doc.id,
      ratting: data['ratting'],
      price: data['price'],
    );
  }

  String? getDocumentId() {
    return id;
  }
}
