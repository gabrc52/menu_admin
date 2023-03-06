import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:menu_admin/models/constants.dart';

class FeedbackEntry {
  const FeedbackEntry({
    this.buildNumber,
    required this.date,
    required this.feedback,
    this.token,
    this.type,
  });

  final String? buildNumber;
  final DateTime date;
  final String feedback;
  final String? token;
  final String? type;

  factory FeedbackEntry.fromJson(Map<String, dynamic>? json) {
    assert(json != null);
    return FeedbackEntry(
      buildNumber: json!['buildNumber'],
      date: (json['date'] as Timestamp).toDate(),
      feedback: json['feedback'],
      type: json['type'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buildNumber': buildNumber,
      'date': date,
      'feedback': feedback,
      'type': type,
      'token': token,
    };
  }

  Future<void> respondWithNotification(String response) async {
    final notificationRef = db.collection('admin').doc('notifications');
    final firebaseServerKey = (await notificationRef.get()).data()!['key'];

    // https://github.com/firebase/quickstart-js/tree/master/messaging#http
    // TODO: https://firebase.google.com/docs/cloud-messaging/migrate-v1
    // MIGRATE TO NEWER API
    final result = await http.post(
      Uri.https('fcm.googleapis.com', '/fcm/send'),
      headers: {
        'Authorization': 'key=$firebaseServerKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'notification': {
          'title': 'Respuesta a tu comentario',
          'body': response,
        },
        'to': token,
      }),
    );
    print(result.body);
    assert(result.statusCode == 200);

    /// TODO: parse the result as JSON
    /// And show error if r['success'] == 0, or r['failure'] == 1
    /// Mostrar mensaje "comentario enviado exitosamente" si r['success'] == 1
  }
}
