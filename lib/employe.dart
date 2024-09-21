import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class EmployeeService {
  final String baseUrl = 'http://localhost:8080/employee'; // Ensure this is correct and reachable

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<Employee>> fetchEmployees() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/all'),
      
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

Future<void> deleteEmployee(String employeeId) async {
    final accessToken = await getAccessToken();
    
    final decodedToken = JwtDecoder.decode(accessToken!);
    print('Decoded token: $decodedToken');

    String role = decodedToken['role'];

    if (role != 'ADMIN') {
        print('Access denied, role: $role');
        throw Exception('Access denied. Only admins can delete employees.');
    }
    print('User has ADMIN role, proceeding with deletion');

    print('Deleting employee with ID: $employeeId');

    if (employeeId.isEmpty) {
        print('Error: Employee ID is empty!');
        throw Exception('Employee ID is empty');
    }

    print('Requesting DELETE URL: $baseUrl/delete/$employeeId');

    final response = await http.delete(
        Uri.parse('$baseUrl/delete/$employeeId'),
        headers: {
            'Authorization': 'Bearer $accessToken',
        },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 204) {
        print('Employee deleted successfully.');
    } else {
        String errorMessage = 'Failed to delete employee. Status: ${response.statusCode}, Body: ${response.body}';
        print(errorMessage);
        throw Exception(errorMessage);
    }
}
Future<void> addEmployee(Employee employee) async {
  final accessToken = await getAccessToken();
  final response = await http.post(
    Uri.parse('$baseUrl/add'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: json.encode({
      'username': employee.username,
      'email': employee.email,
      'password': employee.password,
      'role': "EMPLOYEE",
      'address': employee.address,
      'position': employee.position,
    }),
  );

  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}'); // Print response body for debugging

  if (response.statusCode != 201) {
    throw Exception('Failed to add employee: ${response.body}');
  }
}

Future<void> modifyEmployee(Employee employee) async {
  final accessToken = await getAccessToken();
  
  // Decode the JWT token
  final decodedToken = JwtDecoder.decode(accessToken!);
  print('Decoded token: $decodedToken');

  // Ensure you're accessing the role correctly
  String userRole = decodedToken['role'];

  // Check if the user has admin role
  if (userRole != 'ADMIN') {
    print('Access denied, role: $userRole');
    throw Exception('Access denied. Only admins can modify employees.');
  }
  print('User has ADMIN role, proceeding with modification');

  print('Attempting to modify employee with ID: ${employee.id}');
  print('Employee details: ${json.encode(employee.toJson())}');

  final response = await http.put(
    Uri.parse('$baseUrl/update/${employee.id}'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: json.encode(employee.toJson()),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    print('Employee modified successfully.');
  } else {
    String errorMessage = 'Failed to modify employee. Status: ${response.statusCode}, Body: ${response.body}';
    print(errorMessage);
    throw Exception(errorMessage);
  }
}
Future<void> checkUserRole() async {
  final accessToken = await getAccessToken();
  if (accessToken != null) {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    String role = decodedToken['role'];
    
    print('User role: $role');
    
    if (role == 'ADMIN') {
      // Proceed with actions that require admin role
      print('User is an admin.');
    } else {
      print('User is not an admin.');
    }
  } else {
    print('No access token found.');
  }
}

}

class Employee {
  final String id;
  final String username;
  final String? email;
  final String? role;
  final String? password;
  final String? address;
  final String? position;

  Employee({
    required this.id,
    required this.username,
    this.email,
    this.password,
    this.role,
    this.address,
    this.position,
  });

 factory Employee.fromJson(Map<String, dynamic> json) {
  return Employee(
    id: json['_id'] is String && json['_id'].startsWith('ObjectId(')
        ? json['_id'].substring(10, 26) // Extracting the ID string from ObjectId('66edb84c5fcec57c6412cc10')
        : json['_id'] is Map<String, dynamic> && json['_id'].containsKey('\$oid')
            ? json['_id']['\$oid']
            : json['id'] ?? '',  // Fallback if neither format is found
    username: json['username'] ?? '',
    email: json['email'],
    password: json['password'],
    role: json['role'],
    address: json['address'],
    position: json['position'],
  );
}

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'address': address,
      'position': position,
    };
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

  void _deleteEmployee(String Id) async {
    try {
        await EmployeeService().deleteEmployee(Id);
        setState(() {
            _employeesFuture = EmployeeService().fetchEmployees(); // Refresh the list
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee deleted successfully')));
    } catch (e) {
        print('Exception occurred while deleting employee: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete employee: $e')));
    }
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
          ).then((_) {
            setState(() {
              _employeesFuture = EmployeeService().fetchEmployees(); // Refresh the list
            });
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
        tooltip: 'Add Employee',
      ),
    );
  }

  List<Widget> _buildActionButtons(Employee employee, int index) {
    List<Widget> actionButtons = [];

    actionButtons.add(_buildActionButton(Icons.visibility, 'View', () {
      // View action
    }));

    actionButtons.add(_buildActionButton(Icons.edit, 'Modify', () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ModifyEmployeeScreen(employee: employee)),
      ).then((_) {
        setState(() {
          _employeesFuture = EmployeeService().fetchEmployees(); // Refresh the list
        });
      });
    }));

    actionButtons.add(_buildActionButton(Icons.delete, 'Delete', () {
      _deleteEmployee(employee.id);
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

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _positionController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newEmployee = Employee(
        id: '', // id will be generated by the server
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
  
        address: _addressController.text,
        position: _positionController.text,
      );

      try {
        await EmployeeService().addEmployee(newEmployee);
        Navigator.pop(context);
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add employee')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a username' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter an email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a password' : null,
              ),
       
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Position'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModifyEmployeeScreen extends StatefulWidget {
  final Employee employee;

  ModifyEmployeeScreen({required this.employee});

  @override
  _ModifyEmployeeScreenState createState() => _ModifyEmployeeScreenState();
}

class _ModifyEmployeeScreenState extends State<ModifyEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late TextEditingController _addressController;
  late TextEditingController _positionController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.employee.username);
    _emailController = TextEditingController(text: widget.employee.email);
    _passwordController = TextEditingController(text: widget.employee.password);
  
    _addressController = TextEditingController(text: widget.employee.address);
    _positionController = TextEditingController(text: widget.employee.position);
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedEmployee = Employee(
        id: widget.employee.id,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        address: _addressController.text,
        position: _positionController.text,
      );

      try {
        await EmployeeService().modifyEmployee(updatedEmployee);
        Navigator.pop(context);
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to modify employee')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Employee'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a username' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter an email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a password' : null,
              ),
             
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Position'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Modify Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
