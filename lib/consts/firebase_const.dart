import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseFirestore firestore = FirebaseFirestore.instance;

User? currentUser = auth.currentUser;

const usersCollection = 'users';
const usersCollection1 = 'Tusers';

// Future<String?> getUserData(
//     {required userId, required usercol, required str}) async {
//   try {
//     DocumentSnapshot userSnapshot =
//         await FirebaseFirestore.instance.collection(usercol).doc(userId).get();
//     final data = userSnapshot.data() as Map<String, dynamic>;
//     final String u_type = data[str];
//     return u_type;
//   } catch (e) {
//     // Handle any errors that might occur during the fetch.
//     log("Error fetching user data: $e");
//     return null;
//   }
// }


