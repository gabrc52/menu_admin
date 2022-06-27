import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú: ADMIN'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
            ),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}
