import 'package:flutter/material.dart';

class PartnerSection extends StatefulWidget {
  @override
  _PartnerSectionState createState() => _PartnerSectionState();
}

class _PartnerSectionState extends State<PartnerSection> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Liste des chemins des images
  final List<String> partnerImages = [
    'images/axa.png',
    'images/Dipndip_logo.png',
    'images/dom.jpeg',
    'images/wiz.jpeg',
    'images/so.jpeg',
    'images/axa.png',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Text(
            'Nos partenaires',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
        SizedBox(height: 16.0),

        // Utilisation du Builder ici pour créer dynamiquement le GridView
        Builder(
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Empêche le défilement interne de la grille
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Nombre de colonnes
                  crossAxisSpacing: 16.0, // Espacement entre les colonnes
                  mainAxisSpacing: 16.0, // Espacement entre les lignes
                  childAspectRatio: 1.0, // Ratio hauteur/largeur des images
                ),
                itemCount: partnerImages.length, // Nombre d'images dans la liste
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 800 + index * 200), // Délai d'apparition
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        partnerImages[index], // Utilise l'image de la liste correspondante
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
