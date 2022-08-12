import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as assert from 'assert'; /// I need a MODULE to assert?

admin.initializeApp();
const db = admin.firestore();

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

// https://stackoverflow.com/questions/563406/how-to-add-days-to-date
function addDays(date : Date, days : number) {
  var result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

export const launchUpdate = functions.firestore.document("/updates/updates").onUpdate(async (change, context) => {
  const backup = async (type: string, change: functions.Change<functions.firestore.QueryDocumentSnapshot>) => {
    console.log(`updating ${type} ${change.before.get(type)} to ${change.after.get(type)}`);
    const old = await db.doc(`/json/${type}`).get();
    db.collection(`/json/${type}/backups`).add({str: old.get("str"), date: change.before.get(type)});
  };

  const save = async (type: string, json: Object | string, date : string) => {
    let jsonStr : string;
    if (json instanceof Object) {
      jsonStr = JSON.stringify(json); 
    } else {
      jsonStr = json;
    }
    await db.doc(`/json/${type}/`).set({
      'str': jsonStr,
      'date': date,
    });
  };

  const timestampToDate = (timestamp: admin.firestore.Timestamp): Date => {
    const date : Date = new Date(timestamp.seconds * 1000);
    console.log(timestamp, date);
    return date;
  };

  /// Fechas
  if (change.before.get("fechas") < change.after.get("fechas")) {
    await backup("fechas", change);

    const doc = await db.doc('/fechas/semestre').get();
    const inicio = timestampToDate(doc.get('inicio'));
    const fin = timestampToDate(doc.get('fin'));
    const startingDay : number = doc.get('starting-day');
    assert(1 <= startingDay && startingDay <= 56, 'starting day must be between 1 and 56');

    /// En la versión anterior de la app, no se permite establecer el día inicial
    /// Entonces `inicio` sería la fecha necesaria para que en el inicio deseado inicie desde ese día
    // https://stackoverflow.com/questions/563406/how-to-add-days-to-date
    const inicioLegacy = addDays(inicio, -startingDay + 1);

    const fechas = {
      'inicio': {
        'year': inicioLegacy.getUTCFullYear(),
        'month': inicioLegacy.getUTCMonth() + 1, // this one uses zero-indexing
        'day': inicioLegacy.getUTCDate(), // yes, date, not day, fucking javascript
      },
      'inicio-v2': {
        'year': inicio.getUTCFullYear(),
        'month': inicio.getUTCMonth() + 1,
        'day': inicio.getUTCDate(),
        'starting-day': startingDay,
      },
      'fin': {
        'year': fin.getUTCFullYear(),
        'month': fin.getUTCMonth() + 1,
        'day': fin.getUTCDate(),
      },
    };

    await save('fechas', fechas, change.after.get('fechas'));
  }

  /// Info
  if (change.before.get("info") < change.after.get("info")) {
    await backup("info", change);

    const info : any = {};
    const avisos = await db.collection('info').listDocuments();
    for (const avisoRef of avisos) {
      const aviso : any = (await avisoRef.get()).data();
      const date = aviso.date;
      aviso.date = undefined;
      if (aviso.icon == 58172 && aviso.icon_font == 'MaterialIcons') {
        aviso.icon = undefined;
        aviso.icon_font = undefined;
      }
      assert(info[date] === undefined, `aviso duplicado para fecha ${date}`);
      info[date] = aviso;
    }
    console.log(info);
    
    await save('info', info, change.after.get('info'));
  }

  /// Menu
  if (change.before.get("menu") < change.after.get("menu")) {
    await backup("menu", change);
    
    const doc = await db.doc('/menu/json').get();
    const menuJson : string = doc.get('rawData');
    console.log(menuJson);

    await save('menu', menuJson, change.after.get('menu'));
  }
});

