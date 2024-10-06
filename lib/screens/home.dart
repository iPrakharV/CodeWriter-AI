import 'package:flutter/material.dart';
import 'generate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GenerateScreen()),
            );
          },
          child: Text('Generate Code'),
        ),
      ),
    );
  }
}