import 'dart:io';
import 'package:flutter/material.dart';
import 'calendar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignCanvas extends StatefulWidget {
  final List<File> images;
  final List<TextItem> texts; // Multiple text boxes

  const DesignCanvas({
    super.key,
    required this.images,
    required this.texts,
  });

  @override
  State<DesignCanvas> createState() => _DesignCanvasState();
}

class TextItem {
  String text;
  Offset position;
  TextStyle style;

  TextItem({required this.text, required this.position, required this.style});
}

class _DesignCanvasState extends State<DesignCanvas> {
  final List<String> availableFonts = [
    "Poppins",
    "Roboto",
    "Lobster",
    "Montserrat",
    "Open Sans",
  ];

  // For image drag & resize
  List<Offset> imagePositions = [];
  List<double> imageScales = [];

  @override
  void initState() {
    super.initState();
    imagePositions = List.generate(widget.images.length, (_) => const Offset(0, 0));
    imageScales = List.generate(widget.images.length, (_) => 1.0);
  }

  TextStyle _getFontStyle(String fontName) {
    switch (fontName) {
      case "Poppins":
        return GoogleFonts.poppins(fontSize: 22);
      case "Roboto":
        return GoogleFonts.roboto(fontSize: 22);
      case "Lobster":
        return GoogleFonts.lobster(fontSize: 22);
      case "Montserrat":
        return GoogleFonts.montserrat(fontSize: 22);
      case "Open Sans":
        return GoogleFonts.openSans(fontSize: 22);
      default:
        return GoogleFonts.poppins(fontSize: 22);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Calendar in background
                const Positioned.fill(child: CalendarWidget()),

                // Drag & resize images
                for (int i = 0; i < widget.images.length; i++)
                  Positioned(
                    left: imagePositions[i].dx + 50,
                    top: imagePositions[i].dy + 50,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          imagePositions[i] += details.delta;
                        });
                      },
                      onScaleUpdate: (details) {
                        setState(() {
                          imageScales[i] = details.scale.clamp(0.5, 3.0);
                        });
                      },
                      child: Transform.scale(
                        scale: imageScales[i],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(widget.images[i], width: 150, height: 150, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),

                // Drag & move text boxes
                for (var textItem in widget.texts)
                  Positioned(
                    left: textItem.position.dx,
                    top: textItem.position.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          textItem.position += details.delta;
                        });
                      },
                      child: Text(
                        textItem.text,
                        style: textItem.style,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // FONT SELECTOR
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: availableFonts.length,
              itemBuilder: (context, index) {
                String fontName = availableFonts[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.texts.isNotEmpty) {
                        widget.texts.last.style = _getFontStyle(fontName);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        fontName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
