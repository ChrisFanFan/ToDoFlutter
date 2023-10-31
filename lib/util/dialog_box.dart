import 'package:flutter/material.dart';

import 'my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  VoidCallback onClear;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.onClear,
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
            Row(
              children: [
                Icon(
                  Icons.task,
                  color: Colors.yellow[900],
                ),
                const SizedBox(width: 8),
                Text("NEW TASK")
              ],
            ),

            // get user input
            SizedBox(
              width: 280, // <-- Use Size Box to fix TextField width
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add task...",
                  focusedBorder: OutlineInputBorder(
                    // 指定 focused 後的border顏色與寬度
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                cursorColor: Colors.black, // 指定active 游標顏色
              ),
            ),
            //

            // buttons -> save + cancel + reset
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // save button
                MyButton(text: "Save", onPressed: onSave),
                const SizedBox(width: 8),

                // clear button
                // MyButton(text: "Reset", onPressed: onClear),
                // const SizedBox(width: 8),

                // cancel button
                MyButton(text: "Cancel", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
