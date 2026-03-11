import 'package:cloud_firestore/cloud_firestore.dart';

class Tailor {
  String id;
  String name;
  String password;
  String email;
  String type;
  String phone;
  String cnic;
  double latitude;
  double longitude;
  String profile_url;
  bool profileSetup;
  String details;
  String T_type;
  List<String> images;
  final bool online;
  double ratting;
  double minPrice;
  double maxPrice;
  List<String> chatList;
  bool verified;

  Tailor(
      {required this.id,
      required this.online,
      required this.details,
      required this.T_type,
      required this.images,
      required this.profileSetup,
      required this.name,
      required this.password,
      required this.email,
      required this.type,
      required this.phone,
      required this.cnic,
      required this.profile_url,
      required this.latitude,
      required this.longitude,
      required this.ratting,
      required this.minPrice,
      required this.maxPrice,
      required this.verified,
      required this.chatList});

  factory Tailor.fromFirestore1(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Tailor(
      id: data['id'] ?? '',
      online: data['online'] ?? false,
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      cnic: data['CNIC'],
      profile_url: data['ProfileImageurl'],
      type: data['type'] ?? '',
      phone: data['Phone'] ?? '',
      latitude: data['latitude'],
      longitude: data['longitude'],
      profileSetup: data['profileSetup'],
      details: data['details'] ?? '',
      T_type: data['T_type'] ?? '',
      images: List<String>.from(data['images']),
      ratting: data['ratting'],
      minPrice: data['minPrice'],
      maxPrice: data['maxPrice'],
      verified: data['verified'],
      chatList: List<String>.from(data['chatlist'] ?? []),
    );
  }
}
