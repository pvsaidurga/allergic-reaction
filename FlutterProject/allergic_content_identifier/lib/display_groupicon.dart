import 'package:flutter/material.dart';

class DisplayIconScreen extends StatelessWidget {
  final String iconPath;

  const DisplayIconScreen({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Icon'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Image.asset(iconPath),
        ),
      ),
    );
  }
}
