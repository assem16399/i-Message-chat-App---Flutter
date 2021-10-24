import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imessage/screens/splash_screen.dart';

import './screens/auth_screen.dart';
import './screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, appSnapshot) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.cyan,
              ).copyWith(secondary: Colors.yellowAccent),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                  foregroundColor:
                      MaterialStateProperty.all(Colors.yellowAccent),
                ),
              ),
            ),
            home: appSnapshot.connectionState != ConnectionState.done
                ? const SplashScreen()
                : StreamBuilder(
                    //TODO stream: FirebaseAuth.instance.onAuthStateChanged
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, streamDataSnapshot) {
                      if (streamDataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(
                            child: Text('Loading..'),
                          ),
                        );
                      }
                      if (streamDataSnapshot.hasData) {
                        return const ChatScreen();
                      }
                      return const AuthScreen();
                    },
                  ));
      },
    );
  }
}
