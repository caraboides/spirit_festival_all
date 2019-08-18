import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app_storage.dart' as appStorage;
import 'config.dart';
import 'festival_config.dart';

Future<Firestore> initFirestore() async {
  final app = await FirebaseApp.configure(
    name: 'init',
    options: firebaseOptions,
  );
  final firestore = Firestore(app: app);
  await firestore.settings(
    timestampsInSnapshotsEnabled: true,
    sslEnabled: true,
  );
  return firestore;
}

class FirebaseData {
  const FirebaseData({
    this.collection = const <DocumentSnapshot>[],
    this.updates = const <DocumentSnapshot>[],
  });

  final List<DocumentSnapshot> collection;
  final List<DocumentSnapshot> updates;
}

Future<FirebaseData> loadData(
  Firestore firestore,
  String collectionName,
) async {
  final reference = firestore
      .collection('festivals')
      .document(festivalFirestoreKey)
      .collection(collectionName);
  final appStorageKey = '$collectionName-lastUpdated';
  final int lastUpdated =
      (await appStorage.loadJson(appStorageKey)).orElse(null);
  final source = lastUpdated == null ? Source.server : Source.cache;
  final now = DateTime.now();
  // Load collection
  final collection = await _loadCollection(reference, source);
  final updates = lastUpdated == null
      ? <DocumentSnapshot>[]
      : await _loadUpdates(
          reference,
          DateTime.fromMillisecondsSinceEpoch(lastUpdated),
        );
  if (collection.isNotEmpty && (lastUpdated == null || updates.isNotEmpty)) {
    // Update lastUpdated timestamp in app storage
    appStorage.storeJson(
      appStorageKey,
      now.millisecondsSinceEpoch,
    );
  }
  return FirebaseData(
    collection: collection,
    updates: updates,
  );
}

Future<List<DocumentSnapshot>> _loadCollection(
  CollectionReference reference,
  Source source,
) =>
    reference
        .getDocuments(source: source)
        .then<List<DocumentSnapshot>>((snapshot) => snapshot.documents)
        .catchError((error) {
      print(error);
      return <DocumentSnapshot>[];
    });

Future<List<DocumentSnapshot>> _loadUpdates(
  CollectionReference reference,
  DateTime lastUpdated,
) =>
    reference
        .where('updated',
            isGreaterThanOrEqualTo: Timestamp.fromDate(lastUpdated))
        .getDocuments(source: Source.server)
        .then<List<DocumentSnapshot>>((snapshot) => snapshot.documents)
        .catchError((error) {
      print(error);
      return <DocumentSnapshot>[];
    });

// Future<void> runInitFirebaseApp() async {
//   final Firestore firestore = await initFirestore();

//   runApp(
//     MaterialApp(
//       title: 'Firestore Example',
//       home: InitFirebasePage(
//         firestore: firestore,
//       ),
//     ),
//   );
// }

// class InitFirebasePage extends StatelessWidget {
//   InitFirebasePage({this.firestore});

//   final Firestore firestore;

//   Future<void> _initSchedule(BuildContext context) async {
//     final List<dynamic> schedule = await DefaultAssetBundle.of(context)
//         .loadString("assets/initial_schedule.json")
//         .then((v) => Future.value(jsonDecode(v)));
//     final scheduleRef = firestore
//         .collection('festivals')
//         .document('spirit_2019')
//         .collection('schedule');
//     final existingSchedule = await scheduleRef.getDocuments();
//     existingSchedule.documents.forEach((documentSnapshot) async {
//       await documentSnapshot.reference.delete();
//       print('Deleted event ${documentSnapshot.documentID}');
//     });
//     var counter = 0;
//     print('0/${schedule.length}');
//     schedule.forEach((event) async {
//       event['start'] = Timestamp.fromDate(DateTime.parse(event['start']));
//       event['end'] = Timestamp.fromDate(DateTime.parse(event['end']));
//       final docRef = await scheduleRef.add(event);
//       print('Wrote event ${docRef.documentID}');
//       print('${++counter}/${schedule.length}');
//     });
//   }

//   Future<void> _initBands(BuildContext context) async {
//     final Map<String, dynamic> bands = await DefaultAssetBundle.of(context)
//         .loadString("assets/bands.json")
//         .then((v) => Future.value(jsonDecode(v)));
//     final bandRef = firestore
//         .collection('festivals')
//         .document('spirit_2019')
//         .collection('bands');
//     var counter = 0;
//     print('0/${bands.length}');
//     bands.forEach((bandName, data) async {
//       await bandRef.document(bandName).setData(data);
//       print('Wrote band $bandName');
//       print('${++counter}/${bands.length}');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: RaisedButton(
//         child: Text('Init data'),
//         onPressed: () => _initBands(context),
//       ),
//     );
//   }
// }
