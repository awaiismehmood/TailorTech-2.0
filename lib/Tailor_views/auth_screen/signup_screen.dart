import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_controller.dart';
import 'package:dashboard_new/view/verify_email.dart';
import 'package:dashboard_new/widgets_common/applogo_widget.dart';
import 'package:dashboard_new/widgets_common/bg_widgets.dart';
import 'package:dashboard_new/widgets_common/button.dart';
import 'package:dashboard_new/widgets_common/cuton_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen_Tailor extends StatefulWidget {
  final String type;
  const SignupScreen_Tailor({required this.type, super.key});

  @override
  State<SignupScreen_Tailor> createState() => _SignupScreenTailorState();
}

class _SignupScreenTailorState extends State<SignupScreen_Tailor> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //textcontrollers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwrodController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  var phoneController = TextEditingController();
  var cnicController = TextEditingController();

  bool isNumeric(String str) {
    // ignore: unnecessary_null_comparison
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

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
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    (context.screenHeight * 0.1).heightBox,
                    applogoWidget(),
                    10.heightBox,
                    "Join $appname".text.fontFamily(bold).white.size(18).make(),
                    10.heightBox,
                    "Tailor".text.fontFamily(bold).white.size(18).make(),
                    10.heightBox,
                    Obx(
                      () => Column(
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
                          customTextField(
                            Cnic,
                            cnicHint,
                            cnicController,
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
                                  valueColor: AlwaysStoppedAnimation(redColor),
                                )
                              : ourButton(
                                  onPress: () async {
                                    final email = emailController.text;
                                    final password = passwrodController.text;
                                    final phone = phoneController.text;

                                    if (!isEmailValid(email)) {
                                      // Show error message if email is not valid
                                      VxToast.show(
                                        context,
                                        msg:
                                            "Please enter a valid email address.",
                                      );
                                      return;
                                    }

                                    if (phone.length != 11 ||
                                        !isNumeric(phone)) {
                                      // Show error message if phone number is not 11 digits or contains non-numeric characters
                                      VxToast.show(
                                        context,
                                        msg:
                                            "Please enter a valid 11-digit phone number.",
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
                                                  .storeTailorData(
                                                    context: context,
                                                    email: emailController.text,
                                                    name: nameController.text,
                                                    password:
                                                        passwrodController.text,
                                                    type: widget.type,
                                                    phone: phoneController.text,
                                                    cnic: cnicController.text,
                                                    profileSetup: false,
                                                    online: false,
                                                    verified: false,
                                                  )
                                                  .then((value) {
                                                    // Only navigate if signup and data storage are successful
                                                    Get.offAll(
                                                      () =>
                                                          const VerifyEmailScreen(),
                                                    );
                                                  });
                                            });
                                      } catch (e) {
                                        auth.signOut();
                                        // Show error message if an exception occurs during signup
                                        //VxToast.show(context, msg: e.toString());
                                      }
                                      controller.isloading(false);
                                    }
                                  },
                                  color: isCheck == true ? redColor : lightGrey,
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
                      ).box.white.rounded.padding(const EdgeInsets.all(16)).width(context.screenWidth - 70).shadowSm.make(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
