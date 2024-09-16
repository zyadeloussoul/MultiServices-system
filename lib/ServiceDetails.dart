// service_details.dart

import 'package:flutter/material.dart';
import 'homeScreen.dart'; // Import the file where the Service class is defined

class ServiceDetails extends StatelessWidget {
  final Service service;

  ServiceDetails({required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.name ?? 'Détails du Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the service image
            Image.asset(
              service.image ?? 'images/daata.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            SizedBox(height: 16),
            // Display the service name
            Text(
              service.name ?? 'Nom du Service',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Display the service subtitle
            Text(
              service.subtitle ?? 'Sous-titre du Service',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            // Display the service description
            Text(
              service.description ?? 'Description du Service',
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
