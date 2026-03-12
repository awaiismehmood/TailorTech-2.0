import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_provider.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:dashboard_new/widgets_common/applogo_widget.dart';
import 'package:dashboard_new/widgets_common/button.dart';
import 'package:dashboard_new/widgets_common/cuton_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isCustomer = true;

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  void checkUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          if (mounted) context.go(AppRoutes.customerHome);
        } else {
          DocumentSnapshot tailorDoc = await FirebaseFirestore.instance
              .collection(usersCollection1)
              .doc(user.uid)
              .get();

          if (tailorDoc.exists) {
            final data = tailorDoc.data() as Map<String, dynamic>;
            final bool verified = data['verified'] ?? false;
            if (mounted) {
              context.go(verified ? AppRoutes.tailorHome : AppRoutes.tailorAdminVerify);
            }
          }
        }
      } catch (e) {
        debugPrint("Error fetching user document: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: context.screenHeight * 0.45,
            width: context.screenWidth,
            color: redColor,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  (context.screenHeight * 0.05).heightBox,
                  applogoWidget(),
                  10.heightBox,
                  "TailorTech"
                      .text
                      .fontFamily(bold)
                      .white
                      .size(28)
                      .letterSpacing(1.2)
                      .make(),
                  20.heightBox,
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(35),
                            border: Border.all(color: Colors.grey[300]!, width: 1),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isCustomer = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: isCustomer ? redColor : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: isCustomer 
                                          ? [BoxShadow(color: redColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] 
                                          : [],
                                    ),
                                    child: "Customer"
                                        .text
                                        .fontFamily(bold)
                                        .color(isCustomer ? whiteColor : fontGrey)
                                        .center
                                        .make(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isCustomer = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: !isCustomer ? redColor : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: !isCustomer 
                                          ? [BoxShadow(color: redColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] 
                                          : [],
                                    ),
                                    child: "Tailor"
                                        .text
                                        .fontFamily(bold)
                                        .color(!isCustomer ? whiteColor : fontGrey)
                                        .center
                                        .make(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        25.heightBox,
                        "Welcome ${isCustomer ? "Customer" : "Tailor"}!"
                            .text
                            .fontFamily(bold)
                            .size(22)
                            .color(darkFontGrey)
                            .make(),
                        5.heightBox,
                        "Log in to continue".text.color(fontGrey).make(),
                        20.heightBox,
                        customTextField(email, emailHint, authNotifier.emailController, false),
                        12.heightBox,
                        customTextField(password, passwordHint, authNotifier.passwordController, true),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.push(isCustomer ? AppRoutes.forgotPassword : AppRoutes.forgotPasswordTailor);
                            },
                            child: forgetPass.text.color(redColor).fontFamily(bold).make(),
                          ),
                        ),
                        10.heightBox,
                        authState.isLoading
                            ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(redColor))
                            : ourButton(
                                color: redColor,
                                textcolor: whiteColor,
                                tit: login,
                                onPress: () async {
                                  await handleLogin();
                                },
                              ).box.width(context.screenWidth).make(),
                        20.heightBox,
                        GestureDetector(
                          onTap: () {
                            context.push(isCustomer ? AppRoutes.customerSignup : AppRoutes.tailorSignup);
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(
                                    color: fontGrey,
                                    fontFamily: regular,
                                  ),
                                ),
                                TextSpan(
                                  text: signup,
                                  style: const TextStyle(
                                    color: redColor,
                                    fontFamily: bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  40.heightBox,
                  appversion.text.color(fontGrey).fontFamily(semibold).make(),
                  25.heightBox,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleLogin() async {
    final authNotifier = ref.read(authProvider.notifier);
    
    if (authNotifier.emailController.text.isEmpty || authNotifier.passwordController.text.isEmpty) {
      VxToast.show(context, msg: "Please enter email and password");
      return;
    }

    try {
      final value = await authNotifier.loginMethod(context);
      if (value != null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String collection = isCustomer ? usersCollection : usersCollection1;
          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection(collection).doc(user.uid).get();
          
          if (!userSnapshot.exists) {
             VxToast.show(context, msg: "Account not found for this user type.");
             await FirebaseAuth.instance.signOut();
             return;
          }

          final data = userSnapshot.data() as Map<String, dynamic>;
          final String uType = data['type'];
          
          if (uType == (isCustomer ? "Customer" : "Tailor")) {
            if (mounted) {
              VxToast.show(context, msg: logedin);
              if (isCustomer) {
                context.go(AppRoutes.customerHome);
              } else {
                final bool verified = data['verified'] ?? false;
                context.go(verified ? AppRoutes.tailorHome : AppRoutes.tailorAdminVerify);
              }
            }
          } else {
            if (mounted) {
              VxToast.show(context, msg: "Incorrect user type selected.");
            }
            await FirebaseAuth.instance.signOut();
          }
        }
      }
    } catch (e) {
      debugPrint("Login error: $e");
      if (mounted) {
        VxToast.show(context, msg: "Login failed. Please check your credentials.");
      }
    }
  }
}
