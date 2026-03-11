import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String id;
  String name;
  String password;
  String email;
  String type;
  String phone;
  String profileImageUrl;
  List<String> chatList;
  final bool online;

  Customer(
      {required this.id,
      required this.online,
      required this.name,
      required this.password,
      required this.email,
      required this.type,
      required this.phone,
      required this.profileImageUrl,
      required this.chatList});

  factory Customer.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Customer(
      id: data['id'] ?? '',
      online: data['online'] ?? false,
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      type: data['type'] ?? '',
      phone: data['phone'] ?? '',
      profileImageUrl: data['ProfileImageurl'] ?? '',
      chatList: List<String>.from(data['chatlist'] ?? []),
    );
  }
}
