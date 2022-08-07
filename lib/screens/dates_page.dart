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
        final int startingDay = data.get('starting-day');

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
                    'starting-day': startingDay,
                  });
                }
              },
            ),
            ListTile(
              title: const Text('Día del ciclo inicial'),
              trailing: Text(
                  '$startingDay (semana ${(startingDay - 1) ~/ 7 + 1}, ${diasCompletos[(startingDay - 1) % 7]})'),
              onTap: () async {
                final val = await _showTextInputDialog(context, startingDay);
                if (val != null) {
                  await datesRef.set({
                    'inicio': inicio,
                    'fin': fin,
                    'starting-day': val,
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
                    'starting-day': startingDay,
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<int?> _showTextInputDialog(
      BuildContext context, int initialValue) async {
    final controller = TextEditingController(text: '$initialValue');
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Día del ciclo inicial'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
                hintText: "Día del ciclo (número del 1 al 56)"),
            keyboardType: TextInputType.number,
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                int val = int.parse(controller.text);
                assert(1 <= val && val <= 56);
                Navigator.pop(context, val);
              },
            ),
          ],
        );
      },
    );
  }
}
