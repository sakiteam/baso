part of "package:baso/baso.dart";

class GenericMessagingService {
  static String serverKey = "";

  static void requestMessagingPermission() {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      provisional: false,
      announcement: false,
      criticalAlert: false,
    );
  }

  static Future<void> saveToken() async {
    if (GenericGlobalService.authenticated) {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) await updateUser(token);

      FirebaseMessaging.instance.onTokenRefresh.listen(updateUser);
    }
  }

  static Future<void> updateUser(String token) async {
    String userId = GenericGlobalService.uid;

    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      "token": token,
    });

    GenericGlobalService.token = token;
  }

  static sendNotification(
    String token,
    String title,
    String body,
    Map<String, dynamic>? payload,
  ) async {
    await HTTP.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': payload ?? <String, dynamic>{},
          'to': token
        },
      ),
    );
  }

  static sendUserNotification(
    String id,
    String title,
    String body,
    Map<String, dynamic>? payload,
  ) async {
    final user = await GenericBackendService.readDocument("users", id);
    await sendNotification(user["token"], title, body, payload);
  }

  static sendPayLoad(String token, {Map<String, dynamic>? data}) async {
    await HTTP.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{'priority': 'high', 'data': data, 'to': token},
      ),
    );
  }
}
