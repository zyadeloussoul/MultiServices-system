import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'login.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();

const InitializationSettings initializationSettings = InitializationSettings(
  android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  iOS: initializationSettingsIOS,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiservice App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'reservations_channel', // ID du canal
    'Réservations', // Nom du canal
    channelDescription: 'Notifications pour les nouvelles réservations',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // ID de la notification
    title,
    body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}
