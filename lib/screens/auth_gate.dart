import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:menu_admin/screens/home.dart';

/// https://github.com/firebase/flutterfire/blob/master/packages/flutterfire_ui/doc/auth/integrating-your-first-screen.md

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // If the user is already signed-in, use it as initial data
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const SignInScreen(
            showAuthActionSwitch: false,
          );
        }

        // Render application if authenticated
        return HomePage(user: snapshot.data!);
      },
    );
  }
}
