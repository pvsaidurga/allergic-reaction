import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class User {
  final int id; // Assuming you have user ID coming from backend
  final String username;
  final String email;
  final String mobile;
  final String password;
  final String? healthReportFile;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
    required this.password,
    this.healthReportFile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      password: json['password'] ?? '',
      healthReportFile: json['health_report_file'],
    );
  }
}

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  int? get userId => _user?.id; // G

  String get username => _user?.username ?? 'User';

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/login'),
        body: json.encode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _isLoggedIn = true;
        _user = User(
          id: data['id'],
          username: username,
          email: '',  // Update as needed
          mobile: '', // Update as needed
          password: password,
        );
        notifyListeners();
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      // print('Error during login: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String username, String email, String mobile, String currentPassword, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5000/update_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'mobile': mobile,
          'current_password': currentPassword,
          'new_password': newPassword.isEmpty ? currentPassword : newPassword,
        }),
      );

      if (response.statusCode == 200) {
        _user = User(
          id: _user!.id, // Ensure to pass the existing user ID
          username: username,
          email: email,
          mobile: mobile,
          password: newPassword.isEmpty ? currentPassword : newPassword,
          healthReportFile: _user!.healthReportFile, // Maintain existing health report file if not updated
        );
        notifyListeners();
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      // print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> uploadHealthReport(File file) async {
    if (_user == null) {
      throw Exception('User not logged in');
    }

    try {
      var uri = Uri.parse("http://10.0.2.2:5000/uploadhealthrecord");
      var request = http.MultipartRequest("POST", uri);

      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = http.MultipartFile('file', stream, length, filename: basename(file.path));

      request.files.add(multipartFile);
      request.fields['user_id'] = _user!.id.toString(); 
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        _user = User.fromJson(jsonData);
        notifyListeners();
      } else {
        throw Exception('Failed to upload health report');
      }
    } catch (e) {
      // print('Error uploading health report: $e');
      rethrow;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}

