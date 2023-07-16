import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kynaara_frontend/utils/constants/ui_text_constants.dart';

class SessionExpiredDialog extends StatelessWidget {
  final Function callback;
  const SessionExpiredDialog({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(UITextConstants.sessionExpired),
      content: Text(UITextConstants.userLoggedOut),
      actions: <Widget>[
        TextButton(
          onPressed: (){
            if(context.mounted) {
              Navigator.pop(context);
            }
            callback();
          },
          child: const Text('Go To Login Page'),
        ),
      ],
    );
  }
}
