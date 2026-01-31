import 'dart:io';
import 'package:flutter/material.dart';
import 'calendar_widget.dart';

class DesignCanvas extends StatelessWidget {
  final List<File> images;
  final String brandText;
  final TextStyle font;

  const DesignCanvas({
    super.key,
    required this.images,
    required this.brandText,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (images.isNotEmpty)
            SizedBox(
              height: 180,
              child: PageView(
                children: images
                    .map((img) => Image.file(img, fit: BoxFit.cover))
                    .toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(brandText, style: font),
          ),
          Expanded(child: CalendarWidget()),
        ],
      ),
    );
  }
}
