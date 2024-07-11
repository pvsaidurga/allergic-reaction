import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allergic_content_identifier/user_provider.dart';
import 'package:allergic_content_identifier/group_provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  void _showGroupSelectionAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'Please select at least one group',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                // style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<GroupProvider>(context, listen: false).clearSelectedGroups();
                Provider.of<UserProvider>(context, listen: false).logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // Navigate to login screen
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _onUploadProductImagePressed() async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    if (groupProvider.selectedGroups.isEmpty) {
      _showGroupSelectionAlert();
      return;
    }
    Navigator.pushNamed(
      context,
      '/upload_product_image',
      arguments: {
        'selectedGroups': groupProvider.selectedGroups.toList(), // Ensure it's a List<String>
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context).username ?? "User"; // Assuming UserProvider has a username property
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white), // Set the back button arrow color to white
        title: Text(
          'Hello $username',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Logout') {
                _showLogoutConfirmation(context);
              } else if (value == 'User Account') {
                Navigator.pushNamed(context, '/user_account');
              } else if (value == 'User Health Profile') {
                Navigator.pushNamed(context, '/user_health_profile');
              }
            },
            icon: const Icon(Icons.person, color: Colors.white),
            itemBuilder: (BuildContext context) {
              return {'User Account', 'User Health Profile', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'How can we help you today?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    _buildIconColumn(
                      context,
                      'assets/My Reports.png',
                      'My Reports',
                      '/upload_health_report',
                    ),
                    _buildIconColumn(
                      context,
                      'assets/My Prescriptions.png',
                      'My Prescriptions',
                      '/upload_health_prescription',
                    ),
                    _buildIconColumn(
                      context,
                      'assets/askfordoctor.png',
                      'Ask for Doctor',
                      '/askforDoctor',
                    ),
                    _buildIconColumn(
                      context,
                      'assets/Healthy Diet.png',
                      'Healthy Diet',
                      '/create_healthy_diet',
                    ),
                  ],
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey, spreadRadius: 5)],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.keyboard_arrow_up, size: 30, color: Colors.green),
                              const Text(
                                'Scroll Up',
                                style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/select_groups');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: const Size(250, 50), // Fixed size for buttons
                                ),
                                child: const Text(
                                  'Select Groups',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _onUploadProductImagePressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: const Size(250, 50), // Fixed size for buttons
                                ),
                                child: const Text(
                                  'Upload Product Image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconColumn(BuildContext context, String assetPath, String label, String route) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, route);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(50), // Adjust the radius for rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50), // Ensure the image also has rounded corners
                child: Image.asset(assetPath),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ],
    );
  }
}
