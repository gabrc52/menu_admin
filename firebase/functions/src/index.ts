import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!!1");
// });

// export const helloWorldJson = functions.https.onRequest((req, res) => {
//   res.json({hello: "world"});
// });

export const fechas = functions.https.onRequest(async (req, res) => {
  const doc = await db.doc('/json/fechas').get();
  res.header('Content-Type', 'application/json');
  res.send(doc.get('str'));
});

export const info = functions.https.onRequest(async (req, res) => {
  const doc = await db.doc('/json/info').get();
  res.header('Content-Type', 'application/json');
  res.send(doc.get('str'));
});

export const menu = functions.https.onRequest(async (req, res) => {
  const doc = await db.doc('/json/menu').get();
  res.header('Content-Type', 'application/json');
  res.send(doc.get('str'));
});

export const updates = functions.https.onRequest(async (req, res) => {
  const doc = await db.doc('/updates/updates').get();
  res.json(doc.data());
});

export const launchUpdate = functions.firestore.document("/updates/updates").onUpdate(async (change, context) => {
  const backup = async (type: string, change: functions.Change<functions.firestore.QueryDocumentSnapshot>) => {
    console.log(`updating ${type} ${change.before.get(type)} to ${change.after.get(type)}`);
    const old = await db.doc(`/json/${type}`).get();
    db.collection(`/json/${type}/backups`).add({str: old.get("str"), date: change.before.get(type)});
  };

  const save = async (type: string, json: Object) => {
    const jsonStr = JSON.stringify(json);
    await db.doc('/json/fechas/').set({
      'str': jsonStr,
      'date': change.after.get('fechas'),
    });
  };

  /// Fechas
  if (change.before.get("fechas") < change.after.get("fechas")) {
    await backup("fechas", change);

    const doc = await db.doc('/fechas/semestre').get();
    const inicio = doc.get('inicio');
    console.log(inicio);
    // result is Timestamp { _seconds: 1648440000, _nanoseconds: 0 }
    const fin = doc.get('fin');
    console.log(fin);
    const startingDay = doc.get('starting-day');
    const fechas = {
      'inicio': {
        
      },
      'inicio-v2': {
        'starting-day': startingDay,
      },
      'fin': {},
    };

    await save('fechas', fechas);
  }

  /// Info
  if (change.before.get("info") < change.after.get("info")) {
    await backup("info", change);
  }

  /// Menu
  if (change.before.get("menu") < change.after.get("menu")) {
    await backup("menu", change);
  }
});

