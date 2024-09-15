import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// Stocker le token
void storeToken(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  await prefs.setString('refreshToken', refreshToken);
  print('Access Token stocké: $accessToken');
  print('Refresh Token stocké: $refreshToken');
}


// Récupérer le token
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken'); // Ensure you use the correct key
  print('Token récupéré de SharedPreferences: $token');
  return token;
}


// Fonction pour récupérer les données utilisateur depuis l'API
Future<User> fetchUser() async {
  final accessToken = await getToken();

  if (accessToken == null) {
    throw Exception('Token non trouvé');
  }

  final response = await http.get(
    Uri.parse('http://localhost:8080/user/me'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      "Content-Type": "application/json",
    },
  );


  if (response.statusCode == 200) {
    if (response.body.isEmpty) {
      throw Exception('Réponse vide du serveur');
    }
    return User.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    throw Exception('Utilisateur non trouvé');
  } else {
    throw Exception('Échec lors du chargement de l\'utilisateur: ${response.statusCode}, Body: ${response.body}');
  }
}




// Exemple de classe User (à adapter selon votre modèle de données)
class User {
  final String id;
  final String username;
  final String email;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}

// Interface de la page du profil utilisateur
class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<User> userFuture;

  @override
void initState() {
  super.initState();
  userFuture = fetchUser();
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profil Utilisateur'),
    ),
    body: FutureBuilder<User>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Affichage du chargement
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}')); // Affichage de l'erreur
        } else if (snapshot.hasData) {
          User user = snapshot.data!;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Text(
                      user.username.isNotEmpty ? user.username[0] : '?', // Utilisation des initiales
                      style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                    ),
                    radius: 70.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    user.username,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Email: ${user.email}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Role: ${user.role}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('Aucun utilisateur trouvé'));
        }
      },
    ),
  );
}
}