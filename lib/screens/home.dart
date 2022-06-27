import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:menu_admin/screens/dates_page.dart';
import 'package:menu_admin/screens/menu_page.dart';

import 'launch_page.dart';
import 'info_page.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigationScaffold(
      selectedIndex: _index,
      onDestinationSelected: (index) => setState(() => _index = index),
      destinations: const [
        AdaptiveScaffoldDestination(title: 'Lanzar', icon: Icons.rocket_launch),
        AdaptiveScaffoldDestination(title: 'Avisos', icon: Icons.info),
        AdaptiveScaffoldDestination(title: 'Menú', icon: Icons.restaurant),
        AdaptiveScaffoldDestination(title: 'Fechas', icon: Icons.date_range),
      ],
      appBar: AdaptiveAppBar(
        title: const Text('Menú: ADMIN'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoURL!),
            ),
          ),
        ],
      ),
      body: [
        const LaunchPage(),
        const InfoPage(),
        const MenuPage(),
        const DatesPage(),
      ][_index],
    );
  }
}
