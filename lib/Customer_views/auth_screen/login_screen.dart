import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_new/Customer_views/auth_screen/signup_screen.dart';
import 'package:dashboard_new/Customer_views/home_screen/home.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/view/forgot_password.dart';
import 'package:dashboard_new/widgets_common/applogo_widget.dart';
import 'package:dashboard_new/widgets_common/bg_widgets.dart';
import 'package:dashboard_new/widgets_common/button.dart';
import 'package:dashboard_new/widgets_common/cuton_textfield.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final String type;
  const LoginScreen({required this.type, super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.put(AuthController());

  //textcontrollers

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.08).heightBox,
              applogoWidget(),
              10.heightBox,
              "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
                () =>
                    Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: customTextField(
                                email,
                                emailHint,
                                controller.emailController,
                                false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: customTextField(
                                password,
                                passwordHint,
                                controller.passwordController,
                                true,
                              ),
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
                                            const ForgotPassword(),
                                      ),
                                    );
                                  },
                                  child: forgetPass.text.make(),
                                ),
                              ),
                            ),
                            5.heightBox,
                            controller.isloading.value
                                ? const CircularProgressIndicator(
                                    color: redColor,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ourButton(
                                      onPress: () async {
                                        controller.isloading(true);

                                        try {
                                          await controller.loginMethod(context).then((
                                            value,
                                          ) async {
                                            if (currentUser != null) {
                                              DocumentSnapshot? userSnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                        usersCollection,
                                                      )
                                                      .doc(currentUser!.uid)
                                                      .get();
                                              final data =
                                                  userSnapshot.data()
                                                      as Map<String, dynamic>;
                                              final String uType = data['type'];
                                              if (value != null) {
                                                if (uType == widget.type) {
                                                  // ignore: use_build_context_synchronously
                                                  VxToast.show(
                                                    context,
                                                    msg: logedin,
                                                  );
                                                  Get.offAll(
                                                    () => const Home(),
                                                  );
                                                } else {
                                                  // ignore: use_build_context_synchronously
                                                  VxToast.show(
                                                    context,
                                                    msg: "User type mismatch",
                                                  );
                                                }
                                              } else {
                                                // ignore: use_build_context_synchronously
                                                VxToast.show(
                                                  context,
                                                  msg: "Login failed",
                                                );
                                              }
                                            }
                                          });
                                        } catch (error) {
                                          // ignore: use_build_context_synchronously
                                          VxToast.show(
                                            context,
                                            msg: "Invalid Credentials",
                                          );
                                        } finally {
                                          controller.isloading(
                                            false,
                                          ); // Ensure loader is stopped
                                        }
                                      },
                                      color: redColor,
                                      textcolor: whiteColor,
                                      tit: login,
                                    ).box.width(context.screenWidth).make(),
                                  ),
                            5.heightBox,
                            create.text.color(fontGrey).make(),
                            5.heightBox,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ourButton(
                                onPress: () {
                                  /*Get.to(() => const SignupScreen(
                                    type: widget.type,
                                  ));*/
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SignupScreen(type: widget.type),
                                    ),
                                  );
                                },
                                color: lightGolden,
                                textcolor: redColor,
                                tit: signup,
                              ).box.width(context.screenWidth).make(),
                            ),
                            10.heightBox,
                          ],
                        ).box.white.rounded
                        .padding(const EdgeInsets.all(16))
                        .width(context.screenWidth - 70)
                        .shadowSm
                        .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
