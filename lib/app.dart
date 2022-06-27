import 'package:flutter/material.dart';
import 'package:menu_admin/screens/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.blueGrey,
          secondary: Colors.amber,
        ),
      ),
      routes: {
        '/': (context) => const HomePage(),
      },
    );
  }
}
