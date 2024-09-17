import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Model for Category
class Category {
  final String name;

  Category({required this.name});

  // Modify the fromJson method to work with plain strings
  factory Category.fromJson(String json) {
    return Category(name: json);
  }
}


// Model for Service
class Service {
  final String? name;
  final String? title;
  final String? subtitle;
  final String? category;
  final String? description;
  final String? image;

  Service({this.name, this.title, this.subtitle, this.category, this.description, this.image});

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

  ServiceScreen({required this.category});

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      label: Text('Show Details'),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
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
        title: Text(service.title ?? 'Service Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the service image in a big format
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  service.image ?? 'images/hst.jpeg', // Default asset in case of null
                  width: double.infinity,
                  height: 250, // Bigger height
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              // Display the service title in bold and large font
              Text(
                service.title ?? 'No Title',
                style: TextStyle(
                  fontSize: 28, // Larger font size
                  fontWeight: FontWeight.bold, // Bold
                ),
              ),
              SizedBox(height: 8),

              // Display the service subtitle normally
              Text(
                service.subtitle ?? 'No Subtitle',
                style: TextStyle(
                  fontSize: 18, // Normal font size
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),

              // Display the category in large format but normal style
              Text(
                'Category: ${service.category ?? 'No Category'}',
                style: TextStyle(
                  fontSize: 20, // Larger font size
                  color: Colors.deepPurple, // To distinguish the category
                ),
              ),
              SizedBox(height: 16),

              // Display the description in large format but normal style
              Text(
                service.description ?? 'No Description',
                style: TextStyle(
                  fontSize: 20, // Larger font size
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      // Add the "Reserver maintenant" button at the bottom center
    );
}
}
