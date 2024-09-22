import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'login.dart'; // Importez votre écran de connexion

class ReservationService {
  final String baseUrl = 'http://localhost:8080/api/reservations';

  Future<List<Reservation>> getAllReservations(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((reservation) => Reservation.fromJson(reservation)).toList();
    } else {
      throw Exception('Failed to load reservations');
    }
  }
}

class Reservation {
  final String name;
  final String email;
  final String city;
  final String date;
  final String category;

  // Category-specific fields
  final String? address;
  final String? area;
  final String? packagingUnpacking;
  final String? loadingUnloading;
  final String? setup;
  final String? departureAddress;
  final String? arrivalAddress;

  Reservation({
 
    required this.name,
    required this.email,
    required this.city,
    required this.date,
    required this.category,
    this.address,
    this.area,
    this.packagingUnpacking,
    this.loadingUnloading,
    this.setup,
    this.departureAddress,
    this.arrivalAddress,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
 
      name: json['name'],
      email: json['email'],
      city: json['city'],
      date: json['date'],
      category: json['category'],
      address: json['address'],
      area: json['area'],
      packagingUnpacking: json['packagingUnpacking'],
      loadingUnloading: json['loadingUnloading'],
      setup: json['setup'],
      departureAddress: json['departureAddress'],
      arrivalAddress: json['arrivalAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'name': name,
      'email': email,
      'city': city,
      'date': date,
      'category': category,
      'address': address,
      'area': area,
      'packagingUnpacking': packagingUnpacking,
      'loadingUnloading': loadingUnloading,
      'setup': setup,
      'departureAddress': departureAddress,
      'arrivalAddress': arrivalAddress,
    };
  }
}

class ReservationsScreen extends StatefulWidget {
  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  late Future<List<Reservation>> futureReservations;
  final ReservationService reservationService = ReservationService();
  String? token;
  List<Reservation> previousReservations = []; // Pour garder une trace des réservations précédentes
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken'); 
    if (token != null) {
      futureReservations = reservationService.getAllReservations(token!);
      futureReservations.then((reservations) {
        previousReservations = reservations; // Stockez les réservations initiales
        _checkForNewReservations(); // Vérifiez les nouvelles réservations
      });
      setState(() {}); 
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  Future<void> _checkForNewReservations() async {
    // Appeler l'API pour récupérer les réservations actuelles
    List<Reservation> currentReservations = await reservationService.getAllReservations(token!);
    
    // Comparer avec les réservations précédentes
    for (var reservation in currentReservations) {
      if (!previousReservations.any((prev) => prev.name == reservation.name && prev.date == reservation.date)) {
        // Si une nouvelle réservation est trouvée, afficher la notification
        showNotification('Nouvelle Réservation', 'Une nouvelle réservation a été faite par ${reservation.name} pour le ${reservation.date}.');
      }
    }

    // Mettre à jour les réservations précédentes
    previousReservations = currentReservations;
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'reservation_channel', // ID du canal
      'Réservations', // Nom du canal
      channelDescription: 'Notifications de nouvelles réservations',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  
    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x', // Payload si nécessaire
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservations'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Reservation>>(
          future: futureReservations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              final reservations = snapshot.data!;
              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(reservation.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("Reservation"),
                          Text('Date: ${reservation.date}'),
                          Text('Name: ${reservation.name}'),
                          Text('Email: ${reservation.email}'),
                          Text('Ville: ${reservation.city}'),
                          Text('Category: ${reservation.category}'),
                          if (reservation.address != null) Text('Address: ${reservation.address}'),
                          if (reservation.area != null) Text('Area: ${reservation.area}'),
                          if (reservation.packagingUnpacking != null) Text('Packaging/Unpacking: ${reservation.packagingUnpacking}'),
                          if (reservation.loadingUnloading != null) Text('Loading/Unloading: ${reservation.loadingUnloading}'),
                          if (reservation.setup != null) Text('Setup: ${reservation.setup}'),
                          if (reservation.departureAddress != null) Text('Departure Address: ${reservation.departureAddress}'),
                          if (reservation.arrivalAddress != null) Text('Arrival Address: ${reservation.arrivalAddress}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
