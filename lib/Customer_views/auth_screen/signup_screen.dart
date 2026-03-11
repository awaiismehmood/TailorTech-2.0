import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/view/verify_email_customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widgets.dart';
import '../../widgets_common/button.dart';
import '../../widgets_common/cuton_textfield.dart';

class SignupScreen extends StatefulWidget {
  final String type;
  const SignupScreen({required this.type, super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //textcontrollers

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwrodController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  var phoneController = TextEditingController();

  // Function to validate email format
  bool isEmailValid(String email) {
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  (context.screenHeight * 0.1).heightBox,
                  applogoWidget(),
                  10.heightBox,
                  "Join $appname".text.fontFamily(bold).white.size(18).make(),
                  10.heightBox,
                  Obx(
                    () =>
                        Column(
                              children: [
                                customTextField(
                                  name,
                                  nameHint,
                                  nameController,
                                  false,
                                ),
                                customTextField(
                                  email,
                                  emailHint,
                                  emailController,
                                  false,
                                ),
                                customTextField(
                                  password,
                                  passwordHint,
                                  passwrodController,
                                  true,
                                ),
                                customTextField(
                                  retypepass,
                                  retypepassHint,
                                  passwordRetypeController,
                                  true,
                                ),
                                customTextField(
                                  phone,
                                  phoneHint,
                                  phoneController,
                                  false,
                                ),
                                5.heightBox,
                                Row(
                                  children: [
                                    Checkbox(
                                      checkColor: whiteColor,
                                      activeColor: redColor,
                                      value: isCheck,
                                      onChanged: (newValue) {
                                        setState(() {
                                          isCheck = newValue;
                                        });
                                      },
                                    ),
                                    5.widthBox,
                                    Expanded(
                                      child: RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "I agree to the ",
                                              style: TextStyle(
                                                fontFamily: regular,
                                                color: fontGrey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: terms,
                                              style: TextStyle(
                                                fontFamily: regular,
                                                color: redColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " & ",
                                              style: TextStyle(
                                                fontFamily: regular,
                                                color: fontGrey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: priacyPol,
                                              style: TextStyle(
                                                fontFamily: regular,
                                                color: redColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                controller.isloading.value
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                          redColor,
                                        ),
                                      )
                                    : ourButton(
                                        onPress: () async {
                                          final email = emailController.text;
                                          final password =
                                              passwrodController.text;
                                          if (!isEmailValid(email)) {
                                            // Show error message if email is not valid
                                            VxToast.show(
                                              context,
                                              msg:
                                                  "Please enter a valid email address.",
                                            );
                                            return;
                                          }
                                          if (isCheck != false) {
                                            controller.isloading(true);
                                            try {
                                              await controller
                                                  .signupMethod(
                                                    email,
                                                    password,
                                                    context,
                                                  )
                                                  .then((value) {
                                                    return controller
                                                        .storeuserData(
                                                          context: context,
                                                          email: emailController
                                                              .text,
                                                          name: nameController
                                                              .text,
                                                          password:
                                                              passwrodController
                                                                  .text,
                                                          type: widget.type,
                                                          phone: phoneController
                                                              .text,
                                                          profileImageurl: " ",
                                                          online: false,
                                                        );
                                                  })
                                                  .then((value) {
                                                    // VxToast.show(context, msg: logedin);
                                                    Get.offAll(
                                                      () =>
                                                          const VerifyEmailScreen_cust(),
                                                    );
                                                  });
                                            } catch (e) {
                                              auth.signOut();
                                              // VxToast.show(context, msg: e.toString());
                                            }
                                            controller.isloading(false);
                                          }
                                        },
                                        color: isCheck == true
                                            ? redColor
                                            : lightGrey,
                                        textcolor: whiteColor,
                                        tit: signup,
                                      ).box.width(context.screenWidth).make(),
                                10.heightBox,
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: already,
                                        style: TextStyle(
                                          fontFamily: bold,
                                          color: fontGrey,
                                        ),
                                      ),
                                      TextSpan(
                                        text: login,
                                        style: TextStyle(
                                          fontFamily: bold,
                                          color: redColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ).onTap(() {
                                  Get.back();
                                }),
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
        ),
      ),
    );
  }
}
