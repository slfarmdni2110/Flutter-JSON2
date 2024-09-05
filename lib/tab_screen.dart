import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMK Negeri 4 - Mobile Apps',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        hintColor: Colors.pink[200],
      ),
      home: TabScreen(),
    );
  }
}

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4 - Mobile Apps'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Beranda'),
              Tab(icon: Icon(Icons.person), text: 'Users'),
              Tab(icon: Icon(Icons.person), text: 'Profil'),
            ],
            labelColor: Colors.pink[400],
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.pink[400],
          ),
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school, 'label': 'School'},
    {'icon': Icons.book, 'label': 'Courses'},
    {'icon': Icons.event, 'label': 'Events'},
    {'icon': Icons.notifications, 'label': 'Notifications'},
    {'icon': Icons.assignment, 'label': 'Assignments'},
    {'icon': Icons.chat, 'label': 'Chat'},
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.help, 'label': 'Help'},
    {'icon': Icons.map, 'label': 'Map'},
    {'icon': Icons.calendar_today, 'label': 'Calendar'},
    {'icon': Icons.contact_phone, 'label': 'Contact'},
    {'icon': Icons.info, 'label': 'Info'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              // Handle tap on the menu icon
              print('${item['label']} tapped');
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 50.0, color: Colors.pink[400]),
                    SizedBox(height: 8.0),
                    Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UsersTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 5.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user.firstName[0]), // Placeholder for profile image
                    ),
                    title: Text(user.firstName),
                    subtitle: Text(user.email),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Salfa Ramadani',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Email: salfaramadani3@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Biodata',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 1.5),
          Card(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            elevation: 3.0,
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.pink[400]),
              title: Text('Salfa Ramadani'),
              subtitle: Text('Student'),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            elevation: 3.0,
            child: ListTile(
              leading: Icon(Icons.cake, color: Colors.pink[400]),
              title: Text('Tanggal Lahir'),
              subtitle: Text('21 Oktober 2006'),
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String firstName;
  final String email;

  User({required this.firstName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}