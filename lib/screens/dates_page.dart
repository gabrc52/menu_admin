import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menu_admin/models/constants.dart';
import 'empty_state.dart';
import 'package:menu_admin/models/date_truncation.dart';

class DatesPage extends StatelessWidget {
  const DatesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: datesRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyState('${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final DateTime inicio = DateTime.fromMicrosecondsSinceEpoch(
                (data.get('inicio') as Timestamp).microsecondsSinceEpoch)
            .truncate();
        final DateTime fin = DateTime.fromMicrosecondsSinceEpoch(
                (data.get('fin') as Timestamp).microsecondsSinceEpoch)
            .truncate();
        bool legacy = data.get('legacy');

        final aYearAgo = DateTime.now().add(const Duration(days: -365));
        final inAYear = DateTime.now().add(const Duration(days: 365));

        return ListView(
          children: [
            ListTile(
              title: const Text('Inicio del semestre'),
              trailing: Text(inicio.toString().split(' ')[0]),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: inicio,
                  firstDate: aYearAgo,
                  lastDate: inAYear,
                );
                if (date != null) {
                  await datesRef.set({
                    'inicio': date,
                    'fin': fin,
                    'legacy': legacy,
                  });
                }
              },
            ),
            ListTile(
              title: const Text('Fin del semestre'),
              trailing: Text(fin.toString().split(' ')[0]),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: fin,
                  firstDate: aYearAgo,
                  lastDate: inAYear,
                );
                if (date != null) {
                  await datesRef.set({
                    'inicio': inicio,
                    'fin': date,
                    'legacy': legacy,
                  });
                }
              },
            ),
            SwitchListTile.adaptive(
              title: const Text('Comportamiento anterior'),
              subtitle: const Text(
                  'Esto hace que el menú empiece un día antes (ej. domingo) mostrando el menú del lunes. Útil para mostrar avisos'),
              value: legacy,
              onChanged: (value) async {
                await datesRef.set({
                  'inicio': inicio,
                  'fin': fin,
                  'legacy': value,
                });
              },
            ),
          ],
        );
      },
    );
  }
}
