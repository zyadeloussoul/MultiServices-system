import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'employe.dart';

// Function to get the access token
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');
  return token;
}

// Fetch current user from the API
Future<Map<String, dynamic>> fetchCurrentUser() async {
  final accessToken = await getToken();

  if (accessToken == null) {
    throw Exception('Token not found');
  }

  final response = await http.get(
    Uri.parse('http://localhost:8080/user/me'), // Update to your actual API endpoint
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load user data');
  }
}

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: AdminDrawer(),
      body: AdminDashboardBody(),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error handling
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('images/logo.png'), // Add your avatar image
                      ),
                      SizedBox(height: 10),
                      Text(
                        user['username'] ?? 'Admin Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user['email'] ?? 'admin@example.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  onTap:  () => _navigateTo(context, AdminDashboard()), 
                ),
                   ListTile(
                     leading: Icon(Icons.supervised_user_circle),
                    title: Text('Nos Services'),
              onTap: () async {
  try {
    List<Category> categories = await fetchCategories();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryScreen(categories: categories),
      ),
    );
  } catch (e) {
    print('Error: $e');
  }
},

                  ),
                ListTile(
                  leading: Icon(Icons.person_off_outlined),
                  title: Text('Les employées'),
                  onTap: () => _navigateTo(context, EmployeesScreen()),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    // Handle logout
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          } else {
            return Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

class AdminDashboardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            // Quick stats section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardCard(
                  icon: Icons.group,
                  title: 'Users',
                  value: '1500',
                  color: Colors.orange,
                ),
                DashboardCard(
                  icon: Icons.receipt,
                  title: 'Transactions',
                  value: '2300',
                  color: Colors.green,
                ),
                DashboardCard(
                  icon: Icons.support_agent,
                  title: 'Support Tickets',
                  value: '75',
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 35),
            // Task progress section
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            // Dashboard charts or additional elements
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Tasks Completion',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.grey[200],
                    color: Colors.blueAccent,
                  ),
                  SizedBox(height: 10),
                  Text('75% Complete'),
                ],
              ),
            ),
            SizedBox(height: 40),
            // Subtitle
            Container(
              padding: EdgeInsets.all(25.0),
              color: Colors.yellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.smileBeam,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '99%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Clients satisfaits',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.projectDiagram,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '346',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'Projets achevés',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.calendarAlt,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '5',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          'ans d\'expérience',
                          style: TextStyle(
                            fontSize: 16,
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center,color :Colors.blueAccent),
            label: 'Nos Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info,color :Colors.blueAccent),
            label: 'À Propos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color :Colors.blueAccent),
            label: 'Profil',
          ),
        ],
        onTap: (index) async {
          switch (index) {
            case 0:
            /*  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break; */
            case 1:
              try {
                // Fetch categories and navigate to the CategoryScreen
                List<Category> categories = await fetchCategories();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(categories: categories),
                  ),
                );
              } catch (e) {
                print('Error: $e');
              }
              break;
            case 2:
              /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Apropos()),
              );*/
              break;
            case 3:
             /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfilePage()),
              );
              break;*/
          }
        },
      ),
    );
  }
}


        
class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 45, color: color),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
