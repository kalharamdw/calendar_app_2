import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/design_canvas.dart';
import '../services/pdf_service.dart';

class DesignerScreen extends StatefulWidget {
  const DesignerScreen({super.key});

  @override
  State<DesignerScreen> createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen> {
  List<File> images = [];
  List<TextItem> texts = []; // Multiple text boxes
  final ImagePicker _picker = ImagePicker();

  // Add an image from gallery
  Future<void> addImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        images.add(File(picked.path));
      });
    }
  }

  // Add a new text box
  void addTextBox() {
    setState(() {
      texts.add(TextItem(
        text: "New Text",
        position: const Offset(50, 50),
        style: GoogleFonts.poppins(fontSize: 22, color: Colors.black),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Design Your Calendar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              if (images.isEmpty && texts.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Add images or text first!")),
                );
                return;
              }
              await PdfService.generateCalendar(images, texts);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DesignCanvas(
              images: images,
              texts: texts,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: addImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Add Image"),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: addTextBox,
                  icon: const Icon(Icons.text_fields),
                  label: const Text("Add Text"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
