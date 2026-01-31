import 'package:flutter/material.dart';

class TemplateSelector extends StatelessWidget {
  final Function(String) onTemplateChanged;

  const TemplateSelector({super.key, required this.onTemplateChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _templateButton("Modern"),
          _templateButton("Minimal"),
          _templateButton("Business"),
        ],
      ),
    );
  }

  Widget _templateButton(String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => onTemplateChanged(name),
        child: Text(name),
      ),
    );
  }
}
