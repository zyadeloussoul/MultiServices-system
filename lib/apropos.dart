import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Corrected FontAwesome import

class Apropos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À propos'),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Qui sommes-nous ?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'À propos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.blueAccent,
      width: 1.0, // Réduit l'épaisseur de la bordure
    ),
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: Row(
    children: <Widget>[
      Expanded(
        child: Image.asset(
          'images/apropos.jpeg', // Update with your image path
          width: 150, // Réduit la largeur de l'image
          height: 650, // Réduit la hauteur de l'image
          fit: BoxFit.cover,
        ),
      ),
      SizedBox(width: 8.0), // Réduit l'espace entre l'image et le texte
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Réduit le padding autour du texte
          child: Text(
            '• Allo Zain une entreprise au service de ses clients !\n'
            '• Une relation de proximité\n'
            '• Une expertise au prix le plus juste\n'
            '• Un travail bien fait\n'
            '• Du conseil et de l\'écoute\n\n'
            '• OBTENIR UN DEVIS GRATUIT\n\n'
            '• Notre mission\n\n'
            '• Allo Zain\n'
            '• Bienvenue chez notre entreprise de multi-services à Marrakech, où nous sommes dédiés à fournir une solution complète à tous vos besoins de maintenance et d\'amélioration de votre maison ou de votre entreprise. Que vous ayez besoin de réparations mineures, d\'entretien régulier ou de projets de rénovation majeurs, nous avons une équipe de professionnels qualifiés pour répondre à tous vos besoins.',
            style: TextStyle(fontSize: 14), // Réduit la taille de la police
          ),
        ),
      ),
    ],
  ),
),

            SizedBox(height: 20),
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
            SizedBox(height: 10),
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
            SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.yellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.smileBeam,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '99%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Clients satisfaits',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.projectDiagram,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '346',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Projets achevés',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.calendarAlt,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '5',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'ans d\'expérience',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              clientName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              feedback,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
