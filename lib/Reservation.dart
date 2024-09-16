import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homeScreen.dart';
class ReservationField {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;

  ReservationField({
    required this.label,
    required this.controller,
    this.inputType = TextInputType.text,
  });
}

class Reservation extends StatefulWidget {
  final String category;

  Reservation({required this.category});

  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  final _formKey = GlobalKey<FormState>();

  // Fixed fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // Category-specific fields
  List<ReservationField> categoryFields = [];

  bool _isSubmitting = false; // To track submission status
  bool _isSuccess = false; // To track success or failure

  @override
  void initState() {
    super.initState();
    _initializeCategoryFields();
  }

  void _initializeCategoryFields() {
    if (widget.category == 'Nettoyage') {
      categoryFields = [
        ReservationField(label: 'Adresse', controller: TextEditingController()),
        ReservationField(label: 'Métrage (m²)', controller: TextEditingController(), inputType: TextInputType.number),
      ];
    } else if (widget.category == 'Demenagement') {
      categoryFields = [
        ReservationField(label: 'Emballage Deballage', controller: TextEditingController()),
        ReservationField(label: 'Chargement Dechargement', controller: TextEditingController()),
        ReservationField(label: 'Emballage Deballage', controller: TextEditingController()),
        ReservationField(label: 'Mise en place', controller: TextEditingController()),
        ReservationField(label: 'Adresse de départ', controller: TextEditingController()),
        ReservationField(label: 'Adresse d’arrivée', controller: TextEditingController()),
      ];
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    dateController.dispose();
    categoryFields.forEach((field) => field.controller.dispose());
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _isSuccess = false;
      });

      // Prepare the data to send
      final reservationData = {
        'name': nameController.text,
        'email': emailController.text,
        'city': cityController.text,
        'date': dateController.text,
        'category': widget.category,
        // Include category-specific fields
        if (widget.category == 'Nettoyage') ...{
          'address': categoryFields[0].controller.text,
          'area': categoryFields[1].controller.text,
        } else if (widget.category == 'Demenagement') ...{
          'packagingUnpacking': categoryFields[0].controller.text,
          'loadingUnloading': categoryFields[1].controller.text,
          'setup': categoryFields[2].controller.text,
          'departureAddress': categoryFields[3].controller.text,
          'arrivalAddress': categoryFields[4].controller.text,
        },
      };

      // Convert the data to JSON
      final jsonReservationData = json.encode(reservationData);

      // Send the data to your backend API
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/reservations'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonReservationData,
      );

      setState(() {
        _isSubmitting = false;
        if (response.statusCode == 200) {
          _isSuccess = true;
          // Clear all text fields
          nameController.clear();
          emailController.clear();
          cityController.clear();
          dateController.clear();
          categoryFields.forEach((field) => field.controller.clear());

          // Navigate to confirmation screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmationScreen(reservationData: reservationData),
            ),
          );
        } else {
          _isSuccess = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservation - ${widget.category}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Fixed fields
              _buildTextField('Nom', nameController),
              _buildTextField('Email', emailController, inputType: TextInputType.emailAddress),
              _buildTextField('Ville', cityController),
              _buildTextField('Date', dateController, inputType: TextInputType.datetime),

              // Category-specific fields
              ...categoryFields.map((field) {
                return _buildTextField(field.label, field.controller, inputType: field.inputType);
              }).toList(),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Réserver maintenant',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              if (_isSuccess)
                Icon(Icons.check_circle, color: Colors.green, size: 30),
              if (!_isSuccess && !_isSubmitting && _formKey.currentState?.validate() == true)
                Icon(Icons.cancel, color: Colors.red, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez saisir $label';
          }
          return null;
        },
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> reservationData;

  ConfirmationScreen({required this.reservationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation de Réservation'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.home), // Change the icon if you want
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              ModalRoute.withName('/'), // This ensures that the home screen is set as the root
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Votre Réservation!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Cher(e) ${reservationData['name']},',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Nous avons bien reçu votre demande de réservation. Voici les détails de votre réservation :',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '• Nom: ${reservationData['name']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '• Email: ${reservationData['email']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '• Ville: ${reservationData['city']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '• Date: ${reservationData['date']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '• Catégorie : ${reservationData['category']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (reservationData['category'] == 'Nettoyage') ...[
              Text(
                'Pour les services de nettoyage :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '  • Adresse : ${reservationData['address']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '  • Métrage :  ${reservationData['area']} m²',
                style: TextStyle(fontSize: 18),
              ),
            ] else if (reservationData['category'] == 'Demenagement') ...[
              Text(
                'Pour les services de déménagement :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '   • Emballage/Déballage: ${reservationData['packagingUnpacking']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '  • Chargement/Déchargement: ${reservationData['loadingUnloading']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '  • Mise en Place:  ${reservationData['setup']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '   • Adresse de Départ: ${reservationData['departureAddress']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '   • Adresse d’Arrivée: ${reservationData['arrivalAddress']}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            SizedBox(height: 20),
            Text(
              'Nous vous remercions de votre confiance. Nous nous réjouissons de pouvoir vous servir et vous souhaitons une excellente expérience.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Avec nos salutations distinguées,',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'L’équipe de Prestige',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}