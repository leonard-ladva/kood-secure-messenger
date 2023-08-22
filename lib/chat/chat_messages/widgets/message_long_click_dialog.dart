import 'package:flutter/material.dart';
import 'package:relay/chat/chat_messages/widgets/delete_dialog.dart';
import 'package:relay/chat/chat_messages/widgets/edit_dialog.dart';

class LongPressDialogReturnValues {
  const LongPressDialogReturnValues({
    this.delete = false,
    this.edit = false,
    this.newText = '',
  });
  final bool delete;
  final bool edit;
  final String newText;
}

class LongPressDialog extends StatelessWidget {
  const LongPressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit or delete message?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(LongPressDialogReturnValues());
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final doDelete = await showDialog(
              context: context,
              builder: (context) => DeleteDialog(),
            );
            Navigator.of(context).pop(
              LongPressDialogReturnValues(delete: doDelete),
            );
          },
          child: Text('Delete'),
        ),
        TextButton(
          onPressed: () async {
            final returnValues = await showDialog(
              context: context,
              builder: (context) => EditDialog(),
            );
            Navigator.of(context).pop(returnValues);
          },
          child: Text('Edit'),
        ),
      ],
    );
  }
}
