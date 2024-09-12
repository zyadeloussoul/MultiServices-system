import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

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
                'Demandez votre devis gratuit en ligne',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey[800],
                ),
              ),
              const SizedBox(height: 20),

              // Contact Form
              _buildTextField('Nom'),
              const SizedBox(height: 16),
              _buildTextField('Email'),
              const SizedBox(height: 16),
              _buildTextField('Téléphone'),
              const SizedBox(height: 16),
              _buildTextField('Sujet'),
              const SizedBox(height: 16),
              _buildMessageField(),
              const SizedBox(height: 20),

              // Send Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sending data to Spring Boot API
                  },
                  child: const Text('Envoyer', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Use backgroundColor instead of primary
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
  Widget _buildTextField(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  // Helper function to build message field
  Widget _buildMessageField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Message',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        maxLines: 5,
      ),
    );
  }
}
