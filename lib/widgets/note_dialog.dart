import 'package:flutter/material.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Note'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Add note about gear here...',
          border: OutlineInputBorder(),
        ),
        maxLines: 5,
        minLines: 3,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close dialog without returning anything
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Return the text input to the calling widget
            Navigator.of(context).pop(_controller.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
