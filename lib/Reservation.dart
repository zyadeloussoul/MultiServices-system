import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeCategoryFields();
  }

  void _initializeCategoryFields() {
    if (widget.category == 'Nettoyage') {
      categoryFields = [
        ReservationField(label: 'Prénom', controller: TextEditingController()),
        ReservationField(label: 'Adresse', controller: TextEditingController()),
        ReservationField(label: 'Métrage (m²)', controller: TextEditingController(), inputType: TextInputType.number),
      ];
    } else if (widget.category == 'Demenagement') {
      categoryFields = [
        ReservationField(label: 'Prénom', controller: TextEditingController()),
        ReservationField(label: 'Type de déménagement (in city/out city)', controller: TextEditingController()),
        ReservationField(label: 'Adresse de départ', controller: TextEditingController()),
        ReservationField(label: 'Adresse d’arrivée', controller: TextEditingController()),
        ReservationField(label: 'Montage (true/false)', controller: TextEditingController()),
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

 void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // Handle form submission logic
    // For example, print values to console or send to backend API
    print('Nom: ${nameController.text}');
    print('Email: ${emailController.text}');
    print('Ville: ${cityController.text}');
    print('Date: ${dateController.text}');
    
    for (var field in categoryFields) {
      print('${field.label}: ${field.controller.text}');
    }

    // Implement the reservation logic here (API call, etc.)

    // Clear all text fields
    nameController.clear();
    emailController.clear();
    cityController.clear();
    dateController.clear();
    
    for (var field in categoryFields) {
      field.controller.clear();
    }
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
                child: Text(
                  'Réserver maintenant',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
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
