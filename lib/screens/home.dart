import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'dates_page.dart';
import 'menu_page.dart';
import 'feedback_page.dart';
import 'launch_page.dart';
import 'info_page.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = Hive.box('navigation').get('index', defaultValue: 1);

  @override
  Widget build(BuildContext context) {
    const titles = ['Lanzar', 'Avisos', 'Menú', 'Fechas', 'Feedback'];
    const icons = [
      Icons.rocket,
      Icons.info,
      Icons.restaurant,
      Icons.date_range,
      Icons.feedback
    ];
    final size = titles.length;

    return AdaptiveNavigationScaffold(
      fabInRail: false,
      selectedIndex: _index,
      onDestinationSelected: (index) {
        setState(() => _index = index);
        Hive.box('navigation').put('index', index);
      },
      destinations: [
        for (int i = 0; i < size; i++)
          AdaptiveScaffoldDestination(title: titles[i], icon: icons[i])
      ],
      appBar: AdaptiveAppBar(
        title: Text('Menú ADMIN: ${titles[_index]}'),
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
        const FeedbackPage(),
      ][_index],
      floatingActionButton: _index == 1 ? Fab() : null,
    );
  }
}
