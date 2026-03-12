import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Customer_views/auth_screen/signup_screen.dart';
import 'package:dashboard_new/Customer_views/home_screen/home.dart';
import 'package:dashboard_new/Tailor_views/auth_screen/signup_screen.dart';
import 'package:dashboard_new/Tailor_views/auth_screen/verification.dart';
import 'package:dashboard_new/Tailor_views/home_screen/home.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/view/forgot_password.dart';
import 'package:dashboard_new/view/forgot_password_tailor.dart';
import 'package:dashboard_new/widgets_common/applogo_widget.dart';
import 'package:dashboard_new/widgets_common/button.dart';
import 'package:dashboard_new/widgets_common/cuton_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var controller = Get.put(AuthController());
  var isCustomer = true.obs;

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
          Get.offAll(() => const Home());
        } else {
          DocumentSnapshot tailorDoc = await FirebaseFirestore.instance
              .collection(usersCollection1)
              .doc(user.uid)
              .get();

          if (tailorDoc.exists) {
            final data = tailorDoc.data() as Map<String, dynamic>;
            final bool verified = data['verified'] ?? false;
            Get.offAll(verified == true ? () => const Home_Tailor() : () => const VerifyUser());
          }
        }
      } catch (e) {
        debugPrint("Error fetching user document: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Background
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
                  
                  // Login Card
                  Obx(() => Container(
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
                        // Custom Tab Switcher (Customer | Tailor)
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
                                  onTap: () => isCustomer(true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: isCustomer.value ? redColor : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: isCustomer.value 
                                          ? [BoxShadow(color: redColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] 
                                          : [],
                                    ),
                                    child: "Customer"
                                        .text
                                        .fontFamily(bold)
                                        .color(isCustomer.value ? whiteColor : fontGrey)
                                        .center
                                        .make(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => isCustomer(false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: !isCustomer.value ? redColor : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: !isCustomer.value 
                                          ? [BoxShadow(color: redColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] 
                                          : [],
                                    ),
                                    child: "Tailor"
                                        .text
                                        .fontFamily(bold)
                                        .color(!isCustomer.value ? whiteColor : fontGrey)
                                        .center
                                        .make(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        25.heightBox,
                        
                        // Dynamic Title
                        "Welcome ${isCustomer.value ? "Customer" : "Tailor"}!"
                            .text
                            .fontFamily(bold)
                            .size(22)
                            .color(darkFontGrey)
                            .make(),
                        5.heightBox,
                        "Log in to continue".text.color(fontGrey).make(),
                        20.heightBox,
                        
                        // Input Fields
                        customTextField(email, emailHint, controller.emailController, false),
                        12.heightBox,
                        customTextField(password, passwordHint, controller.passwordController, true),
                        
                        // Forget Password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => isCustomer.value ? const ForgotPassword() : const ForgotPassword_t());
                            },
                            child: forgetPass.text.color(redColor).fontFamily(bold).make(),
                          ),
                        ),
                        
                        10.heightBox,
                        
                        // Login Action Button
                        controller.isloading.value
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
                            Get.to(() => isCustomer.value 
                                ? const SignupScreen(type: "Customer")
                                : const SignupScreen_Tailor(type: "Tailor"));
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
                  )),
                  
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
    if (controller.emailController.text.isEmpty || controller.passwordController.text.isEmpty) {
      VxToast.show(context, msg: "Please enter email and password");
      return;
    }

    controller.isloading(true);
    try {
      await controller.loginMethod(context).then((value) async {
        if (value != null) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            String collection = isCustomer.value ? usersCollection : usersCollection1;
            DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection(collection).doc(user.uid).get();
            
            if (!userSnapshot.exists) {
               VxToast.show(context, msg: "Account not found for this user type.");
               await FirebaseAuth.instance.signOut();
               controller.isloading(false);
               return;
            }

            final data = userSnapshot.data() as Map<String, dynamic>;
            final String uType = data['type'];
            
            if (uType == (isCustomer.value ? "Customer" : "Tailor")) {
              VxToast.show(context, msg: logedin);
              if (isCustomer.value) {
                Get.offAll(() => const Home());
              } else {
                final bool verified = data['verified'] ?? false;
                Get.offAll(verified == true ? () => const Home_Tailor() : () => const VerifyUser());
              }
            } else {
              VxToast.show(context, msg: "Incorrect user type selected.");
              await FirebaseAuth.instance.signOut();
            }
          }
        }
      });
    } catch (e) {
      debugPrint("Login error: $e");
      VxToast.show(context, msg: "Login failed. Please check your credentials.");
    } finally {
      controller.isloading(false);
    }
  }
}
