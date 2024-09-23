import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendContactData() async {
    // Check if any field is empty
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _messageController.text.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final url = 'http://localhost:8080/api/contactes'; // Replace with your Spring Boot API URL

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nom': _nameController.text,
        'email': _emailController.text,
        'telephone': _phoneController.text,
        'sujet': _subjectController.text,
        'message': _messageController.text,
      }),
    );

    if (response.statusCode == 201) {
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message envoyé avec succès')),
      );
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _subjectController.clear();
      _messageController.clear();
    } else {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'envoi du message')),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Contactez Nous'),
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      centerTitle: true,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Text(
              'Demandez votre devis gratuit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 20),

            // Contact Form
            _buildTextField('Nom', _nameController),
            const SizedBox(height: 16),
            _buildTextField('Email', _emailController),
            const SizedBox(height: 16),
            _buildTextField('Téléphone', _phoneController),
            const SizedBox(height: 16),
            _buildTextField('Sujet', _subjectController),
            const SizedBox(height: 16),
            _buildMessageField(),
            const SizedBox(height: 20),

            // Send Button
            Center(
              child: ElevatedButton(
                onPressed: _sendContactData,
                child: const Text('Envoyer', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Helper function to build text fields
Widget _buildTextField(String label, TextEditingController controller) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    ),
  );
}

// Helper function to build message field
Widget _buildMessageField() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: _messageController,
      decoration: InputDecoration(
        labelText: 'Message',
        labelStyle: TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      maxLines: 5,
    ),
  );
}
}