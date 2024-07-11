import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class CreateHealthyDietScreen extends StatefulWidget {
  final int userId;

  CreateHealthyDietScreen({required this.userId});

  _CreateHealthyDietScreenState createState() => _CreateHealthyDietScreenState();
}

class _CreateHealthyDietScreenState extends State<CreateHealthyDietScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String selectedRegion = '';
  String selectedCategory = 'Vegan';

  List<String> regions = ['South India', 'North India'];
  List<String> categories = ['Vegan', 'Vegetarian', 'Non-Vegetarian'];
  bool isEditingAge = false;
  bool isEditingHeight = false;
  bool isEditingWeight = false;
  bool _isLoading = true;
  // bool _hasSavedDietPlan = false;
  // Map<String, dynamic>? _previousDietPlan;

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
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _fetchPreviousDietPlan() async {
  //   final response = await http.get(Uri.parse('http://10.0.2.2:5000/get_previous_diet_plan/${widget.userId}'));

  //   if (response.statusCode == 200) {
  //     final dietPlan = json.decode(response.body);
  //     setState(() {
  //       _previousDietPlan = dietPlan;
  //       _hasSavedDietPlan = true;
  //     });
  //   } else {
  //     setState(() {
  //       _hasSavedDietPlan = false;
  //     });
  //   }
  // }

  void _generateDietPlan() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/create_healthy_diet'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': widget.userId.toString(),
        'age': _ageController.text,
        'height': _heightController.text,
        'weight': _weightController.text,
        'region': selectedRegion,
        'category': selectedCategory,
      }),
    );

    if (response.statusCode == 200) {
      final dietPlan = jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YourHealthyDietPlanScreen(dietPlan: dietPlan, showSaveButton: true, userId: widget.userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate diet plan')),
      );
    }
  }

  void _showNoSavedDietPlanPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Saved Diet'),
          content: Text('There is no saved diet plan available.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openSavedDietPlan() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/get_previous_diet_plan/${widget.userId}'));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final filename = 'diet_plan_${widget.userId}.pdf';

      // Save PDF to temporary directory
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);

      // Open PDF
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(file: file),
        ),
      );
    } else {
      _showNoSavedDietPlanPopup();
    }
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
  }) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8.0),
              ),
              keyboardType: TextInputType.number,
              enabled: isEditing,
            ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.green),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String category, String assetPath, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(35.0),
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(assetPath),
            radius: 35.0,
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(height: 4.0),
        Text(label),
        Radio<String>(
          value: category,
          groupValue: selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
          activeColor: Colors.green,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Create Healthy Diet',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableField(
                    label: 'Your Age',
                    controller: _ageController,
                    isEditing: isEditingAge,
                    onEdit: () {
                      setState(() {
                        isEditingAge = !isEditingAge;
                      });
                    },
                  ),
                  _buildEditableField(
                    label: 'Your Height',
                    controller: _heightController,
                    isEditing: isEditingHeight,
                    onEdit: () {
                      setState(() {
                        isEditingHeight = !isEditingHeight;
                      });
                    },
                  ),
                  _buildEditableField(
                    label: 'Your Weight',
                    controller: _weightController,
                    isEditing: isEditingWeight,
                    onEdit: () {
                      setState(() {
                        isEditingWeight = !isEditingWeight;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedRegion.isEmpty ? null : selectedRegion,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRegion = newValue!;
                        });
                      },
                      items: regions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      underline: Container(),
                      hint: Text('Select Your Region', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select Categories'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryIcon('Vegan', 'assets/icon1.jpg', 'Vegan'),
                      _buildCategoryIcon('Vegetarian', 'assets/icon2.jpg', 'Vegetarian'),
                      _buildCategoryIcon('Non-Vegetarian', 'assets/icon3.jpg', 'Non-Vegetarian'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: _generateDietPlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Generate Now', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  // SizedBox(height: 16.0),
                  // Center(
                  //   child: ElevatedButton(
                  //     onPressed: _openSavedDietPlan,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.green,
                  //     ),
                  //     child: Text('Saved Healthy Diet', style: TextStyle(color: Colors.white)),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }
}

class YourHealthyDietPlanScreen extends StatelessWidget {
  final Map<String, dynamic> dietPlan;
  final bool showSaveButton;
  final int userId;

  YourHealthyDietPlanScreen({required this.dietPlan, required this.showSaveButton, required this.userId});

  Future<void> _saveDietPlan(BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/save_diet_plan'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'user_id': userId,
      'diet_plan': dietPlan,
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Diet plan saved successfully')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save diet plan')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Your Healthy Diet Plan', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: dietPlan.keys.map((day) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('Healthy diet items: ${dietPlan[day]['Diet'].join(', ')}'),
                      Text('Physical Activities Recommended: ${dietPlan[day]['Physical Activities'].join(', ')}'),
                      SizedBox(height: 16.0),
                    ],
                  );
                }).toList(),
              ),
            ),
            if (showSaveButton)
              ElevatedButton(
                onPressed: () => _saveDietPlan(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Save Diet Plan', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final File file;

  PdfViewerScreen({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Saved Diet Plan PDF', style: TextStyle(color: Colors.white)),
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}