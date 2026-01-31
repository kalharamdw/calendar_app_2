import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../widgets/design_canvas.dart';

class PdfService {
  static Future<void> generateCalendarPdf({
    required List<File> images,
    required List<TextItem> texts,
    required String userName,
  }) async {
    final pdf = pw.Document();

    // We will generate one **page per month** for a full year
    for (int month = 1; month <= 12; month++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                if (images.isNotEmpty)
                  pw.Positioned.fill(
                    child: pw.Image(
                      pw.MemoryImage(images.last.readAsBytesSync()),
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                pw.Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: pw.Column(
                    children: [
                      pw.Text(
                        "$month/${DateTime.now().year}",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        userName,
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Editable texts
                for (var t in texts)
                  pw.Positioned(
                    left: t.position.dx,
                    top: t.position.dy,
                    child: pw.Text(
                      t.text,
                      style: pw.TextStyle(
                        fontSize: t.style.fontSize?.toDouble() ?? 20,
                        color: PdfColor.fromInt(
                          (t.style.color ?? Colors.black).value,
                        ),
                      ),
                    ),
                  ),
                // Dates table
                pw.Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: pw.Container(
                    height: 400,
                    child: _buildMonthCalendar(month),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static pw.Widget _buildMonthCalendar(int month) {
    // Generate simple 7x5 grid of dates for PDF
    final now = DateTime.now();
    final firstDay = DateTime(now.year, month, 1);
    final lastDay = DateTime(now.year, month + 1, 0);
    final days = List.generate(lastDay.day, (i) => i + 1);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          children: List.generate(7, (i) => pw.Center(child: pw.Text(["Sun","Mon","Tue","Wed","Thu","Fri","Sat"][i], style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
        ),
        ...List.generate((days.length / 7).ceil(), (rowIndex) {
          return pw.TableRow(
            children: List.generate(7, (colIndex) {
              int dayIndex = rowIndex * 7 + colIndex;
              return pw.Container(
                height: 30,
                alignment: pw.Alignment.center,
                child: dayIndex < days.length ? pw.Text(days[dayIndex].toString()) : pw.Text(""),
              );
            }),
          );
        }),
      ],
    );
  }
}
