import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/Customer_views/services/chatt/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class chatService {
  //getv instance of firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUserStream(String currentUserId) {
    log("iam in chat service");
    // Get the chat list of the current user
    return _firestore.collection(usersCollection1).snapshots().map((snapshot) {
      // Fetch chat list of current user
      return getUserChatList(currentUserId).then((chatlist) {
        // Map each document in the snapshot
        return snapshot.docs.where((doc) {
          final userId =
              doc.id; // Assuming the user ID is stored as the document ID

          // Check if the user ID is in the chat list
          return chatlist.contains(userId);
        }).map((doc) {
          // Return user data
          final user = doc.data();
          return user;
        }).toList();
      });
    }).asyncMap((event) =>
        event); // Convert Future<List<Map<String, dynamic>>> to Stream<List<Map<String, dynamic>>>
  }

  Future<List<String>> getUserChatList(String userId) async {
    try {
      // Get the chat list of the user from Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection(usersCollection).doc(userId).get();

      // Extract the chat list or initialize an empty list if it doesn't exist
      List<String> chatList = List<String>.from(
          (userSnapshot.data() as Map<String, dynamic>?)?['chatlist'] ?? []);

      return chatList;
    } catch (e) {
      print(e.toString());
      return []; // Return an empty list if an error occurs
    }
  }

  //send messages

  Future<void> sendMessages(String recieverID, message) async {
    //get current user info

    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        message: message,
        recieverID: recieverID,
        senderEmail: currentUserEmail,
        timestamp: timestamp);

    //construct chat room id for the

    List<String> ids = [currentUserID, recieverID];
    ids.sort();

    String chatRoomID = ids.join('_');
    //add new message to the database

    await _firestore
        .collection(usersCollection)
        .doc(currentUserID)
        .collection("chat")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());

    await _firestore
        .collection(usersCollection1)
        .doc(recieverID)
        .collection("chat")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());
  }

  //get messages

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    log(otherUserID);
    ids.sort();

    log("iam in getMessages");

    String chatRoomID = ids.join('_');

    return _firestore
        .collection(usersCollection)
        .doc(userID)
        .collection("chat")
        .doc(chatRoomID)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
