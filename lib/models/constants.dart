import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/auth.dart';

import 'info.dart';

const providerConfigs = [
  GoogleProviderConfiguration(
    clientId:
        '389614655242-1c9irdpoa824anr9krahgvs875uhoe8f.apps.googleusercontent.com',
  ),
];

final db = FirebaseFirestore.instance;
final datesRef = db.collection('fechas').doc('semestre');
final updatesRef = db.collection('updates').doc('updates');
final infoRef = db.collection('info').withConverter<Info>(
      fromFirestore: (snapshot, _) => Info.fromJson(snapshot.data()),
      toFirestore: (info, _) => info.toJson(),
    );
