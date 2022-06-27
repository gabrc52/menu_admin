import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/auth.dart';

const providerConfigs = [
  GoogleProviderConfiguration(
    clientId:
        '389614655242-1c9irdpoa824anr9krahgvs875uhoe8f.apps.googleusercontent.com',
  ),
];

final db = FirebaseFirestore.instance;
final datesRef = db.collection('fechas').doc('semestre');
final updatesRef = db.collection('updates').doc('updates');
