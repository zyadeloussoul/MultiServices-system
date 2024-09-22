import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'crudService.dart';

// Model for Category
class Category {
  final String name;

  Category({required this.name});

  // Modify the fromJson method to work with plain strings
  factory Category.fromJson(String json) {
    return Category(name: json);
  }
}

class Service {

  final String? name;
  final String? title;
  final String? subtitle;
  final String? category;
  final String? description;
  final String? image;

  Service({

    this.name,
    this.title,
    this.subtitle,
    this.category,
    this.description,
    this.image,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(

      name: json['name'],
      title: json['title'],
      subtitle: json['subtitle'],
      category: json['category'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
 
      'name': name,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'description': description,
      'image': image,
    };
  }
}




// Method to get access token from SharedPreferences
Future<String?> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

// Fetch categories from API
Future<List<Category>> fetchCategories() async {
  try {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:8080/api/services/categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('Request URL: ${response.request?.url}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((category) => Category.fromJson(category)).toList();
    } else {
      print('Failed with status code: ${response.statusCode}');
      print('Failed response body: ${response.body}');
      throw Exception('Failed to load categories');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load categories');
  }
}

// Fetch all services from API
Future<List<Service>> fetchServices() async {
  try {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:8080/api/services'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Service.fromJson(json)).toList();
    } else {
      print('Failed with status code: ${response.statusCode}');
      throw Exception('Failed to load services');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load services');
  }
}

// Fetch services by category from API
Future<List<Service>> fetchServicesByCategory(String categoryName) async {
  try {
    String? accessToken = await getAccessToken();
    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:8080/api/services/category/$categoryName'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Service.fromJson(json)).toList();
    } else {
      print('Failed with status code: ${response.statusCode}');
      throw Exception('Failed to load services');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load services');
  }
}
class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Service?> addService(Service service) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {
        'Content-Type': 'application/json',
        // Add any authorization headers if needed
      },
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      // Handle errors here
      print('Failed to add service: ${response.statusCode}');
      return null; // Return null on error
    }
  }
 Future<bool> deleteServiceByName(String name) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$name'), // Use the name in the URL
    );

    if (response.statusCode == 204) {
      return true; // Success
    } else {
     
      return false; // Failure
    }
  }

    Future<bool> updateServiceByName(String name, Service service) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$name'), // Use the name in the URL
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(service.toJson()),
    );

    return response.statusCode == 200; // Return true if the update is successful
  }
}

  
class CategoryScreen extends StatelessWidget {
  final List<Category> categories;

  CategoryScreen({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceScreen(category: category),
                  ),
                );
              },
              child: Hero(
                tag: category.name,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(height: 10),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.deepPurple[50],
    );
  }
}


class ServiceScreen extends StatelessWidget {
  final Category category;
 final ApiService apiservice;
  ServiceScreen({required this.category}):apiservice = ApiService('http://localhost:8080/api/services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Services'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Service>>(
        future: fetchServicesByCategory(category.name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No services available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final service = snapshot.data![index];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8,
                      child: Column(
                        children: [
                          // Image Section
                       ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.asset(
                            service.image ?? 'images/telesc.jpeg', // Assuming default image in case of null
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 180,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Icon(Icons.broken_image, size: 50),
                              );
                            },
                          ),
                        ),


                          // Service Information Section
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.title ?? '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  service.subtitle ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Category: ${service.category ?? ''}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 8),
                                

                                // Buttons Section
                                Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(
              service: service,
            ),
          ),
        );
      },
      icon: Icon(Icons.info_outline),
      label: Text('Details'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    ElevatedButton.icon(
        onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateServiceScreen(
          apiService: apiservice, // Pass the ApiService instance
          service: service,
        ),
      ),
    );
  },
      icon: Icon(Icons.edit),
      label: Text('Modif'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    ElevatedButton.icon(
  onPressed: () async {
    // Debug: print the service details before deletion
    print('Service details: ${service.toJson()}'); // Ensure this prints an object with a valid name

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce service?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    // Proceed with deletion if confirmed
    if (confirmed == true) {
      if (service.name != null && service.name!.isNotEmpty) {
        // Call the delete method from ApiService using the service name
        final success = await apiservice.deleteServiceByName(service.name!);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Service supprimé avec succès!'),
          ));
          await fetchCategories();
          Navigator.pop(context, true); // Navigate back after deletion
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Échec de la suppression du service.'),
          ));
        }
      } else {
        // Handle case where service name is null or empty
        print('Service name is null or empty');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Service introuvable.'),
        ));
      }
    }
  },
  icon: Icon(Icons.delete),
  label: Text('Supp'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
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
                ),
              );
            },
          );
          }
        }
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigation vers l'écran d'ajout d'un service
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddServiceScreen(category: category),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
       

class ServiceDetailsScreen extends StatelessWidget {
  final Service service;

  ServiceDetailsScreen({required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${service.title ?? 'Service Details'}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display service image if available, else show placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                service.image ?? 'images/telesc.jpeg', // Fallback image
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Service Title
            Text(
              service.title ?? 'No title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Service Subtitle
            Text(
              service.subtitle ?? 'No subtitle available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            // Service Category
            Text(
              'Category: ${service.category ?? 'Uncategorized'}',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 10),
            // Service Description
            Text(
              service.description ?? 'No description available',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Action Buttons (for additional functionalities)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateServiceScreen extends StatefulWidget {
  final ApiService apiService;
  final Service service;

  UpdateServiceScreen({required this.apiService, required this.service});

  @override
  _UpdateServiceScreenState createState() => _UpdateServiceScreenState();
}

class _UpdateServiceScreenState extends State<UpdateServiceScreen> {
  late TextEditingController nameController;
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing service data
    nameController = TextEditingController(text: widget.service.name);
    titleController = TextEditingController(text: widget.service.title);
    subtitleController = TextEditingController(text: widget.service.subtitle);
    descriptionController = TextEditingController(text: widget.service.description);
    categoryController = TextEditingController(text: widget.service.category);
    imageController = TextEditingController(text: widget.service.image);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    nameController.dispose();
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le Service'),
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
    Service updatedService = Service(
      name: nameController.text,
      title: titleController.text,
      subtitle: subtitleController.text,
      description: descriptionController.text,
      category: categoryController.text,
      image: imageController.text,
    );

    // Ensure the name is valid before updating
    if (widget.service.name != null && widget.service.name!.isNotEmpty) {
      final success = await widget.apiService.updateServiceByName(widget.service.name!, updatedService);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Service modifié avec succès!'),
        ));
         await fetchServices(); 
        Navigator.pop(context, true);
           await fetchCategories(); // Navigate back after update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Échec de la modification du service.'),
        ));
      }
    } else {
      // Handle case where service name is null or empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Nom de service introuvable.'),
      ));
    }
  },
  child: Text('Modifier'),
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
