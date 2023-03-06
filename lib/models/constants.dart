import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/auth.dart';

import 'info.dart';
import 'feedback_entry.dart';

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
final menuRef = db.collection('menu').doc('json');
final feedbackRef = db.collection('feedback').withConverter<FeedbackEntry>(
      fromFirestore: (snapshot, _) => FeedbackEntry.fromJson(snapshot.data()),
      toFirestore: (feedback, _) => feedback.toJson(),
    );

const meses = <String>[
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic'
];

const dias = <String>['lun', 'mar', 'mié', 'jue', 'vie', 'sáb', 'dom'];
const diasCompletos = <String>[
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo'
];

const failedFeedbackErrorMessage =
    'Si recibiste esta notificación es porque ocurrió un error. Por favor ve a enviar comentarios y haznos saber.';
