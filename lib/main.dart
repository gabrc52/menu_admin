import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hive/hive.dart';
import 'package:menu_admin/models/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// TODO: permissions! this is editable by everyone

// https://stackoverflow.com/questions/65852838/i-get-a-weird-error-when-trying-to-initialize-hive
Future<Box> openHiveBox(String boxName) async {
  if (!kIsWeb && !Hive.isBoxOpen(boxName)) {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }

  return await Hive.openBox(boxName);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterFireUIAuth.configureProviders(providerConfigs);
  await openHiveBox('navigation');

  // One of the most satisfying lines of code to type
  assert(!UniversalPlatform.isIOS);

  runApp(const App());
}
