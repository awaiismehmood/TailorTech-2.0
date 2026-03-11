import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Tailor_views/auth_screen/signup_screen.dart';
import 'package:dashboard_new/Tailor_views/auth_screen/verification.dart';
import 'package:dashboard_new/Tailor_views/home_screen/home.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/view/forgot_password_tailor.dart';
import 'package:dashboard_new/widgets_common/applogo_widget.dart';
import 'package:dashboard_new/widgets_common/bg_widgets.dart';
import 'package:dashboard_new/widgets_common/button.dart';
import 'package:dashboard_new/widgets_common/cuton_textfield.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class LoginScreen_Tailor extends StatefulWidget {
  final String type;
  const LoginScreen_Tailor({required this.type, super.key});

  @override
  State<LoginScreen_Tailor> createState() => _LoginScreenTailorState();
}

class _LoginScreenTailorState extends State<LoginScreen_Tailor> {
  var controller1 = Get.put(AuthController());

//textcontrollers

  @override
  Widget build(BuildContext context) {
    return bgWidget(Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.08).heightBox,
            applogoWidget(),
            10.heightBox,
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            //2.heightBox,
            "As Tailor".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customTextField(
                        email, emailHint, controller1.emailController, false),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customTextField(password, passwordHint,
                        controller1.passwordController, true),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword_t()));
                        },
                        child: forgetPass.text.make(),
                      ),
                    ),
                  ),
                  5.heightBox,
                  controller1.isloading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ourButton(
                                  onPress: () async {
                                    controller1.isloading(true);
                                    try {
                                      await controller1
                                          .loginMethod(context)
                                          .then((value) async {
                                        DocumentSnapshot userSnapshot =
                                            await FirebaseFirestore.instance
                                                .collection(usersCollection1)
                                                .doc(currentUser!.uid)
                                                .get();
                                        final data = userSnapshot.data()
                                            as Map<String, dynamic>;
                                        final String uType = data['type'];
                                        final bool verified = data['verified'];
                                        if (value != null) {
                                          if (uType == widget.type) {
                                            // ignore: use_build_context_synchronously
                                            VxToast.show(context, msg: logedin);
                                            Get.offAll(verified == true
                                                ? () => const Home_Tailor()
                                                : () => const VerifyUser());
                                          } else {
                                            setState(() {
                                              VxToast.show(context,
                                                  msg: "Incorrect user type");
                                              controller1.isloading(false);
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            controller1.isloading(false);
                                          });
                                        }
                                      });
                                    } catch (e) {
                                      setState(() {
                                        controller1.isloading(
                                            false); // Stop loading indicator on error
                                      });
                                      // ignore: use_build_context_synchronously
                                      //VxToast.show(context, msg: e.toString());
                                    }
                                  },
                                  color: redColor,
                                  textcolor: whiteColor,
                                  tit: login)
                              .box
                              .width(context.screenWidth)
                              .make(),
                        ),
                  5.heightBox,
                  create.text.color(fontGrey).make(),
                  5.heightBox,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ourButton(
                            onPress: () {
                              /*Get.to(() => const SignupScreen_Tailor(
                                    type: widget.type,
                                  ));*/
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SignupScreen_Tailor(type: widget.type),
                                ),
                              );
                            },
                            color: lightGolden,
                            textcolor: redColor,
                            tit: signup)
                        .box
                        .width(context.screenWidth)
                        .make(),
                  ),
                  10.heightBox,
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ),
          ],
        ),
      ),
    ));
  }
}
