import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:menu_admin/screens/auth_gate.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.blueGrey,
          secondary: Colors.amber,
        ),
      ),
      localizationsDelegates: [
        // Delegates below take care of built-in flutter widgets
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        // This delegate is required to provide the labels that are not overridden by LabelOverrides
        FlutterFireUILocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'MX')],
      home: const AuthGate(),
      routes: {
        '/profile': (context) => ProfileScreen(
              appBar: AppBar(
                title: const Text('Cuenta'),
              ),
              actions: [
                SignedOutAction(
                  (context) {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
      },
    );
  }
}
