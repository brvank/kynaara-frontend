import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kynaara_frontend/data/model/user.dart';
import 'package:kynaara_frontend/utils/constants/ui_text_constants.dart';
import 'package:kynaara_frontend/utils/constants/utility_functions.dart';

class UserDetailsDialog extends StatelessWidget {
  final bool self;
  final User user;
  final Function? callback;
  const UserDetailsDialog({Key? key, required this.user, required this.self, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userLevel = "";

    if(user.userLevel == 1){
      userLevel = superAdmin;
    }else if(user.userLevel == 2){
      userLevel = admin;
    }else if(user.userLevel == 3){
      userLevel = salesPerson;
    }

    List<Widget> actions = [];
    if(self){
      actions.add(TextButton(
        onPressed: (){
          if(context.mounted) {
            Navigator.pop(context);
          }
          if(callback != null){
            callback!();
          }
        },
        child: const Text('Logout'),
      ));
    }

    return AlertDialog(
      title: Text("User Info"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("User Name: "),
              Text(user.userName),
            ],
          ),
          Row(
            children: [
              Text("Full Name: "),
              Text(user.name),
            ],
          ),
          Row(
            children: [
              Text("Email: "),
              Text(user.email),
            ],
          ),
          Row(
            children: [
              Text("User level: "),
              Text(userLevel),
            ],
          ),
        ],
      ),
      actions: actions,
    );
  }

}
