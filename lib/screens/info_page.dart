import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menu_admin/models/constants.dart';
import 'package:menu_admin/models/info.dart';
import 'package:menu_admin/screens/empty_state.dart';

class Fab extends FloatingActionButton {
  Fab({Key? key})
      : super.extended(
          onPressed: () {},
          label: const Text('Agregar aviso'),
          icon: const Icon(Icons.add),
          key: key,
        );
}

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

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
        void _showNotImplemented() {
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              backgroundColor: Colors.amber,
              leading: const Icon(Icons.bug_report),
              content: const Text(
                  'Funcionalidad no implementada... (en construcción)'),
              actions: [
                TextButton(
                  child: const Text('De acuerdo'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: data.size,
          itemBuilder: (context, index) {
            return data.docs[index].data().toListTile(
                  onEditPressed: _showNotImplemented,
                  onDeletePressed: _showNotImplemented,
                );
          },
        );
      },
    );
  }
}
