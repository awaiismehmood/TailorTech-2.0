import 'package:dashboard_new/Tailor_views/auth_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget{
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.offAll(()=> const LoginScreen_Tailor(type: 'Tailor',)) , icon: const Icon(CupertinoIcons.clear)
       ), ],
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/images/check_mail.png"),),
              const SizedBox(height: 32,),
              const Text("Verify your E-mail!",textAlign: TextAlign.center,),
              const SizedBox(height: 32,),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(const LoginScreen_Tailor(type: "Tailor",)),style: ElevatedButton.styleFrom(backgroundColor: Colors.red, ),
              child: const Text("Continue", style: TextStyle(color: Colors.white)),
              ),
            ),


            ],
          ),
        ),
      ),

    );
  }
}
