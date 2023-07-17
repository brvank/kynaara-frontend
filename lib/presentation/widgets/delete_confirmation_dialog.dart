import 'package:flutter/material.dart';
import 'package:kynaara_frontend/utils/constants/ui_text_constants.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(UITextConstants.deleteConfirmation),
      actions: [
        TextButton(
          child: Text("No"),
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: Text("Yes"),
          onPressed: (){
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }
}
