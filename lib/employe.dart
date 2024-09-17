import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EmployeeService {
  final String baseUrl = 'http://localhost:8080/employee'; // Ensure this is correct and reachable

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }
}

class Employee {
  final String id;
  final String username;
  final String? email;
  final String? role; // Adjust if the role is an enum or different data type
  final String? address;
  final String? position;

  Employee({
    required this.id,
    required this.username,
    this.email,
    this.role,
    this.address,
    this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'] ?? '', // Provide default values if needed
      username: json['username'] ?? '',
      email: json['email'],
      role: json['role'],
      address: json['address'],
      position: json['position'],
    );
  }
}

class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  late Future<List<Employee>> _employeesFuture;

  @override
  void initState() {
    super.initState();
    _employeesFuture = EmployeeService().fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Employee>>(
        future: _employeesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No employees found', style: TextStyle(color: Colors.grey)));
          } else {
            final employees = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(employee.username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text('Position: ${employee.position ?? 'N/A'}', style: TextStyle(color: Colors.grey[600])),
                            SizedBox(height: 2),
                            Text('Address: ${employee.address ?? 'N/A'}', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      // Action buttons for each employee
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: _buildActionButtons(employee, index),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Employee screen or open a dialog
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
        tooltip: 'Ajouter Employee',
      ),
    );
  }

  List<Widget> _buildActionButtons(Employee employee, int index) {
    List<Widget> actionButtons = [];
    
    // Example: Give different employees different sets of buttons
    if (index % 2 == 0) {
      actionButtons.add(_buildActionButton(Icons.visibility, 'View', () {
        // View action
      }));
    }
    
    actionButtons.add(_buildActionButton(Icons.edit, 'Modify', () {
      // Modify action
    }));
    
    actionButtons.add(_buildActionButton(Icons.delete, 'Delete', () {
      // Delete action
    }));

    return actionButtons;
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.teal, // Button color
          backgroundColor: Colors.white, // Text and icon color
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
