import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menu_admin/models/constants.dart';
import 'package:menu_admin/models/info.dart';
import 'package:menu_admin/screens/empty_state.dart';
import 'package:menu_admin/screens/info_edit_page.dart';
import 'package:universal_platform/universal_platform.dart';

class Fab extends FloatingActionButton {
  Fab(BuildContext context, {Key? key})
      : super.extended(
          onPressed: () async {
            final navigator = Navigator.of(context);
            final doc = await infoRef.add(const Info());
            navigator.push(
              MaterialPageRoute(
                builder: (context) => InfoEditPage(id: doc.id),
                fullscreenDialog: true,
              ),
            );
          },
          label: const Text('Agregar aviso'),
          icon: const Icon(Icons.add),
          key: key,
        );
}

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  List<DateTime?> _getDuplicateDates(QuerySnapshot<Info> data) {
    Map<DateTime?, int> count = {};
    List<DateTime?> duplicateDates = [];
    for (var doc in data.docs) {
      final info = doc.data();
      count[info.date] ??= 0;
      count[info.date] = count[info.date]! + 1;
    }
    for (var entry in count.entries) {
      if (entry.value > 1) {
        duplicateDates.add(entry.key);
      }
    }
    return duplicateDates;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Info>>(
      stream: infoRef.orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyState('${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.requireData;
        final duplicates = _getDuplicateDates(data);
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: data.size + (duplicates.isNotEmpty ? 1 : 0),
          itemBuilder: (context, index) {
            if (duplicates.isNotEmpty && index == 0) {
              final duplicatesStr = duplicates
                  .map((e) => e == null ? '*' : e.toString().split(' ')[0])
                  .join(', ');
              return Card(
                color: Colors.red[800],
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      'Error: La app no permite más de un aviso por fecha',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      'Las siguientes fechas tienen más de un aviso: $duplicatesStr. Por favor elimina los avisos de más.',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              );
            }
            if (duplicates.isNotEmpty) {
              index--;
            }
            final Info info = data.docs[index].data();
            return info.toListTile(
              onEditPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => InfoEditPage(
                    id: data.docs[index].id,
                    info: data.docs[index].data(),
                  ),
                ),
              ),
              onDeletePressed: () {
                noButton(BuildContext context) => TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                yesButton(BuildContext context) => TextButton(
                      child: const Text('Sí, eliminar'),
                      onPressed: () {
                        infoRef.doc(data.docs[index].id).delete();
                        Navigator.of(context).pop();
                      },
                    );
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('¿Seguro que deseas eliminar el aviso?'),
                    content: Text(
                        '"${info.title}" el ${info.date.toString().split(' ')[0]}'),
                    actions: [
                      yesButton(context),
                      noButton(context),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
