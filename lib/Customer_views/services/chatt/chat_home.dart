import 'dart:developer';

import 'package:dashboard_new/Customer_views/services/chatt/chat_page.dart';
import 'package:dashboard_new/Customer_views/services/chatt/chat_service.dart';
import 'package:dashboard_new/consts/consts.dart';
import 'package:dashboard_new/widgets_common/user_tile.dart';
import 'package:flutter/material.dart';

class chatHome extends StatelessWidget {
  chatHome({super.key});

  final chatService _chatService = chatService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(T_logo), opacity: 0.5),
            color: whiteColor),
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            title: const Text("Chat Home"),
            backgroundColor: redColor,
            foregroundColor: whiteColor,
            elevation: 0,
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
          return const Text("Loading..");
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
            builder: (context) => chatPage(
              recieverEmail: userData["email"],
              reciverID: userData["id"],
            ),
          ),
        );
      }),
    );
  }
}
