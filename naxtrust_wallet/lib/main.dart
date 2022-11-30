//@dart=2.9
import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cryptowallet/firebase_options.dart';
import 'package:cryptowallet/screens/confirm_seed_phrase.dart';
import 'package:cryptowallet/config/colors.dart';
import 'package:cryptowallet/config/illustrations.dart';
import 'package:cryptowallet/config/styles.dart';
import 'package:cryptowallet/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.light,
                /* light theme settings */
                fontFamily: 'Mulish'),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: background,
                backgroundColor: blackBackground,
                dividerColor: iconColorDark,
                primaryColor: primaryColor,
                hintColor: fontSecondaryColorDark,
                canvasColor: grayBackground,
                cardColor: grayBackground,

                /* dark theme settings */
                fontFamily: 'Mulish'),
            themeMode: currentMode,
            home: MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  child: logo,
                ),
                Text(
                  "NaxTrust",
                  style: splashTitle,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
