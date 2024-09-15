import 'package:flutter/material.dart';

class Partner2 extends StatelessWidget {
  // Liste des chemins des images
  final List<String> partnerImages = [
    'images/axa.png',
    'images/dipndip.jpg',
    'images/dom.jpeg',
    'images/wiz.jpeg',
    'images/so.jpeg',
    'images/axa.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nos Partenaires'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Nombre de colonnes
                  crossAxisSpacing: 20.0, // Espacement entre les colonnes
                  mainAxisSpacing: 100.0, // Espacement entre les lignes
                  childAspectRatio: 1.2, // Ratio hauteur/largeur des images
                ),
                itemCount: partnerImages.length, // Nombre d'images dans la liste
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 800 + index * 200), // Délai d'apparition
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 3), // Change the position of shadow
                            ),
                          ],
                        ),
                        child: Image.asset(
                          partnerImages[index], // Utilise l'image de la liste correspondante
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
