import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserHealthProfileScreen extends StatefulWidget {
  final int userId;

  UserHealthProfileScreen({required this.userId});

  @override
  _UserHealthProfileScreenState createState() => _UserHealthProfileScreenState();
}

class _UserHealthProfileScreenState extends State<UserHealthProfileScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _blood_groupController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserHealthDetails();
  }

  Future<void> _fetchUserHealthDetails() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/get_user_health_details/${widget.userId}'));

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        _ageController.text = userData['age'];
        _heightController.text = userData['height'];
        _weightController.text = userData['weight'];
        _blood_groupController.text = userData['blood_group'];
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserHealthDetails() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/update_user_health_details'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': widget.userId,
        'age': _ageController.text,
        'height': _heightController.text,
        'weight': _weightController.text,
        'blood_group': _blood_groupController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Health details updated successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user health details')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Health Profile',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Your Age',
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.edit, color: Colors.green),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: 'Your Height',
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.edit, color: Colors.green),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: 'Your Weight',
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.edit, color: Colors.green),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _blood_groupController,
                      decoration: InputDecoration(
                        labelText: 'Your Blood Group',
                        labelStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.edit, color: Colors.green),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateUserHealthDetails,
                    child: Text(
                      'Update Details',
                      style: TextStyle(color: Colors.white), // Set button text color to white
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Set button background color
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
