import 'package:flutter/material.dart';
import 'package:todo_app/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[300],
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Get user input
            TextField(
                controller: controller,
                decoration: InputDecoration(border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
                MyButton(text: 'Cancel', onPressed: onCancel),

                // Add some space
                const SizedBox(width: 8),

                // Save Button
                MyButton(text: 'Save', onPressed: onSave),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
