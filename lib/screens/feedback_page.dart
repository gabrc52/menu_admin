import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:menu_admin/models/constants.dart';
import 'package:menu_admin/models/feedback_entry.dart';
import 'package:menu_admin/screens/feedback_view_page.dart';

import 'empty_state.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  String clippedText(String text) {
    const maxLength = 300;
    text = text.replaceAll('\n', '');
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)} ... (clic para ver completo)';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<FeedbackEntry>>(
      stream: feedbackRef.orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyState('${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.requireData;
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: data.size,
          itemBuilder: (context, index) {
            final FeedbackEntry entry = data.docs[index].data();
            return Card(
              elevation: 5,
              child: ListTile(
                subtitle: Text(
                  clippedText(entry.feedback),
                ),
                title: Text('Enviado ${entry.date}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FeedbackViewPage(entry: entry),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
