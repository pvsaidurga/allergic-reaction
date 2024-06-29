import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 1'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Content for Screen 1', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 2'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Content for Screen 2', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen 3'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Content for Screen 3', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
