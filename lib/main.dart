import 'package:dashboard_new/routes/app_router.dart';
import 'package:dashboard_new/consts/colors.dart';
import 'package:dashboard_new/consts/strings.dart';
import 'package:dashboard_new/consts/styles.dart';
import 'package:dashboard_new/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: darkFontGrey),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        fontFamily: regular,
      ),
      routerConfig: goRouter,
    );
  }
}
