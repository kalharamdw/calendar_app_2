import 'package:flutter/material.dart';
import 'designer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar Designer")),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.design_services),
          label: const Text("Start Designing"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DesignerScreen()),
            );
          },
        ),
      ),
    );
  }
}
