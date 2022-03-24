part of "package:baso/baso.dart";

// Backend service
class GenericBackendService {
  // Firestore
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // static Map<String, dynamic> _currentUser = {};
  // static final ValueNotifier<Map<String, dynamic>> userNotifier =
  //     ValueNotifier(currentUser);
  // static Map<String, dynamic> get currentUser => _currentUser;
  // static set currentUser(Map<String, dynamic> value) {
  //   _currentUser = value;
  //   userNotifier.value = value;
  // }

  // static late StreamSubscription<List<Map<String, dynamic>>?> userSubscription;

  // static void monitorUser() {
  //   userSubscription = GenericBackendService.readDocumentSnapshots(
  //     "users",
  //     GenericGlobalService.uid,
  //   ).listen((list) {
  //     if (list != null && list.isNotEmpty) {
  //       GenericGlobalService.uid = currentUser["id"];
  //       GenericGlobalService.phoneNumber = currentUser["phone"];
  //       GenericGlobalService.photoURL = currentUser["photo"];
  //       GenericGlobalService.displayName = currentUser["name"];

  //       currentUser = list.first;
  //     }
  //   });
  // }

  // Initial values
  static Function queries = (value) {
    return null;
  };

  static Map<String, List<String>> keys = {};

  static List<StreamSubscription> subscriptions = <StreamSubscription>[];

  // Usual
  static const int snapshotLength = 10;
  static Map<String?, dynamic> wrapper = Map<String?, dynamic>();

  static void deleteKey(String key) {
    getStreamSubscription(key).forEach((s) {
      try {
        s.cancel();
      } catch (e) {}
    });

    getStreamController(key).close();

    wrapper[key + "StreamController"] = null;
    wrapper[key + "AllResults"] = null;
    wrapper[key + "LastDocument"] = null;
    wrapper[key + "LoadingCompleted"] = null;
    wrapper[key + "Docs"] = null;
  }

  // Getters
  static getStreamSubscription(String key) {
    return wrapper[key + "StreamSubscription"] ?? [];
  }

  static StreamController<List<Map<String, dynamic>>?> getStreamController(
      String key) {
    if (wrapper[key + "StreamController"] == null) {
      wrapper[key + "StreamController"] =
          StreamController<List<Map<String, dynamic>>?>.broadcast();
    }

    return wrapper[key + "StreamController"];
  }

  static List<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllResults(
      String key) {
    if (wrapper[key + "AllResults"] == null) {
      wrapper[key + "AllResults"] =
          <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
    }

    return wrapper[key + "AllResults"];
  }

  static DocumentSnapshot? getLastDocument(String key) {
    return wrapper[key + "LastDocument"];
  }

  static bool getLoadingCompleted(String key) {
    if (wrapper[key + "LoadingCompleted"] == null) {
      wrapper[key + "LoadingCompleted"] = false;
    }

    return wrapper[key + "LoadingCompleted"];
  }

  static List<Map<String, dynamic>> getDocs(String key) {
    return wrapper[key + "Docs"] ?? <Map<String, dynamic>>[];
  }

  static bool getDocsExistence(String key) {
    return wrapper[key + "Docs"] != null;
  }

  // Setters
  static addStreamSubscription(String key, val) {
    getStreamSubscription(key).add(val);
  }

  static removeStreamSubscription(String key, val) {
    getStreamSubscription(key).remove(val);
  }

  static setStreamController(key, val) {
    wrapper[key + "StreamController"] = val;
  }

  static setAllResults(key, val) {
    wrapper[key + "AllResults"] = val;
  }

  static setLastDocument(key, val) {
    wrapper[key + "LastDocument"] = val;
  }

  static setLoadingCompleted(key, val) {
    wrapper[key + "LoadingCompleted"] = val;
  }

  static setDocs(String key, List<Map<String, dynamic>> val) {
    wrapper[key + "Docs"] = val;
  }

  // Generic
  static Future<DocumentReference<Map<String, dynamic>>> createDocument(
    String col,
    Map<String, dynamic> doc,
  ) {
    doc = copyDocument(col, doc);
    doc["created_at"] = FieldValue.serverTimestamp();
    doc["updated_at"] = FieldValue.serverTimestamp();
    return firestore.collection(col).add(doc);
  }

  static Future<void> insertDocument(
    String col,
    String id,
    Map<String, dynamic> doc,
  ) {
    doc = copyDocument(col, doc);
    doc["created_at"] = FieldValue.serverTimestamp();
    doc["updated_at"] = FieldValue.serverTimestamp();
    return firestore.collection(col).doc(id).set(doc, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>> readDocument(
    String col,
    String id,
  ) async {
    return simplifyDocument(await firestore.collection(col).doc(id).get());
  }

  static Future<void> updateDocument(
    String col,
    String id,
    Map<String, dynamic> doc,
  ) {
    doc = copyDocument(col, doc);
    doc["updated_at"] = FieldValue.serverTimestamp();
    return firestore.collection(col).doc(id).update(doc);
  }

  static Future<void> deleteDocument(
    String col,
    String id,
  ) {
    return firestore.collection(col).doc(id).delete();
  }

  static Future<List<Map<String, dynamic>>> readCollection(
    String col,
  ) async {
    return simplifyCollection((await firestore.collection(col).get()).docs);
  }

  // Users
  static Future<DocumentReference<Map<String, dynamic>>> createUser(doc) =>
      createDocument("users", doc);
  static Future<void> insertUser(id, doc) => insertDocument("users", id, doc);
  static Future<Map<String, dynamic>> readUser(id) => readDocument("users", id);
  static Future<void> updateUser(id, doc) => updateDocument("users", id, doc);
  static Future<void> deleteUser(id) => deleteDocument("users", id);
  static Future<List<Map<String, dynamic>>> readUsers() =>
      readCollection("users");

  // Collection snapshots management
  static Stream<List<Map<String, dynamic>>?> readCollectionSnapshots(
    String key, {
    Map<String, dynamic>? value,
    int limit = snapshotLength,
    bool realtime = true,
    bool cache = false,
    String suffix = "",
  }) {
    if (value == null) value = {};

    // DateTime today;
    // DateTime tomorrow;

    // if (key == "todayDeliveriesByDriver") {
    //   DateTime now = DateTime.now();

    //   // DateTime today = DateTime(now.year, now.hour, int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0);
    //   // DateTime today = DateTime(now.year, now.hour, int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0);
    //   // DateTime tomorrow = DateTime(2);

    //   today = DateTime(now.year, now.month, now.day);
    //   // final yesterday = DateTime(now.year, now.month, now.day - 1);
    //   tomorrow = DateTime(now.year, now.month, now.day + 1);
    // }

    Query<Map<String, dynamic>>? query = queries(value)[key];

    if (limit > 0) {
      query = query!.limit(limit);
    }

    key = key +
        (value.keys.isEmpty ? "" : value.toString()) +
        (realtime ? "Realtime" : "") +
        suffix;

    if (getLastDocument(key) != null) {
      query = query!.startAfterDocument(getLastDocument(key)!);
    }

    if (getLoadingCompleted(key)) {
      return getStreamController(key).stream;
    }

    var currentRequestIndex = getAllResults(key).length;

    final defaultStream =
        (realtime ? query!.snapshots() : Stream.fromFuture(query!.get()));
    late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> s;

    void processData(QuerySnapshot<Map<String, dynamic>> snapshot) {
      final data = snapshot.docs;
      final old = currentRequestIndex < getAllResults(key).length;

      if (old) {
        getAllResults(key)[currentRequestIndex] = data;
      } else {
        getAllResults(key).add(data);
      }

      List<Map<String, dynamic>> allDocs = <Map<String, dynamic>>[];

      getAllResults(key).forEach((list) {
        list.forEach((element) {
          allDocs.add(simplifyDocument(element));
        });
      });

      setDocs(key, allDocs);
      getStreamController(key).add(allDocs);

      if (currentRequestIndex == getAllResults(key).length - 1 &&
          data.isNotEmpty) {
        setLastDocument(key, data.last);
      }

      setLoadingCompleted(key, (limit == 0) || (data.length != limit));
    }

    if (cache) {
      s = Stream.fromFuture(query.get(GetOptions(source: Source.cache)))
          .listen((snapshot) {
        if (snapshot.size == 0) {
          s.cancel();
          removeStreamSubscription(key, s);
          s = defaultStream.listen(processData);
          subscriptions.add(s);
          addStreamSubscription(key, s);
        } else {
          processData(snapshot);
        }
      });
    } else {
      s = defaultStream.listen(processData);
    }

    subscriptions.add(s);
    addStreamSubscription(key, s);

    return getStreamController(key).stream;
  }

  static Stream<List<Map<String, dynamic>>?> readDocumentSnapshots(
    String col,
    String id, [
    bool realtime = true,
    bool cache = false,
    String suffix = "",
  ]) {
    final key = col + id + (realtime ? "Realtime" : "") + suffix;

    late StreamSubscription<DocumentSnapshot> s;

    final ref = firestore.collection(col).doc(id);
    final defaultStream =
        (realtime ? ref.snapshots() : Stream.fromFuture(ref.get()));

    void processData(snapshot) {
      if (snapshot.exists) {
        final tmp = [simplifyDocument(snapshot)];

        setDocs(key, tmp);
        getStreamController(key).add(tmp);
      } else {
        setDocs(key, <Map<String, dynamic>>[]);
        getStreamController(key).add(<Map<String, dynamic>>[]);
      }
    }

    if (cache) {
      s = Stream.fromFuture(ref.get(GetOptions(source: Source.cache)))
          .listen((snapshot) {
        if (snapshot.exists) {
          processData(snapshot);
        } else {
          s.cancel();
          removeStreamSubscription(key, s);
          s = defaultStream.listen(processData);
          subscriptions.add(s);
          addStreamSubscription(key, s);
        }
      });
    } else {
      s = defaultStream.listen(processData);
    }

    subscriptions.add(s);
    addStreamSubscription(key, s);

    return getStreamController(key).stream;
  }

  static formatDuration(Duration duration) {
    if (duration.inHours == 0) {
      return duration.toString().split('.').first.padLeft(8, "0").substring(3);
    }

    return duration.toString().split('.').first.padLeft(8, "0");
  }

  static String formatDate(DateTime date) {
    String part1 = (date.day < 10 ? '0' : '') + date.day.toString();
    String part2 = (date.month < 10 ? '0' : '') + date.month.toString();
    String part3 = date.year.toString();

    return part3 + '/' + part2 + '/' + part1;
  }

  static convertDate(DateTime currentDate) {
    currentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dayBeforeYestearday = DateTime(now.year, now.month, now.day - 2);

    if (currentDate == today) return "Aujourd'hui";
    if (currentDate == yesterday) return "Hier";
    if (currentDate == dayBeforeYestearday) return "Avant-hier";

    for (int i = 3; i < 7; i++) {
      DateTime tmp = DateTime(now.year, now.month, now.day - i);

      if (currentDate == tmp) {
        return [
          "Lundi",
          "Mardi",
          "Mercredi",
          "Jeudi",
          "Vendredi",
          "Samedi",
          "Dimanche"
        ][currentDate.weekday - 1];
      }
    }

    return invertDateString(formatDate(currentDate));
  }

  static String formatTime(DateTime date) {
    String part1 = (date.hour < 10 ? '0' : '') + date.hour.toString();
    String part2 = (date.minute < 10 ? '0' : '') + date.minute.toString();

    return part1 + ":" + part2;
  }

  static String getToday() {
    return formatDate(DateTime.now());
  }

  static String invertDateString(String date) {
    var parts = date.split("/");
    return parts[2] + '/' + parts[1] + '/' + parts[0];
  }

  static Map<String, dynamic> simplifyDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> newDocument = doc.data() as Map<String, dynamic>;

    newDocument["id"] = doc.id;

    if (newDocument["created_at"] != null) {
      try {
        newDocument["date"] = convertDate(newDocument["created_at"].toDate());
        newDocument["time"] = formatTime(newDocument["created_at"].toDate());
      } catch (e) {
        final d = DateTime.now();

        newDocument["date"] = convertDate(d);
        newDocument["time"] = formatTime(d);
      }
    }

    return newDocument;
  }

  static List<Map<String, dynamic>> simplifyCollection(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> col) {
    List<Map<String, dynamic>> newCollection = [];

    col.forEach((doc) {
      newCollection.add(simplifyDocument(doc));
    });

    return newCollection;
  }

  static void monitorAuthenticationState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      refreshUser();
    });

    FirebaseAuth.instance.userChanges().listen((User? user) {
      refreshUser();
    });

    // monitorUser();
  }

  static void refreshUser() {
    var user = auth.currentUser;

    if (user != null) {
      GenericGlobalService.uid = user.uid;
      GenericGlobalService.phoneNumber = user.phoneNumber ?? "";
      GenericGlobalService.photoURL = user.photoURL ?? "";
      GenericGlobalService.displayName = user.displayName ?? "";
    } else {
      GenericGlobalService.uid = "";
      GenericGlobalService.phoneNumber = "";
      GenericGlobalService.photoURL = "";
      GenericGlobalService.displayName = "";
    }

    // currentUser = {
    //   "id": GenericGlobalService.uid,
    //   "phone": GenericGlobalService.phoneNumber,
    //   "photo": GenericGlobalService.photoURL,
    //   "name": GenericGlobalService.displayName,
    // };
  }

  static Map<String, dynamic> copyDocument(col, Map<String, dynamic> doc) {
    Map<String, dynamic> newDocument = Map<String, dynamic>();

    doc.forEach((key, value) {
      if (keys[col]!.indexOf(key) >= 0 || key.contains(".")) {
        newDocument[key] = value;
      }
    });

    return newDocument;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    refreshUser();

    GenericGlobalService.authenticated = false;
    GenericGlobalService.blocked = false;
  }

  static void reset() {
    subscriptions.forEach((subscription) {
      try {
        subscription.cancel();
      } catch (e) {}
    });

    // try {
    //   userSubscription.cancel();
    //   currentUser = {};
    // } catch (e) {}

    subscriptions.clear();
  }
}
