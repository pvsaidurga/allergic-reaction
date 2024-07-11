import 'package:flutter/material.dart';



class Askfordoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.local_hospital, color: Colors.white),
                  label: Text('Clinic Visit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.home, color: Colors.white),
                  label: Text('Home Visit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'What are your symptoms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SymptomOption('Option1'),
                  SymptomOption('Option2'),
                  SymptomOption('Option3'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(6, (index) {
                  return SymptomIcon(
                    iconPath: 'assets/makeuse${index + 1}.jpg',
                    label: 'Name${index + 1}',
                    buttonText: index < 3 ? 'Book Appointment' : 'Request a Call',
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomOption extends StatelessWidget {
  final String label;

  SymptomOption(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class SymptomIcon extends StatelessWidget {
  final String iconPath;
  final String label;
  final String buttonText;

  SymptomIcon({required this.iconPath, required this.label, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            iconPath,
            width: 80,
            height: 80,
          ),
        ),
        SizedBox(height: 8),
        Text(label),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          child: Text(buttonText),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
