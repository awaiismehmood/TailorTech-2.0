import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/First_screen/first_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:dashboard/First_screen/first_screen.dart';
import '../consts/consts.dart';

class AuthController extends GetxController {
  var isloading = false.obs;

  //text controllers

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //login method
  Future<UserCredential?> loginMethod(context) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // ignore: unnecessary_null_comparison
      if (userCredential != null && !userCredential.user!.emailVerified) {
        // If email is not verified, sign out the user and show a message
        log("Iam in usercredentials");
        await _auth.signOut();
        VxToast.show(
          context,
          msg: "Please verify your email before logging in.",
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      log("Iam in usercredentials catch");
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //signup method

  // Future<UserCredential?> signupMethod(email, password, context) async {
  //   UserCredential? userCredential;
  //   try {
  //     await auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException catch (e) {
  //     VxToast.show(context, msg: e.toString());
  //   }
  //   return userCredential;
  // }

  Future<UserCredential?> signupMethod(email, password, context) async {
    try {
      // Email validation
      if (!isValidEmail(email)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is not valid.',
        );
      }

      // Password validation
      if (password.length < 8) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must be at least 8 characters.',
        );
      }

      // Check for at least one uppercase letter
      if (!password.contains(RegExp(r'[A-Z]'))) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must contain at least one uppercase letter.',
        );
      }

      // Check for at least one lowercase letter
      if (!password.contains(RegExp(r'[a-z]'))) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must contain at least one lowercase letter.',
        );
      }

      // Check for at least one digit
      if (!password.contains(RegExp(r'[0-9]'))) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must contain at least one digit.',
        );
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message ?? 'An error occurred');
      return null;
    }
  }

  // Email validation function
  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  //storing data od costumer method

  Future<void> storeuserData({
    name,
    password,
    email,
    type,
    phone,
    profileImageurl,
    online,
    required BuildContext context,
    List<String>? chatList,
  }) async {
    DocumentReference store = firestore
        .collection(usersCollection)
        .doc(currentUser!.uid);
    store.set({
      'online': online,
      'name': name,
      'password': password,
      'email': email,
      'ProfileImageurl': profileImageurl,
      'id': currentUser!.uid,
      'type': type,
      'phone': phone,
      'timestamp': FieldValue.serverTimestamp(),
      'chatlist': chatList,
    });
  }

  //from map
  //to map

  Future<void> storeTailorData({
    required BuildContext context,
    name,
    password,
    email,
    type,
    cnic,
    phone,
    latitude = 0.00,
    longitude = 0.00,
    profileSetup,
    online,
    ratting = 0.00,
    minPrice = 0.0,
    maxPrice = 0.00,
    List<String>? chatList,
    verified,
  }) async {
    DocumentReference store = firestore
        .collection(usersCollection1)
        .doc(currentUser!.uid);
    store.set({
      'online': online,
      'name': name,
      'password': password,
      'email': email,
      'ProfileImageurl': ' ',
      'details': '',
      'T_type': '',
      'images': [],
      'id': currentUser!.uid,
      'type': type,
      'Phone': phone,
      'CNIC': cnic,
      'timestamp': FieldValue.serverTimestamp(),
      'longitude': longitude,
      'latitude': latitude,
      'profileSetup': profileSetup,
      'ratting': ratting,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'chatlist': chatList,
      'verified': verified,
    });
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully
    } catch (e) {
      // Error occurred while sending reset email
      print('Error sending password reset email: $e');
      rethrow; // Re-throw the error to handle it where the method is called
    }
  }

  //signout method

  Future<void> signoutMethod(BuildContext context) async {
    try {
      emailController.clear();
      passwordController.clear();
      // Clear any additional user-specific data
      // Clear the AuthController instance
      // exit(0);
      await _auth.signOut();
      Get.delete<AuthController>();
      // Navigate to the splash screen or login screen
      //exit(0);
      Get.offAll(() => const SplashScreen());
    } catch (e) {
      VxToast.show(context, msg: 'Failed to sign out.');
    }
  }
}
