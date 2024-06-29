// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allergic_content_identifier/group_provider.dart';
import 'display_groupicon.dart';

class SelectGroupsScreen extends StatelessWidget {
  final List<String> groups = ['Cardiac Problem', 'Asthma', 'Skin allergy', 'Labored Breathing','Eye Allergy','Pregnancy','Cosmetic Allergy','Allergic Rhintis','Citrus Allergy','Glutten','Milk Allergy','Urticaria','Skin Rashes','Shellfish Allergy'];
  final List<String> iconPaths = [
    'assets/icon1.jpg',
    'assets/icon2.jpg',
    'assets/icon3.jpg',
    'assets/icon4.jpg',
    'assets/icon5.jpg',
    'assets/icon6.png',
    'assets/icon7.jpg',
    'assets/icon9.jpeg',
    'assets/icon10.jpg',
    'assets/icon11.jpg',
    'assets/icon12.jpg',
    'assets/icon13.png',
    'assets/icon14.jpg',
    'assets/icon15.jpg',
  ];

  SelectGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Groups', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            final isSelected = groupProvider.selectedGroups.contains(group);

            return ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayIconScreen(iconPath: iconPaths[index]),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      iconPaths[index],
                      width: 40, // Adjust the size as needed
                      height: 40, // Adjust the size as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              title: Text(
                group,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              trailing: Switch(
                value: isSelected,
                onChanged: (bool value) {
                  if (value) {
                    groupProvider.selectGroup(group);
                  } else {
                    groupProvider.deselectGroup(group);
                  }
                },
                activeColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}
