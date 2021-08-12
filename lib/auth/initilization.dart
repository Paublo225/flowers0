import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowers0/auth/auth.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // If Firebase App init, snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        // Connection Initialized - Firebase App is running
        if (snapshot.connectionState == ConnectionState.done) {
          // StreamBuilder can check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              // If Stream Snapshot has error
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              // Connection state active - Do the user login check inside the
              // if statement
              if (streamSnapshot.connectionState == ConnectionState.active) {
                // Get the user
                User _user = streamSnapshot.data;

                // If the user is null, we're not logged in
                if (_user == null) {
                  // user not logged in, head to login
                  return AuthPage();
                } else {
                  // The user is logged in, head to homepage
                  return DefaultTabBar();
                }
              }

              // Checking the auth state - Loading
              return Scaffold(
                body: Center(
                  child: Text(
                    "Проверка аутентификации...",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          );
        }

        // Connecting to Firebase - Loading
        return Scaffold(
          body: Center(
            child: Text(
              "Инициализация...",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}
