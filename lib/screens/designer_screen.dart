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
  List<TextItem> texts = [];
  String userName = "Your Name";

  final ImagePicker _picker = ImagePicker();

  Future<void> addImage() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          images.add(File(picked.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  void addTextBox() {
    setState(() {
      texts.add(TextItem(
        text: "Edit me",
        position: const Offset(50, 50),
        style: GoogleFonts.poppins(fontSize: 22, color: Colors.black),
      ));
    });
  }

  Future<void> downloadPdf() async {
    await PdfService.generateCalendarPdf(
      images: images,
      texts: texts,
      userName: userName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade400,
        title: Text(
          "Design Your Calendar",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: "Download PDF",
            onPressed: downloadPdf,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: DesignCanvas(
                images: images,
                texts: texts,
                userName: userName,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: addImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Add Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade300,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: addTextBox,
                  icon: const Icon(Icons.text_fields),
                  label: const Text("Add Text"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Your Name",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: (val) => setState(() => userName = val),
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
