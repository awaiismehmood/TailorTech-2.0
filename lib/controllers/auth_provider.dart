import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class to hold auth status
class AuthState {
  final bool isLoading;
  final User? user;

  AuthState({this.isLoading = false, this.user});

  AuthState copyWith({bool? isLoading, User? user}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  AuthState build() {
    return AuthState(user: _auth.currentUser);
  }

  // Text controllers can be managed here or in the UI. 
  // For migration, we'll keep them simple.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<UserCredential?> loginMethod(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    UserCredential? userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential != null && !userCredential.user!.emailVerified) {
        await _auth.signOut();
        if (context.mounted) {
          VxToast.show(context, msg: "Please verify your email before logging in.");
        }
        state = state.copyWith(isLoading: false);
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        VxToast.show(context, msg: e.toString());
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return userCredential;
  }

  Future<UserCredential?> signupMethod(String email, String password, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      if (!isValidEmail(email)) {
        throw FirebaseAuthException(code: 'invalid-email', message: 'The email address is not valid.');
      }
      if (password.length < 8) {
        throw FirebaseAuthException(code: 'weak-password', message: 'The password must be at least 8 characters.');
      }
      if (!password.contains(RegExp(r'[A-Z]'))) {
        throw FirebaseAuthException(code: 'weak-password', message: 'The password must contain at least one uppercase letter.');
      }
      if (!password.contains(RegExp(r'[a-z]'))) {
        throw FirebaseAuthException(code: 'weak-password', message: 'The password must contain at least one lowercase letter.');
      }
      if (!password.contains(RegExp(r'[0-9]'))) {
        throw FirebaseAuthException(code: 'weak-password', message: 'The password must contain at least one digit.');
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        VxToast.show(context, msg: e.message ?? 'An error occurred');
      }
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> storeUserData({
    required String name,
    required String password,
    required String email,
    required String type,
    required String phone,
    String? profileImageUrl,
    bool online = false,
    List<String>? chatList,
  }) async {
    if (_auth.currentUser == null) return;
    
    DocumentReference store = _firestore.collection(usersCollection).doc(_auth.currentUser!.uid);
    await store.set({
      'online': online,
      'name': name,
      'password': password,
      'email': email,
      'ProfileImageurl': profileImageUrl ?? " ",
      'id': _auth.currentUser!.uid,
      'type': type,
      'phone': phone,
      'timestamp': FieldValue.serverTimestamp(),
      'chatlist': chatList,
    });
  }

  Future<void> storeTailorData({
    required String name,
    required String password,
    required String email,
    required String type,
    required String cnic,
    required String phone,
    double latitude = 0.0,
    double longitude = 0.0,
    bool profileSetup = false,
    bool online = false,
    double rating = 0.0,
    double minPrice = 0.0,
    double maxPrice = 0.0,
    List<String>? chatList,
    bool verified = false,
  }) async {
    if (_auth.currentUser == null) return;

    DocumentReference store = _firestore.collection(usersCollection1).doc(_auth.currentUser!.uid);
    await store.set({
      'online': online,
      'name': name,
      'password': password,
      'email': email,
      'ProfileImageurl': ' ',
      'details': '',
      'T_type': '',
      'images': [],
      'id': _auth.currentUser!.uid,
      'type': type,
      'Phone': phone,
      'CNIC': cnic,
      'timestamp': FieldValue.serverTimestamp(),
      'longitude': longitude,
      'latitude': latitude,
      'profileSetup': profileSetup,
      'ratting': rating,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'chatlist': chatList,
      'verified': verified,
    });
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log('Error sending password reset email: $e');
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      emailController.clear();
      passwordController.clear();
      await _auth.signOut();
      state = AuthState(); // Reset state
    } catch (e) {
      if (context.mounted) {
        VxToast.show(context, msg: 'Failed to sign out.');
      }
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
