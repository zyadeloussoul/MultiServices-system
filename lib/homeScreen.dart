import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'partenaire.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart'; // For client testimonials

class Service {
  final String? name;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? image;

  Service({this.name, this.title, this.subtitle, this.description, this.image});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['name'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      image: json['image'],
    );
  }
}

Future<String?> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

Future<List<Service>> fetchServices() async {
  try {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:8080/api/services'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Service.fromJson(json)).toList();
    } else {
      print('Failed with status code: ${response.statusCode}');
      throw Exception('Failed to load services');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load services');
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.center, // Pour aligner le contenu à gauche
    children: [
      // Section Titre
      Text(
        'Allo Zain Services',
        style: TextStyle(fontSize: 27),
      ),
      SizedBox(height: 5), // Espacement entre le titre et les informations
      // Heures d'ouverture et numéro de téléphone
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 16), // Icône des heures d'ouverture
              SizedBox(width: 4),
              Text(
                'Lun - Sam: 9h à 20h',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            children: [
              Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 16), // Icône WhatsApp
              SizedBox(width: 4),
              Text(
                '0661-885592',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  backgroundColor: Colors.blueAccent,
),

            drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.greenAccent,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: Text('Accueil'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen(), // Pass 'courses' if needed
                      ));
                    },
                  ),
                  ListTile(
                    title: Text('Cours'),
                    onTap: () { /*
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CoursePage(),
                      ));*/
                    },
                  ),
                  ListTile(
                    title: Text('À propos'),
                    onTap: () {/*
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => aapropos(),
                      ));*/
                    },
                  ),
                  ListTile(
                    title: Text('Newsletters'),
                    onTap: () {
                    /*  Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewLettres(),
                      ));*/
                    },
                  ),
                  ListTile(
                    title: Text('Se connecter'),
                    onTap: () {
                     /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );*/
                    },
                  ),
                  ListTile(
                    title: Text("S'inscrire"),
                    onTap: () {
                     /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()), 
                      );*/
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Company Introduction
            Stack(
              children: [
                // Background image with a parallax effect
                Container(
                  height: 450,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bc.jpg'), // Replace with a suitable image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
           Container(
  height: 300, // Augmenter la hauteur pour tenir compte de tous les éléments
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  alignment: Alignment.centerLeft,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, // Aligne tous les éléments à gauche
    mainAxisAlignment: MainAxisAlignment.start, 
    children: [
      // Premier texte (petit format)
      Text(
        'Allo Zain',
        style: TextStyle(
          fontSize: 18, // Petit format
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 8), // Espacement entre les textes

      // Texte principal 
      Text(
        'Multi-services Au maroc',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(blurRadius: 10, color: Colors.black)],
        ),
      ),
      SizedBox(height: 8), // Espacement entre les textes

      // Texte supplémentaire sous le texte principal
      Text(
        'Disponible à votre écoute! Nous répondons à toutes vos demandes',
        style: TextStyle(
          fontSize: 14, // Taille de texte légèrement plus petite
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),

      SizedBox(height: 20), // Espacement avant le bouton

      // Bouton en bas
      ElevatedButton(
        onPressed: () {
          // Action du bouton
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // Couleur du bouton
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Taille du bouton
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Bouton arrondi
          ),
        ),
        child: Text(
          'Obtenir un devis gratuit',
          style: TextStyle(
            fontSize: 18, // Taille du texte dans le bouton
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  ),
),
              ],
            ),


                        SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pourquoi Choisir Allo Zain ?',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Une relation de proximité\n'
                          '• Une expertise au prix le plus juste\n'
                          '• Un travail bien fait\n'
                          '• Du conseil et de l\'écoute',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.5, // Hauteur de ligne pour espacer les éléments
                          ),
                        ),
                   
                    
                        SizedBox(height: 20),
                               ElevatedButton(
        onPressed: () {
          // Action du bouton
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // Couleur du bouton
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Taille du bouton
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Bouton arrondi
          ),
        ),
        child: Text(
          'Obtenir un devis gratuit',
          style: TextStyle(
            fontSize: 18, // Taille du texte dans le bouton
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
         ],
                    ),
                       
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'images/w.jpeg', // Remplacez par le chemin de votre image
                        height: 350,
                        width: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
               PartnerSection(),
            // Featured Services
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Nos Services',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),

            // Fetch services from the API
            FutureBuilder<List<Service>>(
              future: fetchServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur lors du chargement des services'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun service disponible'));
                } else {
                  List<Service> services = snapshot.data!;
                  return AnimationLimiter(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 8,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Image.network(
                                          services[index].image ?? 'https://via.placeholder.com/150',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            services[index].name ?? 'Nom du Service',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            services[index].subtitle ?? 'Description courte',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16.0),
            
            // Testimonials Section (Carousel Slider)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ce que disent nos clients',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            CarouselSlider(
              items: [
                TestimonialCard(
                  clientName: "Yassin, Marrakech",
                  feedback: "Bonne entreprise de nettoyage à Marrakech, service bien réalisé, très compétent.",
                ),
                TestimonialCard(
                  clientName: "Karima A., Rabat",
                  feedback: "Très satisfait du déménagement de mon entreprise, soigneusement protégé.",
                ),
              ],
              options: CarouselOptions(
                height: 180.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
            ),

            SizedBox(height: 16.0),
            
            // Contact Us Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to contact us page
                },
                child: Text('Contactez Nous'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Use backgroundColor instead of primary
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'À Propos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Nos Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contactez Nous',
          ),
        ],
      ),
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final String clientName;
  final String feedback;

  TestimonialCard({required this.clientName, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              clientName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              feedback,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
