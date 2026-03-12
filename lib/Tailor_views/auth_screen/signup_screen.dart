import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_provider.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:dashboard_new/widgets_common/applogo_widget.dart';
import 'package:dashboard_new/widgets_common/bg_widgets.dart';
import 'package:dashboard_new/widgets_common/button.dart';
import 'package:dashboard_new/widgets_common/cuton_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupScreen_Tailor extends ConsumerStatefulWidget {
  final String type;
  const SignupScreen_Tailor({required this.type, super.key});

  @override
  ConsumerState<SignupScreen_Tailor> createState() => _SignupScreenTailorState();
}

class _SignupScreenTailorState extends ConsumerState<SignupScreen_Tailor> {
  bool isCheck = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRetypeController = TextEditingController();
  final phoneController = TextEditingController();
  final cnicController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordRetypeController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    super.dispose();
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  bool isEmailValid(String email) {
    final RegExp regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return bgWidget(
      Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  (context.screenHeight * 0.1).heightBox,
                  applogoWidget(),
                  10.heightBox,
                  "Join $appname".text.fontFamily(bold).white.size(18).make(),
                  10.heightBox,
                  "Tailor".text.fontFamily(bold).white.size(18).make(),
                  10.heightBox,
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: context.screenWidth - 70,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        customTextField(name, nameHint, nameController, false),
                        customTextField(email, emailHint, emailController, false),
                        customTextField(password, passwordHint, passwordController, true),
                        customTextField(retypepass, retypepassHint, passwordRetypeController, true),
                        customTextField(phone, phoneHint, phoneController, false),
                        customTextField(Cnic, cnicHint, cnicController, false),
                        5.heightBox,
                        Row(
                          children: [
                            Checkbox(
                              checkColor: whiteColor,
                              activeColor: redColor,
                              value: isCheck,
                              onChanged: (newValue) {
                                setState(() {
                                  isCheck = newValue ?? false;
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
                                      style: TextStyle(fontFamily: regular, color: fontGrey),
                                    ),
                                    TextSpan(
                                      text: terms,
                                      style: TextStyle(fontFamily: regular, color: redColor),
                                    ),
                                    TextSpan(
                                      text: " & ",
                                      style: TextStyle(fontFamily: regular, color: fontGrey),
                                    ),
                                    TextSpan(
                                      text: priacyPol,
                                      style: TextStyle(fontFamily: regular, color: redColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        authState.isLoading
                            ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(redColor))
                            : ourButton(
                                onPress: () async {
                                  if (!isCheck) return;

                                  final email = emailController.text;
                                  final password = passwordController.text;
                                  final phone = phoneController.text;

                                  if (!isEmailValid(email)) {
                                    VxToast.show(context, msg: "Please enter a valid email address.");
                                    return;
                                  }

                                  if (phone.length != 11 || !isNumeric(phone)) {
                                    VxToast.show(context, msg: "Please enter a valid 11-digit phone number.");
                                    return;
                                  }
                                  
                                  if (password != passwordRetypeController.text) {
                                    VxToast.show(context, msg: "Passwords do not match.");
                                    return;
                                  }

                                  try {
                                    final value = await authNotifier.signupMethod(email, password, context);
                                    if (value != null) {
                                      await authNotifier.storeTailorData(
                                        name: nameController.text,
                                        password: passwordController.text,
                                        email: email,
                                        type: widget.type,
                                        phone: phone,
                                        cnic: cnicController.text,
                                        verified: false,
                                      );
                                      if (mounted) {
                                        context.go(AppRoutes.tailorEmailVerify);
                                      }
                                    }
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                },
                                color: isCheck ? redColor : lightGrey,
                                textcolor: whiteColor,
                                tit: signup,
                              ).box.width(context.screenWidth).make(),
                        10.heightBox,
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: already,
                                style: TextStyle(fontFamily: bold, color: fontGrey),
                              ),
                              TextSpan(
                                text: login,
                                style: TextStyle(fontFamily: bold, color: redColor),
                              ),
                            ],
                          ),
                        ).onTap(() {
                          context.pop();
                        }),
                      ],
                    ),
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
