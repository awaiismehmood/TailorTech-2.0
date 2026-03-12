import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/controllers/auth_provider.dart';
import 'package:dashboard_new/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widgets.dart';
import '../../widgets_common/button.dart';
import '../../widgets_common/cuton_textfield.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final String type;
  const SignupScreen({required this.type, super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  bool isCheck = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRetypeController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordRetypeController.dispose();
    phoneController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  (context.screenHeight * 0.1).heightBox,
                  applogoWidget(),
                  10.heightBox,
                  "Join $appname".text.fontFamily(bold).white.size(18).make(),
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
                                  
                                  if (!isEmailValid(email)) {
                                    VxToast.show(context, msg: "Please enter a valid email address.");
                                    return;
                                  }
                                  
                                  if (password != passwordRetypeController.text) {
                                    VxToast.show(context, msg: "Passwords do not match.");
                                    return;
                                  }

                                  try {
                                    final value = await authNotifier.signupMethod(email, password, context);
                                    if (value != null) {
                                      await authNotifier.storeUserData(
                                        name: nameController.text,
                                        password: passwordController.text,
                                        email: email,
                                        type: widget.type,
                                        phone: phoneController.text,
                                      );
                                      if (mounted) {
                                        context.go(AppRoutes.customerEmailVerify);
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
