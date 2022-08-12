import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menu_admin/models/constants.dart';
import 'package:menu_admin/models/update.dart';
import 'empty_state.dart';

class LaunchUpdatesButton extends StatelessWidget {
  final IconData icon;
  final String readableName;
  final String internalName;
  final Update lastUpdate;
  const LaunchUpdatesButton({
    Key? key,
    required this.icon,
    required this.readableName,
    required this.internalName,
    required this.lastUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(icon),
          label: Text('Lanzar $readableName'),
          onPressed: () {
            noButton(BuildContext context) => TextButton(
                  child: const Text('No, todavía no'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
            yesButton(BuildContext context) => TextButton(
                  child: const Text('Sí, actualizar'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final snapshot = await updatesRef.get();
                    final data = snapshot.data()!;
                    data[internalName] = lastUpdate.next().number;
                    await updatesRef.set(data);
                  },
                );
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                    '¿Seguro que deseas publicar la actualización de $readableName?'),
                actions: [
                  yesButton(context),
                  noButton(context),
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
              'Últ. act.: ${lastUpdate.updateDate.toString().split(' ')[0]} número ${lastUpdate.dailyAttempt}'),
        )
      ],
    );
  }
}

class LaunchPage extends StatelessWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: updatesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return EmptyState('${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LaunchUpdatesButton(
                icon: Icons.info,
                readableName: 'Avisos',
                internalName: 'info',
                lastUpdate: Update.fromNumber(data['info'] as int),
              ),
              const SizedBox(height: 40),
              LaunchUpdatesButton(
                icon: Icons.restaurant,
                readableName: 'Menú',
                internalName: 'menu',
                lastUpdate: Update.fromNumber(data['menu'] as int),
              ),
              const SizedBox(height: 40),
              LaunchUpdatesButton(
                icon: Icons.date_range,
                readableName: 'Fechas',
                internalName: 'fechas',
                lastUpdate: Update.fromNumber(data['fechas'] as int),
              ),
            ],
          );
        },
      ),
    );
  }
}
