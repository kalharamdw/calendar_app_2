import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart'; // <-- important for PdfColor and PdfColors
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import '../widgets/design_canvas.dart'; // For TextItem

class PdfService {
  static Future<void> generateCalendar(
      List<File> images, List<TextItem> texts) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // IMAGES
              for (int i = 0; i < images.length; i++)
                pw.Positioned(
                  left: 50,
                  top: 50.0 + i * 160,
                  child: pw.Image(
                    pw.MemoryImage(images[i].readAsBytesSync()),
                    width: 150,
                    height: 150,
                  ),
                ),

              // TEXT BOXES
              for (var textItem in texts)
                pw.Positioned(
                  left: textItem.position.dx,
                  top: textItem.position.dy,
                  child: pw.Text(
                    textItem.text,
                    style: pw.TextStyle(
                      fontSize: textItem.style.fontSize ?? 22,
                      fontWeight: _mapFontWeight(textItem.style.fontWeight),
                      color: _mapColor(textItem.style.color),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/calendar.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(bytes: await file.readAsBytes(), filename: 'calendar.pdf');
  }

  // Map Flutter Color to Pdf Color
  static PdfColor _mapColor(Color? color) {
    if (color == null) return PdfColors.black;
    return PdfColor.fromInt(color.value);
  }

  // Map Flutter FontWeight to Pdf FontWeight
  static pw.FontWeight _mapFontWeight(FontWeight? fw) {
    if (fw == FontWeight.bold) return pw.FontWeight.bold;
    return pw.FontWeight.normal;
  }
}
