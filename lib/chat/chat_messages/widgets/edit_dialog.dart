import 'package:flutter/material.dart';
import 'package:relay/chat/chat_messages/widgets/message_long_click_dialog.dart';


class EditDialog extends StatelessWidget {
  EditDialog({super.key});
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit message'),
      content: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Edited Message',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(LongPressDialogReturnValues());
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(LongPressDialogReturnValues(
              edit: true,
              newText: textEditingController.text,
            ));
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}

