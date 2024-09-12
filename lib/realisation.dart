import 'package:flutter/material.dart';
import 'RealisationDetails.dart';

// Définition de la page des réalisations
class RealisationPage extends StatelessWidget {
  
  const RealisationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Adjust vertical padding as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nos Réalisations',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Use a ListView with a fixed height if it should fit within the screen's visible area
          SizedBox(
            height: 300,
            width: 400, 
            child: ListView(
              children: const [
                RealisationCard(
                  imagePath: 'images/telesc.jpeg',
                  title: 'Danialand Téléphérique Agadir',
                  description: 'Un projet emblématique dans la région d\'Agadir.',
                  category: 'Nettoyage',
                  title2: 'Nettoyage fin chantier du projet Danialand Téléphérique Agadir :',
                  description2: 'Nous sommes ravis d’avoir accompli avec succès le projet de nettoyage fin de chantier pour le projet Danialand Téléphérique Agadir. Notre équipe d’experts a travaillé en étroite collaboration avec les responsables du projet pour nettoyer et débarrasser efficacement les débris de construction, les résidus et les matériaux excédentaires afin de laisser le site propre et prêt pour une utilisation sûre et efficace. Nous avons utilisé des techniques de nettoyage de pointe et des équipements spécialisés pour garantir un nettoyage complet et exhaustif du site. Nous avons travaillé efficacement pour respecter les délais impartis et nous sommes fiers de notre service professionnel et de haute qualité..',
                ),
                RealisationCard(
                  imagePath: 'images/aero.jpeg',
                  title: 'L’aéroport Marrakech Menara',
                  description: 'Un des aéroports les plus importants au Maroc.',
                  category: 'Installation d’un câble fibre',
                  title2: 'Vente et Installation d’un câble fibre optique à l’aéroport Marrakech Menara :',
                  description2: 'Nous sommes fiers d’avoir été sélectionnés pour fournir et installer un câble à fibre optique de haute qualité à l’aéroport Marrakech Menara. Notre équipe d’experts a travaillé en étroite collaboration avec les représentants de l’aéroport pour comprendre leurs besoins de connectivité et fournir une solution personnalisée pour répondre à leurs exigences spécifiques. Nous avons fourni un câble à fibre optique de pointe et avons installé le système complet avec une grande attention aux détails pour garantir un fonctionnement optimal. Nous avons travaillé efficacement pour respecter les délais impartis et notre service après-vente fiable et réactif garantit que le système fonctionne sans problème pour fournir une connectivité rapide et fiable aux voyageurs et visiteurs de l’aéroport.',
                ),
                RealisationCard(
                  imagePath: 'images/hst.jpeg',
                  title: 'Établissements d\'enseignement traditionnels',
                  description: 'Un projet dans la région Marrakech Safi.',
                  category: 'Nettoyage',
                  title2: 'Vente de détergents et produits pour les établissements de l’enseignement traditionnels Marrakech Safi',
                  description2: 'Nous sommes ravis d’avoir été choisis pour fournir des détergents et des produits de qualité pour les établissements d’enseignement traditionnels à Marrakech Safi. Notre entreprise a fourni une large gamme de produits de nettoyage professionnels pour aider les établissements à maintenir des environnements de travail et d’étude propres et sains pour leurs élèves et leur personnel. Nous avons travaillé en étroite collaboration avec les responsables des établissements pour comprendre leurs besoins spécifiques et pour fournir des solutions personnalisées et efficaces pour répondre à leurs exigences. Nous avons travaillé avec diligence pour respecter les délais impartis et pour assurer une livraison en temps et en heure de nos produits de qualité supérieure.',
                ),
                RealisationCard(
                  imagePath: 'images/dmn.jpeg',
                  title: 'Domaines Agricoles Maroc',
                  description: 'Un vaste projet agricole au Maroc.',
                  category: 'Jardinage',
                  title2: 'Contrat de partenariat avec groupe domaines royales ( Domaines Agricole Maroc ) l’entretien et mise à jour des espaces verts .',
                  description2: 'Nous sommes fiers d’avoir collaboré avec le groupe Domaines Royales (Domaines Agricole Maroc) pour accomplir avec succès le projet d’entretien et de mise à jour de leurs espaces verts. Notre équipe d’experts a travaillé avec diligence et engagement pour fournir des solutions personnalisées pour l’entretien de la pelouse, la taille des arbres et des arbustes, ainsi que la gestion de l’irrigation. Nous avons travaillé efficacement pour respecter les délais impartis et nous sommes fiers de notre service professionnel et de haute qualité. Les espaces verts ont été transformés en une oasis paisible et accueillante, offrant un cadre agréable pour les visiteurs et les employés du groupe Domaines Royales.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Définition de la carte de réalisation
class RealisationCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String category;
  final String title2;  // Added second title
  final String description2;  // Added second description

  const RealisationCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.category,
    required this.title2,  // Added
    required this.description2,  // Added
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Catégorie: $category',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RealisationDetails(
                      imagePath: imagePath,
                      title: title,
                      description: description,
                      category: category,
                      title2: title2,  // Pass second title
                      description2: description2,  // Pass second description
                    ),
                  ),
                );
              },
              child: const Text('Découvrir'),
            ),
          ],
        ),
      ),
    );
  }
}
