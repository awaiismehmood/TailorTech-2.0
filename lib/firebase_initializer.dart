import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> initializeFirebaseStructure() async {
  final firestore = FirebaseFirestore.instance;

  // ---------- USERS COLLECTION ----------
  final users = firestore.collection('users');
  final dummyUserId = 'dummy_user';
  await users.doc(dummyUserId).set({
    "id": dummyUserId,
    "name": "",
    "email": "",
    "password": "",
    "type": "customer",
    "phone": "",
    "ProfileImageurl": "",
    "online": false,
    "timestamp": FieldValue.serverTimestamp(),
    "chatlist": [],
  });

  // Subcollections: chat/message
  final chat = users.doc(dummyUserId).collection('chat');
  final dummyChatId = 'dummy_chat';
  await chat.doc(dummyChatId).collection('message').add({
    "senderID": "",
    "senderEmail": "",
    "reciverID": "",
    "message": "",
    "timestamp": FieldValue.serverTimestamp(),
  });

  // ---------- TUSERS COLLECTION ----------
  final tusers = firestore.collection('Tusers');
  final dummyTailorId = 'dummy_tailor';
  await tusers.doc(dummyTailorId).set({
    "id": dummyTailorId,
    "name": "",
    "email": "",
    "password": "",
    "Phone": "",
    "CNIC": "",
    "ProfileImageurl": "",
    "details": "",
    "T_type": "",
    "images": [],
    "type": "tailor",
    "latitude": 0.0,
    "longitude": 0.0,
    "profileSetup": false,
    "online": false,
    "ratting": 0,
    "minPrice": 0,
    "maxPrice": 0,
    "verified": false,
    "timestamp": FieldValue.serverTimestamp(),
    "chatlist": [],
  });

  final tailorChat = tusers.doc(dummyTailorId).collection('chat');
  final dummyTailorChatId = 'dummy_tailor_chat';
  await tailorChat.doc(dummyTailorChatId).collection('message').add({
    "senderID": "",
    "senderEmail": "",
    "reciverID": "",
    "message": "",
    "timestamp": FieldValue.serverTimestamp(),
  });

  // ---------- ORDERS COLLECTION ----------
  final orders = firestore.collection('orders');
  await orders.doc('dummy_order').set({
    "id": "dummy_order",
    "customerId": "",
    "tailorId": "",
    "tailorType": "",
    "clothesImageUrls": [],
    "designImageUrls": [],
    "details": "",
    "expectedTailorId": "",
    "status": "pending",
    "price": 0,
    "ratting": 0,
  });

  print("Firebase structure initialized successfully!");
}
