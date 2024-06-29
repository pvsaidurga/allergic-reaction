import 'package:flutter/material.dart';

class HealthSuggestionsPage extends StatefulWidget {
  const HealthSuggestionsPage({super.key});

  @override
  _HealthSuggestionsPageState createState() => _HealthSuggestionsPageState();
}

class _HealthSuggestionsPageState extends State<HealthSuggestionsPage> {
  final List<String> suggestions = [
    "Stay hydrated by drinking at least 8 cups of water a day.",
    "Exercise regularly to keep your body fit and healthy.",
    "Eat a balanced diet with plenty of fruits and vegetables.",
    "Get enough sleep to help your body recover and stay strong.",
    "Take breaks and manage stress to maintain mental health."
  ];

  final List<bool> _isVisible = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _showSuggestions();
  }

  void _showSuggestions() {
    for (int i = 0; i < suggestions.length; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        setState(() {
          _isVisible[i] = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          bool isEven = index % 2 == 0;
          return Align(
            alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: AnimatedOpacity(
                opacity: _isVisible[index] ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green, // Change message color to green
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isEven ? 0 : 15.0),
                      topRight: Radius.circular(isEven ? 15.0 : 0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    suggestions[index],
                    style: const TextStyle(
                      color: Colors.white, // Ensure text color is visible on green background
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HealthSuggestionsPage(),
  ));
}
