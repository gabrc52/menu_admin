import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:menu_admin/models/constants.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterFireUIAuth.configureProviders(providerConfigs);
  runApp(const App());
}
