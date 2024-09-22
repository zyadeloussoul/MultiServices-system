import 'package:flutter/material.dart';
import 'services.dart'; // Make sure this imports your ServiceEntity model
import 'services.dart'; // Import the ApiService

class AddServiceScreen extends StatelessWidget {
  final Category category;
  final ApiService apiService; // Add this

  AddServiceScreen({required this.category})
      : apiService = ApiService('http://localhost:8080/api/services'); // Update the base URL

  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Service'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: subtitleController,
              decoration: InputDecoration(labelText: 'Sous-titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Service newService = Service(
                  // Create a new ServiceEntity with the input data
                  name: nameController.text,
                  title: titleController.text,
                  subtitle: subtitleController.text,
                  description: descriptionController.text,
                  category: categoryController.text,
                  image: imageController.text,
                );

                Service? addedService = await apiService.addService(newService);
                if (addedService != null) {
                  // Show success message or navigate away
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Service ajouté avec succès!'),
                     
                  ));
                   await fetchServices();
                    await fetchCategories();
                    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CategoryScreen(categories: [category]),
    ),
  );
                  
                  // Optionally clear the text fields or navigate back
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Échec de l\'ajout du service.'),
                  ));
                }
              },
              child: Text('Ajouter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
