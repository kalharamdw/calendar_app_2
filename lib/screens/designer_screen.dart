import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/design_canvas.dart';
import '../widgets/template_selector.dart';
import '../services/pdf_service.dart';

class DesignerScreen extends StatefulWidget {
  const DesignerScreen({super.key});

  @override
  State<DesignerScreen> createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen> {
  List<File> images = [];
  String brandText = "Your Brand";
  TextStyle font = GoogleFonts.poppins(fontSize: 22);

  Future addImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => images.add(File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Design Your Calendar"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => PdfService.generate(brandText),
          )
        ],
      ),
      body: Column(
        children: [
          TemplateSelector(onTemplateChanged: (_) {}),
          Expanded(
            child: DesignCanvas(
              images: images,
              brandText: brandText,
              font: font,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: addImage,
                  child: const Text("Add Image"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Brand / Title",
                    ),
                    onChanged: (v) => setState(() => brandText = v),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
