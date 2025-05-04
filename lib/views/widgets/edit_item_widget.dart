import 'package:flutter/material.dart';

class EditItemWidget extends StatelessWidget {
  const EditItemWidget({
    super.key,
    required this.initialValue,
    required this.onSave,
    this.title = "Edit Item",
  });

  final String initialValue;
  final Function(String newValue) onSave;
  final String title;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Enter new Text",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final trimmed = controller.text.trim();
            if (trimmed.isNotEmpty) {
              onSave(trimmed);
            }
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
