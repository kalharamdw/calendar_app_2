import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class PdfService {
  static Future generate(String title) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (_) => pw.Column(
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text("Generated Calendar"),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/calendar.pdf");
    await file.writeAsBytes(await pdf.save());

    await Printing.sharePdf(bytes: await file.readAsBytes());
  }
}
