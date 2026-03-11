// ignore_for_file: camel_case_types

import 'dart:developer';

import 'package:dashboard_new/Tailor_views/chat/chat_page%20.dart';
import 'package:dashboard_new/Tailor_views/chat/chat_service.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/widgets_common/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class chatHomeT extends StatelessWidget {
  chatHomeT({super.key});

  final chatServiceT _chatService = chatServiceT();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(T_logo), opacity: 0.5),
            color: whiteColor),
        child: Scaffold(
          // backgroundColor: whiteColor,
          appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white70, // You can change the border color here
                width: 2.0, // You can adjust the border width here
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Chat - Home',
                style: TextStyle(
                  color: whiteColor,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: redColor,
        actions: const [
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () {
          //     // Navigator.restorablePushNamed(context, SettingsView.routeName);
          //   },
          // ),
        ],
      ),
          body: _buildUserList(),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(currentUser!.uid),
      builder: (context, snapshot) {
        // error

        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading..

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitPulse(
              color: redColor,
              size: 100.0,
            ),
          );
        }

        //return listview

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all user except current
    log("iam in chat home");
    return userTile(
      text: userData["email"],
      ontap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => chatPageT(
              recieverEmail: userData["email"],
              reciverID: userData["id"],
            ),
          ),
        );
      }),
    );
  }
}
