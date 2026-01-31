import 'dart:io';
import 'package:flutter/material.dart';
import 'calendar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class TextItem {
  String text;
  Offset position;
  TextStyle style;

  TextItem({required this.text, required this.position, required this.style});
}

class DesignCanvas extends StatefulWidget {
  final List<File> images;
  final List<TextItem> texts;
  final String userName;

  const DesignCanvas({
    super.key,
    required this.images,
    required this.texts,
    required this.userName,
  });

  @override
  State<DesignCanvas> createState() => _DesignCanvasState();
}

class _DesignCanvasState extends State<DesignCanvas> {
  List<Offset> imagePositions = [];
  List<double> imageScales = [];

  @override
  void initState() {
    super.initState();
    imagePositions = List.generate(widget.images.length, (_) => const Offset(0, 0));
    imageScales = List.generate(widget.images.length, (_) => 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              // Background image for calendar
              if (widget.images.isNotEmpty)
                Positioned.fill(
                  child: Image.file(
                    widget.images.last,
                    fit: BoxFit.cover,
                  ),
                ),

              // Editable texts on top
              for (int i = 0; i < widget.texts.length; i++)
                Positioned(
                  left: widget.texts[i].position.dx,
                  top: widget.texts[i].position.dy,
                  child: DraggableTextBox(
                    textItem: widget.texts[i],
                    onUpdate: (newTextItem) {
                      setState(() {
                        widget.texts[i] = newTextItem;
                      });
                    },
                  ),
                ),

              // Calendar in center
              Align(
                alignment: Alignment.center,
                child: CalendarWidget(
                  userName: widget.userName,
                  focusedDay: DateTime.now(),
                  backgroundImage: widget.images.isNotEmpty
                      ? FileImage(widget.images.last)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Draggable and editable text
class DraggableTextBox extends StatefulWidget {
  final TextItem textItem;
  final Function(TextItem) onUpdate;

  const DraggableTextBox({
    super.key,
    required this.textItem,
    required this.onUpdate,
  });

  @override
  State<DraggableTextBox> createState() => _DraggableTextBoxState();
}

class _DraggableTextBoxState extends State<DraggableTextBox> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.textItem.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          widget.textItem.position += details.delta;
          widget.onUpdate(widget.textItem);
        });
      },
      child: SizedBox(
        width: 200,
        child: TextField(
          controller: controller,
          style: widget.textItem.style,
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (val) {
            widget.textItem.text = val;
            widget.onUpdate(widget.textItem);
          },
        ),
      ),
    );
  }
}
